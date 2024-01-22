import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/subdistrict_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/user.dart';

import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/field_provider.dart';
import 'package:mun_bot/screen/field/new_field_screen.dart';
import 'package:mun_bot/screen/field/update_surveyor_screen.dart';
import 'package:mun_bot/screen/login/app_styles.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/widget/loading.dart';

import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../util/size_config.dart';

import 'package:intl/intl.dart';

import '../main_screen.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class FieldMoreDetailScreen extends StatefulWidget {
  final Field fields;
  final User owner;
  final FieldData fieldData;
  final ImageData? image;
  FieldProviders fieldProviders;
  FieldMoreDetailScreen(
      this.fields, this.owner, this.fieldData, this.image, this.fieldProviders);

  @override
  State<StatefulWidget> createState() => _FieldMoreDetailScreen();
}

class _FieldMoreDetailScreen extends State<FieldMoreDetailScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isVisible = true;
  String storyImage = 'assets/images/cassava_field.jpg';
  AnimationController? animationController;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List<Planting> platingList = [];

  int page = 1;
  int check = 0;
  SampleItem? selectedMenu;
  // editable
  bool editable = false;

  // FOR UPDATE GPS
  Position? _currentPosition;

  // Subdistrict ID
  int? subdistrictID;

  // location
  String location = "";

  // SETTING DEFAULT
  String? token = tokenFromLogin?.token;
  FieldService fieldService = FieldService();
  SubdistrictService subdistrictService = new SubdistrictService();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1140), vsync: this);
    onLoad();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    animationController?.dispose();
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final location_granted = await Permission.location.isGranted;
      if (location_granted) {
        // print("Resume with Location");
        Navigator.of(context).pop();
      }
    }
  }

  onLoad() async {
    // log("field id : ${widget.fields.fieldID}");
    editable = await fieldService.getEditableFieldID(
        widget.fields.fieldID, token.toString());
    String fieldString = jsonEncode(widget.fields);
    // await _getCurrentLocation();
    int? subdistrictIDValue = await subdistrictService.getSubdistrictByUserId(
        token.toString(), widget.owner.userID);
    setState(() {
      subdistrictID = subdistrictIDValue;
    });
  }

  Future<void> submitUpdateGPS() async {
    var updateData = {};
    if (_currentPosition != null) {
      updateData = {
        "address": widget.fields.address,
        "code": widget.fields.code,
        "fieldId": widget.fields.fieldID,
        "landmark": widget.fields.landmark,
        "latitude": _currentPosition!.latitude,
        "longitude": _currentPosition!.longitude,
        "metresAboveSeaLv": widget.fields.metresAboveSeaLv,
        "moo": widget.fields.moo,
        "name": widget.fields.name,
        "road": widget.fields.road,
        "size": widget.fields.size,
        "status": widget.fields.status,
        "subdistrict": subdistrictID,
        "userinfields": widget.owner.userID
      };
    } else {
      updateData = {
        "address": widget.fields.address,
        "code": widget.fields.code,
        "fieldId": widget.fields.fieldID,
        "landmark": widget.fields.landmark,
        "latitude": widget.fields.latitude,
        "longitude": widget.fields.longtitude,
        "metresAboveSeaLv": widget.fields.metresAboveSeaLv,
        "moo": widget.fields.moo,
        "name": widget.fields.name,
        "road": widget.fields.road,
        "size": widget.fields.size,
        "status": widget.fields.status,
        "subdistrict": subdistrictID,
        "userinfields": widget.owner.userID
      };
    }
    // print("Show buttom Screen");

    int statusUpdateField =
        await fieldService.updateField(token.toString(), updateData);
    if (statusUpdateField == 200) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (BuildContext context) {
          return MainScreen();
        },
      ));
      CustomLoading.showSuccess();
    } else {
      CustomLoading.showError(
          context, 'Something went wrong. Please try again later.');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('gps-off-alert'.i18n())));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        showAlertDialog_Location(context);

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      var statusLocation = await Permission.location.status;
      print("status : ${statusLocation}");
      if (statusLocation.isDenied) {
        showAlertDialog_Location(context);
      }
      return false;
    }
    return true;
  }

  showAlertDialog_Location(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Permission Denied"),
          content: Text('Allow access to location'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => openAppSettings(),
                child: Text('Settings')),
          ],
        ),
      );
  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    if (!hasPermission) return;
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  Widget pictureUI(int id) {
    return widget.image != null
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.27,
            child: AspectRatio(
              aspectRatio: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.memory(
                  base64Decode(widget.image!.imgBase64),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : Container(
            width: 0,
            height: 0,
          );
  }

  Widget _buildListView() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(sizeWidth(10, context)),
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight! *1.0,
          child: GestureDetector(
            onTap: () {},
            child: AspectRatio(
              aspectRatio: 1.7 / 2,
              child: Container(
                child: Container(
                  padding: EdgeInsets.all(sizeWidth(15, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      pictureUI(widget.fields.fieldID),
                      SizedBox(
                        height: sizeHeight(10, context),
                      ),
                      buildReadOnlyField("code-field-label".i18n(),
                          widget.fields.code.toString(), Icons.vpn_key_sharp),
                      SizedBox(
                        height: sizeHeight(10, context),
                      ),
                      buildReadOnlyField("name-field-label".i18n(),
                          widget.fields.name.toString(), Icons.grass),
                      SizedBox(
                        height: sizeHeight(10, context),
                      ),
                      buildReadOnlyOwner(
                          "owner".i18n(), widget.owner, Icons.person),
                      buildReadOnlyAddress("Address".i18n(),
                          widget.fieldData.location, Icons.location_on_sharp),
                      SizedBox(
                        height: sizeHeight(10, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(sizeWidth(10,
                                  context)), // Adjust the radius value as needed
                            ),
                            elevation: 8,
                            color: theme_color4.withOpacity(0.9),
                            child: Container(
                              height: sizeHeight(114, context),
                              width: sizeWidth(160, context),
                              padding: EdgeInsets.all(sizeWidth(15, context)),
                              child: Column(
                                children: [
                                  Text(
                                    widget.fields.size.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(25, context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight(18, context),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "area-label".i18n(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: sizeHeight(14, context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(sizeWidth(10,
                                  context)), // Adjust the radius value as needed
                            ),
                            elevation: 8,
                            color: Colors.amber,
                            child: Container(
                              height: sizeHeight(114, context),
                              width: sizeWidth(160, context),
                              padding: EdgeInsets.all(sizeWidth(15, context)),
                              child: Column(
                                children: [
                                  Text(
                                    widget.fields.metresAboveSeaLv.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(25, context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight(10, context),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "sea-level".i18n(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: sizeHeight(14, context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: sizeHeight(10, context),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(sizeWidth(10,
                                  context)), // Adjust the radius value as needed
                            ),
                            elevation: 8,
                            child: Container(
                              height: sizeHeight(114, context),
                              width: sizeWidth(160, context),
                              padding: EdgeInsets.all(sizeWidth(15, context)),
                              child: Column(
                                children: [
                                  Text(
                                    (widget.fields.latitude.toInt() ==
                                            widget.fields.latitude
                                        ? widget.fields.latitude
                                            .toInt()
                                            .toString()
                                        : widget.fields.latitude
                                            .toStringAsFixed(4)),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(25, context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight(18, context),
                                  ),
                                  Text(
                                    "latitude".i18n(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: sizeHeight(14, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(sizeWidth(10,
                                  context)), // Adjust the radius value as needed
                            ),
                            elevation: 8,
                            color: Colors.blue,
                            child: Container(
                              height: sizeHeight(114, context),
                              width: sizeWidth(160, context),
                              padding: EdgeInsets.all(sizeWidth(15, context)),
                              child: Column(
                                children: [
                                  Text(
                                    (widget.fields.longtitude.toInt() ==
                                            widget.fields.longtitude
                                        ? widget.fields.longtitude
                                            .toInt()
                                            .toString()
                                        : widget.fields.longtitude
                                            .toStringAsFixed(4)),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(25, context),
                                    ),
                                  ),
                                  SizedBox(
                                    height: sizeHeight(18, context),
                                  ),
                                  Text(
                                    "longtitude".i18n(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontSize: sizeHeight(14, context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: sizeHeight(5, context),
                      // ),
                      // _buildUpdateGPSBtn(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildReadOnlyOwner(String label, User owner, IconData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            sizeWidth(10, context)), // Adjust the radius value as needed
      ),
      elevation: 8,
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        style: TextStyle(
                          fontSize: sizeHeight(14, context),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        )),
                    Text(
                        owner.title.toString() +
                            " " +
                            owner.firstName.toString() +
                            " " +
                            owner.lastName.toString(),
                        style: TextStyle(
                          fontSize: sizeHeight(14, context),
                          fontWeight: FontWeight.w600,
                          // color: Colors.grey
                        )),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget buildReadOnlyAddress(String label, String location, IconData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            sizeWidth(10, context)), // Adjust the radius value as needed
      ),
      elevation: 8,
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(label,
                        style: TextStyle(
                          fontSize: sizeHeight(14, context),
                          fontWeight: FontWeight.normal,
                          // color: Colors.grey
                        )),
                    Text(
                        widget.fields.address.toString() +
                            " หมู่ที่ " +
                            widget.fields.moo.toString() +
                            " ถ. " +
                            widget.fields.road.toString() +
                            "  ",
                        style: TextStyle(
                          fontSize: sizeHeight(14, context),
                          fontWeight: FontWeight.w600,
                          // color: Colors.grey
                        )),
                    Row(
                      children: [
                        Text("ต. " + location.split(",")[1],
                            style: TextStyle(
                              fontSize: sizeHeight(14, context),
                              fontWeight: FontWeight.w600,
                              // color: Colors.grey
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Text("อ. " + location.split(",").first,
                            style: TextStyle(
                              fontSize: sizeHeight(14, context),
                              fontWeight: FontWeight.w600,
                              // color: Colors.grey
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Text("" + location.split(",").last,
                            style: TextStyle(
                              fontSize: sizeHeight(14, context),
                              fontWeight: FontWeight.w600,
                              // color: Colors.grey
                            )),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  Widget buildReadOnlyField(String label, String value, IconData) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: sizeWidth(4, context),
                horizontal: sizeHeight(4, context)),
            child: Row(
              children: [
                CircleAvatar(
                    backgroundColor:
                        HotelAppTheme.buildLightTheme().primaryColor,
                    child: Icon(
                      IconData,
                      color: Colors.white,
                    )),
                Container(
                  margin: EdgeInsets.only(left: sizeWidth(10, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label,
                          style: TextStyle(
                            fontSize: sizeHeight(14, context),
                            fontWeight: FontWeight.normal,
                            // color: Colors.grey
                          )),
                      Text(value,
                          style: TextStyle(
                            fontSize: sizeHeight(14, context),
                            fontWeight: FontWeight.w600,
                            // color: Colors.grey
                          )),
                    ],
                  ),
                )
              ],
            )));
  }

  Widget _buildDetailField() {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.withOpacity(0.1),
              theme_color3.withOpacity(.4),
              theme_color4.withOpacity(0.6),
            ],
          ),
        ),
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight! * 0.92,
        child: _buildListView());
  }

  Widget _buildUpdateGPSBtn() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          color: theme_color, // Replace with your desired border color
          width: 4, // Adjust the border width as needed
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: sizeWidth(0, context)),
      width: sizeWidth(300, context),
      child: RaisedButton(
        elevation: 10,
        onPressed: () async {
          await submitUpdateGPS();
        },
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.play_circle_fill_rounded,
                color: Color(0xFF527DAA),
                size: sizeHeight(32, context),
              ),
            ),
            Padding(padding: EdgeInsets.only(right: sizeWidth(8, context))),
            Text(
              "update-fiel-GPS-label".i18n(),
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 1,
                fontSize: sizeHeight(15, context),
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("height : ${MediaQuery.of(context).size.height} ");
    // print("width : ${MediaQuery.of(context).size.width}");
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.screenHeight! * 0.05),
            child: getAppBarUI(),
          ),
          body: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: <Widget>[
                    _buildDetailField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: sizeWidth(8, context)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: sizeWidth(8, context),
            right: sizeWidth(8, context)),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + sizeHeight(40, context),
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeHeight(32, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeHeight(8, context)),
                    child: Icon(
                      Icons.arrow_back,
                      size: sizeHeight(25, context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'field-more-detail-label'.i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + sizeHeight(40, context),
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(sizeWidth(32, context)),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: sizeHeight(
                                    150, context), // Set your desired height
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(
                                        Icons.edit,
                                        color: HotelAppTheme.buildLightTheme()
                                            .shadowColor,
                                        size: sizeHeight(25, context),
                                      ),
                                      title: Text(
                                        "update-field-label".i18n(),
                                        style: TextStyle(
                                          fontSize: sizeHeight(17, context),
                                          fontWeight:
                                              kPoppinsRegular.fontWeight,
                                          color: HotelAppTheme.buildLightTheme()
                                              .shadowColor,
                                        ),
                                      ),
                                      onTap: () {
                                        // EDIT FIELD IN THE FUTURE
                                        String valueField =
                                            jsonEncode(widget.fields);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NewFieldScreen(
                                                      widget.fields.fieldID,
                                                      widget.fields,
                                                      widget.owner,
                                                      widget.fieldData,
                                                      widget.fieldProviders)),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(
                                        Icons.people,
                                        color: HotelAppTheme.buildLightTheme()
                                            .shadowColor,
                                        size: sizeHeight(25, context),
                                      ),
                                      title: Text(
                                        "update-userSurvey-field-label".i18n(),
                                        style: TextStyle(
                                          fontSize: sizeHeight(17, context),
                                          fontWeight:
                                              kPoppinsRegular.fontWeight,
                                          color: HotelAppTheme.buildLightTheme()
                                              .shadowColor,
                                        ),
                                      ),
                                      onTap: () {
                                        // CLICK FOR CHANGE PAGE
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UpdateSurveyorScreen(
                                              widget.fields.fieldID,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: editable
                            ? Padding(
                                padding: EdgeInsets.all(sizeWidth(8, context)),
                                child: Icon(
                                  Icons.edit,
                                  size: sizeHeight(25, context),
                                ),
                              )
                            : Container()),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ChangeDateTime(int input) {
    String date = DateFormat("dd-MM-yyyy")
        .format(new DateTime.fromMillisecondsSinceEpoch(input));
    return date.toString();
  }
}
