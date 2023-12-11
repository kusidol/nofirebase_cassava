import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/user.dart';

import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/field_dropdown_provider.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/providers/variety_provider.dart';
import 'package:mun_bot/screen/cultivation/new_cultivation_screen.dart';
import 'package:mun_bot/screen/cultivation/planting_more_detail.dart';
import 'package:mun_bot/screen/login/app_styles.dart';
import 'package:mun_bot/screen/widget/card_list_view.dart';
import 'package:mun_bot/screen/widget/no_data.dart';

import 'package:mun_bot/util/ui/calendar_popup_view.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import '../../util/size_config.dart';
import 'package:mun_bot/util/change_date_time.dart';
//import 'package:mun_bot/screen/size_config.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';

import 'package:mun_bot/screen/survey/create_survey_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class BaseCultivationScreen extends StatefulWidget {
  TabController mainTapController;
  BaseCultivationScreen(this.mainTapController);
  @override
  State<StatefulWidget> createState() => _BaseCultivationScreen();
}

class _BaseCultivationScreen extends State<BaseCultivationScreen>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _inerscrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  bool _istLoading = true;
  bool _isLoadMore = false;

  int check = 0;
  bool _isVisibleCreateing = true;

  //--------------------serach more
  // final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  bool isSearching = false;
  TextEditingController codeNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cultivationController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String addressValue = '';
  String fieldNameValue = '';
  String ownerNameValue = '';
  String plantingNameValue = '';
  int startDateSelect = 0;
  int endDateSelect = 0;

  bool isShowbasicSearch = true;
  GlobalKey expansionTileKey = GlobalKey();
  //--------------------serach more

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    onfirstLoadData();
  }

  String selectedPlantingName = "ชื่อการเพาะปลูก";
  String selectedfieldName = "ชื่อแปลง";
  String selectedAddress = "ที่อยู่การเพาะปลูก";
  String selectedOwnerName = "เจ้าของการเพาะปลูก";
  String selectedplantingItems = "ชื่อการเพาะปลูก";
  String selectedplantingCode = "รหัสการเพาะปลูก";
  String selectedplantingDate = "ปีที่เพาะปลูก";
  String selectedsurveyDate = "วันที่สำรวจ";
  String selectedFieldName = "ชื่อแปลง";
  @override
  void dispose() {
    animationController?.dispose();
    ownerController.dispose();
    super.dispose();
  }

  void onfirstLoadData() async {
    if (mounted) {
      setState(() {
        _istLoading = true;
      });
    }

    PlantingProvider provider =
        Provider.of<PlantingProvider>(context, listen: false);

    provider.reset();
    SurveyProvider surveyProvider =
        Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.resetPlantingID();
    if (provider.fieldID != 0) {
      provider.fetchDataFromField();
    } else {
      provider.fetchData();
    }

    if (mounted) {
      setState(() {
        _istLoading = false;
      });
    }
  }

  void fetchMoreData(BuildContext context) async {
    if (mounted) {
      setState(() {
        _isLoadMore = true;
      });
    }

    PlantingProvider provider =
        Provider.of<PlantingProvider>(context, listen: false);

    if (!isSearching) {
      if (provider.fieldID != 0) {
        provider.fetchDataFromField();
      } else {
        provider.fetchData();
      }
    }
    if (mounted) {
      setState(() {
        _isLoadMore = false;
      });
    }
  }

  void showToastMessage(String msg) {
    FlutterToastr.show(msg, context,
        duration: 2,
        position: FlutterToastr.bottom,
        backgroundColor: theme_color,
        textStyle: TextStyle(fontSize: 15, color: Colors.black));
  }

  Future<void> _pullRefresh() async {}

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
    } else {}
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
                    padding: EdgeInsets.all(sizeWidth(8, context)),
                    // child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: sizeHeight(20, context),
                    ),
                    SizedBox(
                      width: sizeWidth(15, context),
                    ),
                    Text(
                      'planting-label'.i18n(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.029,
                      ),
                    ),
                  ],
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

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getTimeDateUI() {
    var fontsize16 = MediaQuery.of(context).size.height * 0.0204;
    return Padding(
      padding: EdgeInsets.only(
          left: sizeWidth(18, context), bottom: sizeHeight(6, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(sizeHeight(4, context)),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                // setState(() {
                //   isDatePopupOpen = true;
                // });
                showDemoDialog(context: context);
              },
              child: Row(
                children: <Widget>[
                  Text(
                    'choose-date-label'.i18n(),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: fontsize16,
                        color: Colors.grey.withOpacity(0.8)),
                  ),
                  SizedBox(
                    width: sizeWidth(8, context),
                  ),
                  Text(
                    '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: fontsize16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: sizeWidth(32, context)),
            child: Container(
              decoration: BoxDecoration(
                color: HotelAppTheme.buildLightTheme().primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(sizeHeight(38, context)),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeHeight(32, context)),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(16, context)),
                    child: Icon(FontAwesomeIcons.magnifyingGlass,
                        size: MediaQuery.of(context).size.height * 0.025,
                        color: HotelAppTheme.buildLightTheme().backgroundColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI(context, PlantingProvider plantingProvider) {
    return !isShowbasicSearch
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
                left: sizeWidth(16, context),
                right: sizeWidth(16, context),
                top: sizeHeight(0, context),
                bottom: sizeHeight(0, context)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: sizeWidth(16, context),
                        top: sizeHeight(8, context),
                        bottom: sizeHeight(8, context)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(sizeHeight(38, context)),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: sizeWidth(16, context),
                            right: sizeWidth(16, context),
                            top: sizeHeight(4, context),
                            bottom: sizeHeight(4, context)),
                        child: TextField(
                          onChanged: (String txt) {
                            setState(() {
                              fieldNameValue = txt;
                            });
                          },
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.023,
                          ),
                          cursorColor:
                              HotelAppTheme.buildLightTheme().primaryColor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'searchPlanting'.i18n() + "...",
                              hintStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.019)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme_color2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(sizeHeight(38, context)),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (fieldNameValue == null || fieldNameValue == "") {
                          // _handleSearchButton(plantingProvider);
                          onfirstLoadData();
                        } else {
                          _handleSearchByKeyButton(plantingProvider);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(16, context)),
                        child: Icon(FontAwesomeIcons.magnifyingGlass,
                            size: MediaQuery.of(context).size.height * 0.025,
                            color: HotelAppTheme.buildLightTheme()
                                .backgroundColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  void _handleSearchByKeyButton(PlantingProvider provider) async {
    //call Service
    Map<String, dynamic> jsonData = {
      "key": fieldNameValue,
    };

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);

    setState(() {
      isShowbasicSearch = true;
    });
    provider.searchByKey(jsonData);
    isSearching = true;
  }

  Widget ExpantionSearch() {
    return ExpansionTile(
        textColor: Colors.black,
        iconColor: theme_color2,
        title: Text('ค้นหาเพิ่มเติม',
            style: TextStyle(
              fontSize: sizeHeight(18, context),
            )),
        onExpansionChanged: (bool isExpanded) {
          if (!isExpanded) {
            // print('Hello World');
            // dropdownfield.resetItemsAfterSearch();
          } else {
            // print('Save Value');
          }
        },
        leading: Icon(Icons.perm_contact_calendar_outlined),
        // subtitle: Text(selectedAddress +
        //     " " +
        //     selectedFieldName +
        //     " " +
        //     selectedOwnerName),
        children: [
          Container(
            color: Colors.tealAccent[50],
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  // controller: codeNameController,
                  decoration: InputDecoration(
                    labelText: 'ที่อยู่แปลง',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      addressValue = value;
                    });
                  },
                ),
                SizedBox(height: sizeHeight(16, context)),
                TextFormField(
                  controller: ownerController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อแปลง',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fieldNameValue = value;
                    });
                  },
                ),
                SizedBox(height: sizeHeight(16, context)),
                TextFormField(
                  // controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'เจ้าของแปลง',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(10, context)),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      ownerNameValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ]);
  }

  Widget getFilterBarUI(int numItemFounded) {
    PlantingProvider plantingProvider =
        Provider.of<PlantingProvider>(context, listen: false);
    String fieldName = plantingProvider.fieldName;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.01,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: EdgeInsets.only(
              left: sizeWidth(16, context),
              right: sizeWidth(16, context),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: sizeHeight(8, context),
                        bottom: sizeHeight(8, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              fieldName == ""
                                  ? 'platings-founded-label'.i18n() +
                                      ' ${numItemFounded}'
                                  : 'platings-founded-id-label'.i18n() +
                                      " ${fieldName}" +
                                      ' (${numItemFounded})',
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.0204,
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
          ),
        ),
      ],
    );
  }

  Widget _buildCreateNewCultivation(PlantingProvider plantingProvider) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.01,
      right: MediaQuery.of(context).size.width * 0.01,
      child: GestureDetector(
        child: isVisible == true
            ? Container(
                decoration: BoxDecoration(
                  // color: HotelAppTheme.buildLightTheme()
                  //     .primaryColor
                  //     .withOpacity(0.75),
                  color: theme_color2.withOpacity(0.75),
                  borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.height * 0.048),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: Offset(0, 2),
                        blurRadius: sizeWidth(8, context)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(sizeHeight(32, context)),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       maintainState: false,
                      //       builder: (context) =>
                      //            NewCultivationScreen(0, null)),
                      // );

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Provider(
                              create: (context) => Dropdownfield(),
                              builder: (context, child) => NewCultivationScreen(
                                  0, null, plantingProvider)),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.0204),
                      child: Icon(FontAwesomeIcons.add,
                          size: MediaQuery.of(context).size.height * 0.025,
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  void _handleSearchButton(PlantingProvider provider) async {
    //call Service
    Map<String, dynamic> jsonData = {
      "address": addressValue,
      "endDate": endDateSelect,
      "fieldName": fieldNameValue,
      "ownerName": ownerNameValue,
      "plantingName": plantingNameValue,
      "startDate": startDateSelect
    };
    // print("fieldName = ");
    // print(fieldNameValue);

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    //print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    provider.search(jsonData);
    isSearching = true;
  }

  Widget searchMore1(PlantingProvider provider) {
    var _startDateUserNameColor = Colors.black;
    String _startDateTimeText = " Start Date";
    // for search
    void _startDateTFToggle(e) {
      setState(() {
        //_rqVisible = !_rqVisible;
        _startDateTimeText = "Start Date";
        _startDateUserNameColor = Colors.black;
      });
    }

    TextField _startDateTextField = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: startDate,
          firstDate: DateTime(1900),
          lastDate: endDate,
        );
        if (newDate == null) return;
        setState(() {
          startDate = newDate;
        });
        startDateController.text = startDate.toIso8601String();
        startDateSelect = startDate.millisecondsSinceEpoch;
        startDateController.text = DateFormat("dd-MM-yyyy").format(startDate);
      },
      controller: startDateController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
          fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white),
        hintText: 'pick-start-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField _endDateTextField = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newDate = await showDatePicker(
          context: context,
          initialDate: endDate,
          firstDate: startDate,
          lastDate: DateTime(2100),
        );
        if (newDate == null) return;
        setState(() {
          endDate = newDate;
        });
        endDateController.text = endDate.toIso8601String();
        endDateSelect = endDate.millisecondsSinceEpoch;
        endDateController.text = DateFormat("dd-MM-yyyy").format(endDate);
      },
      controller: endDateController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
          fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.white,
        ),
        hintText: 'pick-end-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    return Column(
      children: [
        ListTile(
          title: Text('search-more'.i18n()),
          leading: Icon(
            Icons.perm_contact_calendar_outlined,
            color: isShowbasicSearch == false ? theme_color2 : Colors.grey,
            size: sizeHeight(25, context),
          ),
          trailing: Icon(
            isShowbasicSearch == false
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: isShowbasicSearch == false ? theme_color2 : Colors.grey,
            size: sizeHeight(25, context),
          ),
          onTap: () {
            setState(() {
              isShowbasicSearch = !isShowbasicSearch;
            });
          },
        ),
        if (!isShowbasicSearch)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeHeight(16, context)),
            child: Column(
              children: [
                Container(
                  color: Colors.tealAccent[50],
                  padding: EdgeInsets.all(sizeHeight(16, context)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: codeNameController,
                        decoration: InputDecoration(
                          labelText: 'planting-address'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            addressValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      TextFormField(
                        controller: ownerController,
                        decoration: InputDecoration(
                          labelText: "name-field-label".i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fieldNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          labelText: "planting-owner".i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            ownerNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      TextFormField(
                        controller: cultivationController,
                        decoration: InputDecoration(
                          labelText: 'name-planting-label'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            plantingNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "start-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeWidth(16, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: _startDateTextField,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: sizeWidth(8, context))),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "end-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeWidth(16, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: _endDateTextField,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: sizeHeight(2, context),
                      left: sizeWidth(20, context),
                      right: sizeWidth(20, context),
                      bottom: sizeHeight(20, context)),
                  height: sizeHeight(50, context),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(18, context)),
                      //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
                    ),
                    onPressed: () {
                      if (addressValue == "" &&
                          fieldNameValue == "" &&
                          ownerNameValue == "" &&
                          plantingNameValue == "" &&
                          startDateSelect == 0 &&
                          endDateSelect == 0) {
                        onfirstLoadData();
                      } else {
                        _handleSearchButton(provider);
                      }
                    },
                    padding: EdgeInsets.all(sizeHeight(10, context)),
                    color: theme_color2,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "search".i18n(),
                          style: TextStyle(fontSize: sizeHeight(20, context)),
                        ),
                        SizedBox(width: sizeWidth(5, context)),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final plantingProvider = Provider.of<PlantingProvider>(context);
    // print("Page Base Planting Context: $context");
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Consumer<PlantingProvider>(builder: (context, data, index) {
          // List<Planting> plantings = data.plantings;
          // List<User> owners = data.owners;
          // List<Field> fields = data.fields;
          // List<String> locations = data.locations;

          // List<String> list_fieldName = data.list_fieldName;
          // List<String> list_substrict = data.list_substrict;
          // List<String> list_district = data.list_district;
          // List<String> list_province = data.list_province;
          // List<String> list_title = data.list_title;
          // List<String> list_firstName = data.list_firstName;
          // List<String> list_lastName = data.list_lastName;
          return WillPopScope(
            onWillPop: () => onBackButtonPressed(context),
            child: Scaffold(
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
                        getAppBarUI(),
                        _istLoading
                            ? Container()
                            : Expanded(
                                child:
                                    NotificationListener<ScrollEndNotification>(
                                  onNotification:
                                      (ScrollEndNotification scrollInfo) {
                                    if (data.plantingData.length < 2) {
                                      if (scrollInfo.depth == 0) {
                                        if (scrollInfo.metrics.pixels <
                                            scrollInfo
                                                .metrics.maxScrollExtent) {
                                          check = 0;
                                        } else if (check == 0) {
                                          fetchMoreData(context);

                                          check = 1;
                                        }
                                      }
                                    } else {
                                      if (scrollInfo.depth == 1) {
                                        if (scrollInfo.metrics.pixels <
                                            scrollInfo
                                                .metrics.maxScrollExtent) {
                                          check = 0;
                                        } else if (check == 0) {
                                          fetchMoreData(context);

                                          check = 1;
                                        }
                                      }
                                    }
                                    // print(
                                    //     "${scrollInfo.depth} position :  ${scrollInfo.metrics.pixels}   : ${scrollInfo.metrics.maxScrollExtent}   check : ${check}");
                                    if (check == 1) {
                                      if (data.plantingData.length ==
                                          data.numberAllPlantings) {
                                        showToastMessage(
                                            "ข้อมูลแสดงครบทั้งหมดเป็นที่เรียบร้อยแล้ว");
                                      }
                                    }
                                    return true;
                                  },
                                  child: RefreshIndicator(
                                    onRefresh: _pullRefresh,
                                    child: NestedScrollView(
                                      controller: _scrollController,
                                      headerSliverBuilder:
                                          (BuildContext context,
                                              bool innerBoxIsScrolled) {
                                        return <Widget>[
                                          SliverList(
                                            delegate:
                                                SliverChildBuilderDelegate(
                                                    (BuildContext context,
                                                        int index) {
                                              return Column(
                                                children: <Widget>[
                                                  getSearchBarUI(context,
                                                      plantingProvider),
                                                  // getTimeDateUI(),
                                                  // searchMore(plantingProvider)
                                                  searchMore1(plantingProvider),
                                                ],
                                              );
                                            }, childCount: 1),
                                          ),
                                          SliverPersistentHeader(
                                            pinned: true,
                                            floating: true,
                                            delegate: ContestTabHeader(Column(
                                              children: <Widget>[
                                                getFilterBarUI(
                                                    data.numberAllPlantings)
                                              ],
                                            )),
                                          ),
                                        ];
                                      },
                                      body: data.isLoading
                                          ? Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.white.withOpacity(1),
                                                    theme_color3
                                                        .withOpacity(.4),
                                                    theme_color4.withOpacity(1),
                                                  ],
                                                ),
                                              ),
                                              child: data
                                                      .plantingData.isNotEmpty
                                                  ? ListView.builder(
                                                      //controller: _inerscrollController,
                                                      itemCount: data
                                                          .plantingData.length,
                                                      padding: EdgeInsets.only(
                                                          top: sizeHeight(
                                                              8, context)),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // Planting planting = plantings[index];
                                                        String
                                                            temp_plantingName =
                                                            data
                                                                .plantingData[
                                                                    index]
                                                                .planting
                                                                .name;

                                                        RegExp regex = RegExp(
                                                            r'\([^)]*\)');
                                                        String result =
                                                            temp_plantingName
                                                                .replaceAll(
                                                                    regex, '');
                                                        String plantingName =
                                                            result.trim();
                                                        // Adding new
                                                        String fieldName = data
                                                            .plantingData[index]
                                                            .fieldName;
                                                        String substrict = data
                                                            .plantingData[index]
                                                            .substrict;
                                                        String district = data
                                                            .plantingData[index]
                                                            .district;
                                                        String province = data
                                                            .plantingData[index]
                                                            .province;
                                                        String title = data
                                                            .plantingData[index]
                                                            .title;
                                                        String firstName = data
                                                            .plantingData[index]
                                                            .firstName;
                                                        String lastName = data
                                                            .plantingData[index]
                                                            .lastName;

                                                        final int count = data
                                                                    .plantingData
                                                                    .length >
                                                                10
                                                            ? 10
                                                            : data.plantingData
                                                                .length;
                                                        final Animation<
                                                            double> animation = Tween<
                                                                    double>(
                                                                begin: 0.0,
                                                                end: 1.0)
                                                            .animate(CurvedAnimation(
                                                                parent:
                                                                    animationController!,
                                                                curve: Interval(
                                                                    (1 / count) *
                                                                        index,
                                                                    1.0,
                                                                    curve: Curves
                                                                        .fastOutSlowIn)));
                                                        animationController
                                                            ?.forward();
                                                        return CardItemWithOutImage_Planting(
                                                          plantings: data
                                                              .plantingData[
                                                                  index]
                                                              .planting,
                                                          provider:
                                                              plantingProvider,
                                                          callback2: () {
                                                            widget
                                                                .mainTapController
                                                                .animateTo(3);
                                                            SurveyProvider
                                                                surveyProvider =
                                                                Provider.of<
                                                                        SurveyProvider>(
                                                                    context,
                                                                    listen:
                                                                        false);
                                                            surveyProvider
                                                                    .plantingId =
                                                                data
                                                                    .plantingData[
                                                                        index]
                                                                    .planting
                                                                    .plantingId;
                                                            surveyProvider
                                                                    .plantingName =
                                                                data
                                                                    .plantingData[
                                                                        index]
                                                                    .planting
                                                                    .name;
                                                          },
                                                          callback: () {
                                                            // Navigator.push(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //       builder: (context) =>
                                                            //           PlantingMoreDetailScreen(
                                                            //               planting,
                                                            //               plantingProvider)),
                                                            // );
                                                          },
                                                          itemName:
                                                              "${fieldName}",
                                                          itemID:
                                                              "${plantingName}",
                                                          city: "อ." +
                                                              "${district}," +
                                                              " จ." +
                                                              "${province}",
                                                          district: "ต." +
                                                              "${substrict}",
                                                          itemOwnerName:
                                                              "${title} ${firstName}",
                                                          itemOwnerLastName:
                                                              "${lastName}",
                                                          animation: animation,
                                                          animationController:
                                                              animationController!,
                                                          date: ChangeDateTime(
                                                              data
                                                                  .plantingData[
                                                                      index]
                                                                  .planting
                                                                  .createDate),
                                                        );
                                                      })
                                                  : NoData()
                                                      .showNoData(context),
                                            )
                                          : shimmerLoading(),
                                    ),
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  data.isLoading
                      ? (data.isHaveField
                          ? _buildCreateNewCultivation(data)
                          : Container())
                      : Container(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<bool> onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("notification-label".i18n()),
        content: Text("exit-application".i18n()),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              'No',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: Text(
              'Yes',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );

    return exitApp ?? false;
  }

  Widget _buildMultiSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.07,
      //height:MediaQuery.of(context).size.height*0.05,
      child: new TextFormField(
        decoration: new InputDecoration(
          labelText: 'search'.i18n(),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(sizeHeight(25, context)),
            borderSide: new BorderSide(),
          ),
          //fillColor: Colors.green
        ),
      ),
    );
  }

  Shimmer mockShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[700]!,
      highlightColor: Colors.grey[500]!,
      child: Column(
        children: [
          Container(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                          width: sizeWidth(600, context),
                          height: sizeHeight(50, context),
                          color: Colors.grey.withOpacity(0.4),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: sizeWidth(15, context),
                              top: sizeHeight(8, context),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.grass_sharp,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' การเพาะปลูก',
                                  style: TextStyle(
                                      fontSize: sizeHeight(16, context),
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: sizeWidth(8, context),
                                      bottom: sizeHeight(4, context)),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.grey.withOpacity(
                                          0.4), // Change the button color here
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            50.0), // Set the border radius here
                                      ),
                                    ),
                                    onPressed: () {
                                      //  print('Button Pressed');
                                    },
                                    child: Icon(Icons.info_outline_rounded,
                                        color: Colors.white,
                                        size: sizeHeight(25, context)),
                                  ),
                                )
                              ],
                            ),
                          )),
                      Container(
                        width: sizeWidth(500, context),
                        height: sizeHeight(0.5, context),
                        color: Colors.black.withOpacity(0.00000005),
                      ),
                      Container(
                        color: Colors.grey.withOpacity(0.4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: sizeWidth(16, context),
                                      top: sizeHeight(8, context),
                                      bottom: sizeHeight(8, context)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: sizeHeight(4, context))),
                                      Row(
                                        children: [
                                          Text(
                                            ' แปลง : ชื่อแปลง',
                                            style: TextStyle(
                                              fontSize: sizeHeight(14, context),
                                            ),
                                          ),
                                          Text(
                                            '',
                                            style: TextStyle(
                                                fontSize:
                                                    sizeHeight(16, context),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: sizeHeight(8, context))),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(
                                            FontAwesomeIcons.locationDot,
                                            size: sizeHeight(14, context),
                                            color: Colors.red,
                                          ),
                                          Text(
                                            'อำเภอ, จังหวัด',
                                            style: TextStyle(
                                              fontSize: sizeHeight(14, context),
                                            ),
                                          ),
                                          SizedBox(
                                            width: sizeWidth(4, context),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: sizeHeight(8, context))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sizeHeight(8, context),
                                      right: sizeWidth(8, context)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: theme_color2,
                                        size: 20,
                                      ),
                                      Text(
                                        " เจ้าของแปลง",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: sizeHeight(14, context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: sizeHeight(14, context),
                                      right: sizeWidth(8, context)),
                                  child: Text(
                                    ' ',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: sizeHeight(14, context),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: sizeHeight(23.5, context)),
        ],
      ),
    );
  }

  Widget shimmerLoading() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(1),
            theme_color3.withOpacity(.4),
            theme_color4.withOpacity(1),
            //Colors.white.withOpacity(1),
            //Colors.white.withOpacity(1),
          ],
        ),
      ),
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.only(top: sizeHeight(8, context)),
        itemBuilder: (context, index) {
          return mockShimmer();
        },
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
