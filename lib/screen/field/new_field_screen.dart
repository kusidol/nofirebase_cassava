import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/district_service.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/province_service.dart';
import 'package:mun_bot/controller/subdistrict_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/subdistrict.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/model/input_validator.dart';
import 'package:mun_bot/providers/farmer_dropdown_provider.dart';
import 'package:mun_bot/providers/field_provider.dart';
import 'package:mun_bot/screen/field/dropdown_farmer_screen.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/widget/loading.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/input.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import '../main_screen.dart';

class NewFieldScreen extends StatefulWidget {
  final int userId;
  final Field? fieldFromPassPage;
  final User? user;
  final String? location;
  FieldProviders fieldProviders;

  NewFieldScreen(this.userId, this.fieldFromPassPage, this.user, this.location,
      this.fieldProviders);

  @override
  State<NewFieldScreen> createState() => _NewFieldScreenState();
}

class _NewFieldScreenState extends State<NewFieldScreen>
    with WidgetsBindingObserver {
  //Setting for Page
  String? token = tokenFromLogin?.token;
  bool _isLoading = true;
  bool _isPassValueFromPage = false;
  StepperType stepperType = StepperType.horizontal;
  int _currentStep = 0;
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final _formKeyPage3 = GlobalKey<FormState>();
  String? selectedValue;
  AutovalidateMode autovidateDisable = AutovalidateMode.disabled;
  late Field field;
  FieldService fieldService = FieldService();

  // Checking for Province, District & Subdistrict
  bool selectedProvince = false;
  bool selectedDistrict = false;

  // Dropdown for Province, District and Subdistrict
  List<String> provinces = [];
  int? selectedProvinceId;
  List<String> districts = [];
  int? selectedDistrictId;
  List<String> subdistricts = [];
  int? selectedSubistrictId;

  // TEMP FOR GET DATA FROM SERVICE
  List<Map<String, dynamic>> data_provinces = [];
  List<Map<String, dynamic>> data_districts = [];
  List<Map<String, dynamic>> data_subdistricts = [];

  // TEXT FOR DROPDOWN : Province, District and Subdistrict
  String selectedProvince_value = "";
  String selectedDistrict_value = "";
  String selectedSubdistrict_value = "";

  //Keep data for userInFieldID
  int? userInFieldID;

  // FOR GPS
  Position? _currentPosition;
  final Location location = Location();

  // Saving Value
  String tempField = "";
  // PAGE 1
  String save_Code = "";
  String save_Name = "";
  String save_Address = "";
  String save_Moo = "";
  String save_Road = "";
  // PAGE 2
  String save_Size = "";
  String save_Landmark = "";
  // PAGE 3
  String save_Latitude = "";
  String save_Longtitude = "";
  String save_MetresAboveSeaLv = "";

  // Loading GPS
  bool canUpdateGPS = false;
  bool loadingGPS = false;

  TextEditingController latitudeController = TextEditingController();
  TextEditingController longtitudeController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    onLoadFirstFunction();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final location_granted = await Permission.location.isGranted;
      if (location_granted) {
        // //print("Resume with Location");
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Location permissions are denied')));
        showAlertDialog_Location(context);

        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text(
      //         'Location permissions are permanently denied, we cannot request permissions.')));
      var statusLocation = await Permission.location.status;
      //print("status : ${statusLocation}");
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
                  Navigator.of(context).pop(false);
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
      canUpdateGPS = true;
      _currentPosition = position;
    });
  }

  List<String> createDropdown(List<Map<String, dynamic>> list) {
    List<String> result = [];
    for (int i = 0; i < list.length; i++) {
      String value = jsonEncode(list[i]['name']);
      value = value.replaceAll('"', '');
      result.add(value);
    }
    return result;
  }

  createDistrictDropdown() async {
    DistrictService districtService = new DistrictService();

    data_districts = await districtService.getAllDistrictsByProvinceId(
        token.toString(), selectedProvinceId!);
    districts = createDropdown(data_districts);
    setState(() {
      districts = districts;
    });
  }

  createSubistrictDropdown() async {
    SubdistrictService subdistrictService = new SubdistrictService();

    data_subdistricts = await subdistrictService.getAllSubdistrictsByDistrictId(
        token.toString(), selectedDistrictId!);
    subdistricts = createDropdown(data_subdistricts);
    setState(() {
      subdistricts = subdistricts;
    });
  }

  onLoadFirstFunction() async {
    // FOR GET LOCATION GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('gps-off-alert'.i18n())));
    }

    if (widget.fieldFromPassPage == null) {
      // Create field
      _isPassValueFromPage = false;
      field = Field(0, 0, "", "", "", "", "", "", 0, "", 0, 0, 0, 0, "", 0, 0,
          0, 0, true);
      ProviceService provinceService = new ProviceService();
      data_provinces = await provinceService.getAllProvince(token.toString());

      provinces = createDropdown(data_provinces);
    } else {
      // Update Field
      // TEMP FOR SAVE VALUE
      tempField = jsonEncode(widget.fieldFromPassPage!);

      _isPassValueFromPage = true;

      field = widget.fieldFromPassPage!;
      // //print("widget.location : ${widget.location!}");
      selectedProvince_value = widget.location!.split(",").last;
      selectedDistrict_value = widget.location!.split(",").first;
      selectedSubdistrict_value = widget.location!.split(",")[1];

      // Province
      ProviceService provinceService = new ProviceService();

      data_provinces = await provinceService.getAllProvince(token.toString());
      if (data_provinces.length == 0) {
        // onBackButtonPressed(context);
        // Data Provice load not success => Show alert for exit
        showAboutDialog(context);
      } else {
        provinces = createDropdown(data_provinces);
        selectedProvinceId = getId(selectedProvince_value, data_provinces, 1);
        await createDistrictDropdown();

        // District
        selectedDistrictId = getId(selectedDistrict_value, data_districts, 2);
        await createSubistrictDropdown();

        // Subdistrict
        selectedSubistrictId =
            getId(selectedSubdistrict_value, data_subdistricts, 3);

        setState(() {
          selectedProvince = true;
          selectedDistrict = true;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Function get ID from province, district and subdistrict
  /*
  MODE :
  1 = getID of Province,
  2 = getID of District,
  3 = getID of Subdistrict
  */
  int getId(String value, List<Map<String, dynamic>> list, int mode) {
    int result = 0;
    String label = "";
    if (mode == 1) {
      label = "provinceId";
    } else if (mode == 2) {
      label = "districtId";
    } else if (mode == 3) {
      label = "subdistrictId";
    } else {
      return result;
    }

    for (int i = 0; i < list.length; i++) {
      String text = jsonEncode(list[i]['name']);
      int id = int.parse(jsonEncode(list[i][label]));
      text = text.replaceAll('"', '');
      if (text == value) {
        result = id;
        break;
      }
    }
    return result;
  }

  // Function for Stepper in Page
  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 2) {
      Navigator.of(context).pop();
    } else if (_currentStep == 0) {
      if (_formKeyPage1.currentState!.validate()) {
        save_Code = field.code;
        save_Name = field.name;
        save_Address = field.address;
        save_Moo = field.moo;
        save_Road = field.road;
        setState(() => _currentStep += 1);
      } else {
        //print("in valid");
      }
    } else if (_currentStep == 1) {
      if (_formKeyPage2.currentState!.validate()) {
        save_Size = field.size.toString();
        save_Landmark = field.landmark;
        setState(() => _currentStep += 1);
      } else {
        //print("in valid");
      }
    } else if (_currentStep == 2) {
      if (_formKeyPage3.currentState!.validate()) {
        save_Latitude = field.latitude.toString();
        save_Longtitude = field.longtitude.toString();
        save_MetresAboveSeaLv = field.metresAboveSeaLv.toString();
        setState(() => _currentStep += 1);
      } else {
        //print("in valid");
      }
    } else {
      setState(() => _currentStep += 1);
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      resetValueEditNotFinish();
      Navigator.of(context).pop();
    }
  }

  bool isFinal() {
    if (_currentStep == 2) return true;

    return false;
  }

  // Reset Value for not Submit Edit Field
  resetValueEditNotFinish() {
    if (_isPassValueFromPage) {
      Map<String, dynamic> copy = jsonDecode(tempField);
      Field temp = Field.fromJson(copy);

      field.code = temp.code;
      field.name = temp.name;
      field.address = temp.address;
      field.road = temp.road;
      field.moo = temp.moo;
      field.landmark = temp.landmark;
      field.latitude = temp.latitude;
      field.longtitude = temp.longtitude;
      field.metresAboveSeaLv = temp.metresAboveSeaLv;
      field.size = temp.size;
    }
  }

  // Function for submit to create and update Field
  submitFunction() async {
    if (_isPassValueFromPage) {
      // for update
      var updateData = {
        "fieldId": field.fieldID,
        "code": field.code,
        "name": field.name,
        "address": field.address,
        "road": field.road,
        "moo": field.moo,
        "landmark": field.landmark,
        "latitude": field.latitude,
        "longitude": field.longtitude,
        "subdistrict": selectedSubistrictId,
        "metresAboveSeaLv": field.metresAboveSeaLv,
        "size": field.size,
        "status": field.status,
        "userinfields": widget.user!.userID,
      };
      //print("UPDATE VALUE : ${updateData.toString()}");
      int statusUpdateField =
          await fieldService.updateField(token.toString(), updateData);
      //print("NUMBER STATUS : ${statusUpdateField}");
      if (statusUpdateField == 200) {
        Navigator.pop(context);
        CustomLoading.showSuccess();
      } else {
        CustomLoading.showError(
            context, 'Something went wrong. Please try again later.');
      }
    } else {
      // for create
      var createData = {
        "code": field.code,
        "name": field.name,
        "address": field.address,
        "road": field.road,
        "moo": field.moo,
        "landmark": field.landmark,
        "latitude": field.latitude,
        "longitude": field.longtitude,
        "subdistrict": selectedSubistrictId,
        "metresAboveSeaLv": field.metresAboveSeaLv,
        "size": field.size,
        "userinfields": userInFieldID,
        "createDate": DateTime.now().millisecondsSinceEpoch,
      };
      //print(createData);
      FieldService fieldService = new FieldService();
      String? token = tokenFromLogin?.token;
      Field? newField =
          await fieldService.createField(token.toString(), createData);
      CustomLoading.dismissLoading();
      if (newField != null) {
        CustomLoading.showSuccess();
        //print("addField newField ${newField.fieldID}");

        widget.fieldProviders.addField(newField);
        widget.fieldProviders.notifyListeners();
        Navigator.of(context).pop();
      } else {
        CustomLoading.showError(
            context, 'Something went wrong. Please try again later.');
      }
    }
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
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    resetValueEditNotFinish();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(8, context)),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  _isPassValueFromPage
                      ? "update-field-label".i18n()
                      : "create-field-label".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeHeight(8, context)),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeHeight(8, context)),
                        // child: Icon(FontAwesomeIcons.per,color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCreateFieldFirstPage(DropdownFarmer dropdownFarmer) {
    List<String> dropdownForShow = dropdownFarmer.farmerString;
    dropdownForShow.add('add-new-agriculture'.i18n());

    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("first-page".i18n(),
                style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold)),
          ),
          Form(
              key: _formKeyPage1,
              autovalidateMode: autovidateDisable,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "CODE" + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        field.code = text;
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.code = save_Code}
                    },
                    labelText: field.code == ""
                        ? "insert-field-code".i18n()
                        : field.code,
                    successText: "",
                    inputIcon: Icon(Icons.code_sharp),
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, field.code.toString()),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "name-field-label".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        field.name = text;
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.name = save_Name}
                    },
                    labelText: field.name == ""
                        ? "insert-field-name".i18n()
                        : field.name,
                    successText: "",
                    inputIcon: Icon(Icons.eco_sharp),
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, field.name.toString()),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'owner'.i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  !_isPassValueFromPage
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme_color,
                              width: sizeWidth(2, context),
                            ),
                          ),
                          child: DropdownButtonFormField<String>(
                            validator: (value) =>
                                InputCodeValidator.validateDropdownProvider(
                                    value),
                            value: selectedValue,
                            onChanged: (value) {
                              if (value == 'add-new-agriculture'.i18n()) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => Provider(
                                      create: (context) => dropdownFarmer,
                                      builder: (context, child) =>
                                          DropdownForFarmer(
                                        (value) {
                                          //print(value);
                                          bool duplicate = false;
                                          List<String> temp =
                                              dropdownFarmer.farmerString;
                                          for (int i = 0;
                                              i < temp.length;
                                              i++) {
                                            if (value['nameFarmer'] ==
                                                temp[i]) {
                                              duplicate = true;
                                              break;
                                            }
                                          }
                                          if (!duplicate) {
                                            dropdownFarmer
                                                .addItem(value['nameFarmer']);
                                          }
                                          setState(() {
                                            userInFieldID = value['id'];
                                            //print("SELECT userInFieldID : ${userInFieldID}");
                                            selectedValue = value['nameFarmer'];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                //print(value);
                                int id = 0;
                                for (int i = 0;
                                    i < dropdownFarmer.items.length;
                                    i++) {
                                  if (dropdownFarmer.items[i].name == value) {
                                    id = dropdownFarmer.items[i].id;
                                    break;
                                  }
                                }
                                setState(() {
                                  userInFieldID = id;
                                  //print("SELECT userInFieldID : ${userInFieldID}");
                                  selectedValue = value.toString();
                                });
                              }
                            },
                            hint: Center(
                                child: Text(
                              "please-select-owner".i18n(),
                              style: TextStyle(color: Colors.black),
                            )),
                            // Hide the default underline
                            // underline: Container(),
                            // set the color of the dropdown menu
                            dropdownColor: Colors.white,
                            icon: Padding(
                              padding: EdgeInsets.all(sizeHeight(8, context)),
                              child: const Icon(Icons.arrow_downward,
                                  color: Colors.black),
                            ),
                            isExpanded: true,

                            // The list of options
                            items: dropdownForShow
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              'owner-name'.i18n() + " ",
                                              style: TextStyle(
                                                fontSize:
                                                    sizeHeight(18, context),
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                e,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                                softWrap: false,
                                                style: TextStyle(
                                                    fontSize:
                                                        sizeHeight(18, context),
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),

                            // Customize the selected item
                            selectedItemBuilder: (BuildContext context) =>
                                dropdownForShow
                                    .map((e) => Center(
                                          child: Text(
                                            'owner'.i18n() + " : ${e}",
                                            style: TextStyle(
                                                fontSize:
                                                    sizeHeight(18, context),
                                                color: Colors.black,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ))
                                    .toList(),
                          ),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Text(
                            widget.user!.title.toString() +
                                " " +
                                widget.user!.firstName.toString() +
                                " " +
                                widget.user!.lastName.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: sizeHeight(20, context)),
                          ),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "address".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        field.address = text;
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.address = save_Address}
                    },
                    labelText: field.address == ""
                        ? "insert-field-address-label".i18n()
                        : field.address,
                    successText: "",
                    inputIcon: Icon(Icons.house_rounded),
                    validator1: (value) =>
                        InputCodeValidator.validateNotSpecialCharacter(
                            value, field.address.toString()),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "moo".i18n(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        field.moo = text;
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.moo = save_Moo}
                    },
                    labelText:
                        field.moo == "" ? "insert-field-moo".i18n() : field.moo,
                    successText: "",
                    inputIcon: Icon(Icons.house_siding_rounded),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "road".i18n(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        field.road = text;
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.road = save_Road}
                    },
                    labelText: field.road == ""
                        ? "insert-field-road".i18n()
                        : field.road,
                    successText: "",
                    inputIcon: Icon(Icons.add_road_rounded),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildCreateFieldSecondPage() {
    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("second-page".i18n(),
                style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold)),
          ),
          Form(
              key: _formKeyPage2,
              autovalidateMode: autovidateDisable,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "province".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  DropdownSearch<String>(
                    mode: Mode.DIALOG,
                    showSelectedItems: true,
                    items: provinces,
                    dropdownSearchDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(sizeWidth(20, context)),
                        borderSide: const BorderSide(
                          color: theme_color,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(sizeWidth(20, context)),
                        borderSide: BorderSide(
                          color: theme_color,
                          width: sizeWidth(2, context),
                        ),
                      ),
                      hintText: "พืชที่ปลูกก่อนหน้า",
                    ),
                    onChanged: (value) async {
                      setState(() {
                        if (value.toString() != selectedProvince_value) {
                          selectedDistrict = false;
                          selectedDistrict_value = "";
                          selectedSubdistrict_value = "";
                        }
                        selectedProvince_value = value.toString();
                        selectedProvinceId =
                            getId(selectedProvince_value, data_provinces, 1);
                        selectedProvince = true;
                      });
                      await createDistrictDropdown();
                    },
                    selectedItem: selectedProvince_value == ""
                        ? "select-province-info".i18n()
                        : selectedProvince_value,
                    showSearchBox: true,
                    searchFieldProps: TextFieldProps(
                      cursorColor: Colors.blue,
                      autofillHints: [AutofillHints.name],
                      decoration: InputDecoration(
                        hintText: 'search'.i18n(),
                      ),
                    ),
                    validator: (value) => InputCodeValidator.validateDropDown(
                        value, "select-province-info".i18n()),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "district".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  selectedProvince
                      ? DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSelectedItems: true,
                          items: districts,
                          dropdownSearchDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: const BorderSide(
                                color: theme_color,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: BorderSide(
                                color: theme_color,
                                width: sizeWidth(2, context),
                              ),
                            ),
                            hintText: "พืชที่ปลูกก่อนหน้า",
                          ),
                          onChanged: (value) async {
                            setState(() {
                              if (value.toString() != selectedDistrict_value) {
                                selectedSubdistrict_value = "";
                              }
                              selectedDistrict_value = value.toString();
                              selectedDistrictId = getId(
                                  selectedDistrict_value, data_districts, 2);
                              selectedDistrict = true;
                            });
                            await createSubistrictDropdown();
                          },
                          selectedItem: selectedDistrict_value == ""
                              ? "select-district-info".i18n()
                              : selectedDistrict_value,
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            cursorColor: Colors.blue,
                            autofillHints: [AutofillHints.name],
                            decoration: InputDecoration(
                              hintText: 'search'.i18n(),
                            ),
                          ),
                          validator: (value) =>
                              InputCodeValidator.validateDropDown(
                                  value, "select-district-info".i18n()),
                        )
                      : Container(
                          child: Center(
                            child: Text("must-select-province-first".i18n()),
                          ),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "sub-district".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  selectedDistrict
                      ? DropdownSearch<String>(
                          mode: Mode.DIALOG,
                          showSelectedItems: true,
                          items: subdistricts,
                          dropdownSearchDecoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: const BorderSide(
                                color: theme_color,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(sizeWidth(20, context)),
                              borderSide: BorderSide(
                                color: theme_color,
                                width: sizeWidth(2, context),
                              ),
                            ),
                            hintText: "พืชที่ปลูกก่อนหน้า",
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedSubdistrict_value = value.toString();
                              selectedSubistrictId = getId(
                                  selectedSubdistrict_value,
                                  data_subdistricts,
                                  3);
                            });
                          },
                          selectedItem: selectedSubdistrict_value == ""
                              ? "select-sub-district-info".i18n()
                              : selectedSubdistrict_value,
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            cursorColor: Colors.blue,
                            autofillHints: [AutofillHints.name],
                            decoration: InputDecoration(
                              hintText: 'search'.i18n(),
                            ),
                          ),
                          validator: (value) =>
                              InputCodeValidator.validateDropDown(
                                  value, "select-sub-district-info".i18n()),
                        )
                      : Container(
                          child: Center(
                            child: Text("must-select-district-first".i18n()),
                          ),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "area-size-rai".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        RegExp regex =
                            new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                        if (regex.hasMatch(text.toString())) {
                          try {
                            field.size = double.parse(text);
                          } catch (e) {
                            //print("NUMBER FUCKING ERROR :${e}");
                          }
                        }
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.size = double.parse(save_Size)}
                    },
                    validator1: (value) => InputCodeValidator.validateFieldSize(
                        value, field.size.toString()),
                    labelText:
                        field.size == 0.00 ? "0.00" : field.size.toString(),
                    successText: "",
                    isOnlyNumber: true,
                    inputIcon: Icon(Icons.eco_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "landmark-plots".i18n(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        field.landmark = text;
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {field.landmark = save_Landmark}
                    },
                    labelText: field.landmark == ""
                        ? "insert-landmark-plots".i18n()
                        : field.landmark,
                    successText: "",
                    inputIcon: Icon(Icons.filter_center_focus_rounded),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _buildCreateFieldThirdPage() {
    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("third-page".i18n(),
                style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold)),
          ),
          Form(
              key: _formKeyPage3,
              autovalidateMode: autovidateDisable,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "latitude".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  _isPassValueFromPage
                      ? TextFormField(
                          controller: latitudeController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelText: "LATITUDE : ${field.latitude}",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme_color2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme_color2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              RegExp regex =
                                  new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                              if (regex.hasMatch(value.toString())) {
                                try {
                                  field.latitude = double.parse(value);
                                } catch (e) {
                                  //print("NUMBER FUCKING ERROR :${e}");
                                }
                              }
                            });
                          },
                        )
                      : AnimTFF(
                          (text) => {
                            setState(() {
                              RegExp regex =
                                  new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                              if (regex.hasMatch(text.toString())) {
                                try {
                                  field.latitude = double.parse(text);
                                } catch (e) {
                                  //print("NUMBER FUCKING ERROR :${e}");
                                }
                              }
                            }),
                            if (text.isEmpty || (text == null) || (text == ""))
                              {field.latitude = double.parse(save_Latitude)}
                          },
                          validator1: (value) =>
                              InputCodeValidator.validateNumber(
                                  value, field.latitude.toString()),
                          labelText: field.latitude == 0.00
                              ? "0.00"
                              : field.latitude.toString(),
                          successText: "",
                          isOnlyNumber: true,
                          inputIcon: Icon(Icons.map_rounded),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "longtitude".i18n() + "*",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  _isPassValueFromPage
                      ? TextFormField(
                          controller: longtitudeController,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            labelText: "LONGTITUDE : ${field.longtitude}",
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme_color2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: theme_color2),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              RegExp regex =
                                  new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                              if (regex.hasMatch(value.toString())) {
                                try {
                                  field.longtitude = double.parse(value);
                                } catch (e) {
                                  //print("NUMBER FUCKING ERROR :${e}");
                                }
                              }
                            });
                          },
                        )
                      : AnimTFF(
                          (text) => {
                            setState(() {
                              RegExp regex =
                                  new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                              if (regex.hasMatch(text.toString())) {
                                try {
                                  field.longtitude = double.parse(text);
                                } catch (e) {
                                  //print("NUMBER FUCKING ERROR :${e}");
                                }
                              }
                            }),
                            if (text.isEmpty || (text == null) || (text == ""))
                              {field.longtitude = double.parse(save_Longtitude)}
                          },
                          validator1: (value) =>
                              InputCodeValidator.validateNumber(
                                  value, field.longtitude.toString()),
                          labelText: field.longtitude == 0.00
                              ? "0.00"
                              : field.longtitude.toString(),
                          successText: "",
                          isOnlyNumber: true,
                          inputIcon: Icon(Icons.map_rounded),
                        ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  _isPassValueFromPage ? _buildUpdateGPSBtn() : Container(),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "sea-level".i18n(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        RegExp regex =
                            new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                        if (regex.hasMatch(text.toString())) {
                          try {
                            field.metresAboveSeaLv = double.parse(text);
                          } catch (e) {
                            //print("NUMBER FUCKING ERROR :${e}");
                          }
                        }
                      }),
                      if (text.isEmpty || (text == null) || (text == ""))
                        {
                          field.metresAboveSeaLv =
                              double.parse(save_MetresAboveSeaLv)
                        }
                    },
                    labelText: field.metresAboveSeaLv == 0.00
                        ? "0.00"
                        : field.metresAboveSeaLv.toString(),
                    successText: "",
                    isOnlyNumber: true,
                    inputIcon: Icon(Icons.water),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                ],
              ))
        ],
      ),
    );
  }

  Future<void> submitUpdateGPS() async {
    await _getCurrentLocation();

    //print("Subdistrict : ${selectedSubistrictId}");
    if (canUpdateGPS) {
      setState(() {
        field.longtitude =
            double.parse(_currentPosition!.longitude.toStringAsFixed(7));
        field.latitude =
            double.parse(_currentPosition!.latitude.toStringAsFixed(7));

        longtitudeController.text = field.longtitude.toString();
        latitudeController.text = field.latitude.toString();
      });
    }
  }

  Future<bool> checkingOpenGPS() async {
    bool serviceEnable = await location.serviceEnabled();
    if (!serviceEnable) {
      serviceEnable = await location.requestService();
      if (!serviceEnable) {
        return false;
      } else {
        return true;
      }
    }
    return true; // openGPS
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
          bool openGPS = await checkingOpenGPS();
          if (openGPS) {
            await submitUpdateGPS();
          }
          // setState(() {
          //   loadingGPS = false;
          // });
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

  showAboutDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('internet-problem-label'.i18n()),
          content: Text('connection-timeout-label'.i18n()),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK')),
          ],
        ),
      );
  Future<bool> onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('internet-problem-label'.i18n()),
            content: Text('connection-timeout-label'.i18n()),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        });

    return exitApp;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DropdownFarmer>(create: (BuildContext context) {
          return DropdownFarmer();
        }),
      ],
      child:
          Consumer<DropdownFarmer>(builder: (context, dropdownFarmer, child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(sizeHeight(67, context)),
            child: getAppBarUI(),
          ),
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme_color2),
                  ),
                )
              : data_provinces.length == 0
                  ? Container()
                  : Container(
                      padding: EdgeInsets.all(sizeHeight(12, context)),
                      child: Container(
                        height: SizeConfig.screenHeight,
                        child: Theme(
                          data: ThemeData(
                            canvasColor: Color.fromARGB(255, 255, 255, 255),
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary: theme_color4,
                                  background: Colors.red,
                                  secondary: Colors.green,
                                ),
                          ),
                          child: Stepper(
                            physics: ScrollPhysics(),
                            type: stepperType,
                            currentStep: _currentStep,
                            onStepTapped: (step) => tapped(step),
                            onStepContinue: continued,
                            onStepCancel: cancel,
                            controlsBuilder: (context,
                                {onStepCancel, onStepContinue}) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      child: Text('previous-label'.i18n()),
                                      onPressed: cancel,
                                    ),
                                  ),
                                  SizedBox(
                                    width: sizeWidth(12, context),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      child: isFinal()
                                          ? _isPassValueFromPage
                                              ? Text(
                                                  'confirm-edit-label'.i18n())
                                              : Text('create-new-field-label'
                                                  .i18n())
                                          : Text('next-label'.i18n()),
                                      onPressed: isFinal()
                                          ? submitFunction
                                          : continued,
                                    ),
                                  ),
                                ],
                              );
                            },
                            steps: [
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 0;
                                    });
                                  },
                                ),
                                content: Column(
                                  children: <Widget>[
                                    _buildCreateFieldFirstPage(dropdownFarmer),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025),
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 0
                                    ? StepState.complete
                                    : StepState.disabled,
                              ),
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 1;
                                    });
                                  },
                                ),
                                content: Column(
                                  children: <Widget>[
                                    _buildCreateFieldSecondPage(),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025),
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 1
                                    ? StepState.complete
                                    : StepState.disabled,
                              ),
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 2;
                                    });
                                  },
                                ),
                                content: Column(
                                  children: <Widget>[
                                    _buildCreateFieldThirdPage(),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025),
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 2
                                    ? StepState.complete
                                    : StepState.disabled,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      }),
    );
  }
}
