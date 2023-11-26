import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
//import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/subdistrict_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/subdistrict.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/screen/survey/base_survey_screen.dart';

import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../entities/field.dart';
import '../../entities/planting.dart';
import '../../entities/survey.dart';
import '../../entities/targetofsurvey.dart';
import '../../entities/userinfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import '../../main.dart';
import '../../util/size_config.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SearchSurveyFieldScreen extends StatefulWidget {
  
  SearchSurveyFieldScreen(this.mainTapController,this.surveyProvider, {Key? key}) : super(key: key) ;
  TabController mainTapController;
  SurveyProvider surveyProvider;

  @override
  SearchSurveyFieldScreenState createState() => SearchSurveyFieldScreenState();
}

class SearchSurveyFieldScreenState extends State<SearchSurveyFieldScreen> {
   //------------- for search
  bool isSearching = false;
  TextEditingController codeNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cultivationController = TextEditingController();
  TextEditingController startDatePlantingController = TextEditingController();
  TextEditingController endDatePlantingController = TextEditingController();
  TextEditingController startDateSurveyController = TextEditingController();
  TextEditingController endDateSurveyController = TextEditingController();
  String addressValue = '';
  String fieldNameValue = '';
  String ownerNameValue = '';
  String plantingNameValue = '';
  int startDatePlantingSelect = 0;
  int endDatePlantingSelect = 0;
  int startDateSurveySelect = 0;
  int endDateSurveySelect = 0;
  DateTime _startDatePlanting = DateTime.now();
  DateTime _endDatePlanting = DateTime.now().add(const Duration(days: 5));
  DateTime _startDateSurvey = DateTime.now();
  DateTime _endDateSurvey = DateTime.now().add(const Duration(days: 5));

  bool isShowbasicSearch = true;
  GlobalKey expansionTileKey = GlobalKey();
  //------------------

  @override
  void dispose() {
  
    super.dispose();
  }






  _scrollListener() {}
  int length = Random().nextInt(10);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    asyncFunction();
  }

  asyncFunction() async {
    // await _onloadField();
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }



  Widget searchMore1(SurveyProvider provider) {
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

    TextField startDatePlanting = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newStartDate = await showDatePicker(
          context: context,
          initialDate: _startDatePlanting,
          firstDate: DateTime(1900),
          lastDate: _endDatePlanting,
        );
        if (newStartDate == null) return;
        setState(() {
          _startDatePlanting = newStartDate;
        });
        startDatePlantingController.text = _startDatePlanting.toIso8601String();
        startDatePlantingSelect = _startDatePlanting.millisecondsSinceEpoch;
        startDatePlantingController.text =
            DateFormat("dd-MM-yyyy").format(_startDatePlanting);
      },
      controller: startDatePlantingController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.black),
        
        hintText: 'pick-start-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField endDatePlanting = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newEndDate = await showDatePicker(
          context: context,
          initialDate: _endDatePlanting,
          firstDate: _startDatePlanting,
          lastDate: DateTime(2100),
        );
        if (newEndDate == null) return;
        setState(() {
          _endDatePlanting = newEndDate;
        });
        endDatePlantingController.text = _endDatePlanting.toIso8601String();
        endDatePlantingSelect = _endDatePlanting.millisecondsSinceEpoch;
        endDatePlantingController.text =
            DateFormat("dd-MM-yyyy").format(_endDatePlanting);
      },
      controller: endDatePlantingController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: 'pick-end-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField startDateSurvey = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newStartDate = await showDatePicker(
          context: context,
          initialDate: _startDateSurvey,
          firstDate: DateTime(1900),
          lastDate: _endDateSurvey,
        );
        if (newStartDate == null) return;
        setState(() {
          _startDateSurvey = newStartDate;
        });
        startDateSurveyController.text = _startDateSurvey.toIso8601String();
        startDateSurveySelect = _startDateSurvey.millisecondsSinceEpoch;
        startDateSurveyController.text =
            DateFormat("dd-MM-yyyy").format(_startDateSurvey);
      },
      controller: startDateSurveyController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.black),
        hintText: 'pick-start-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField endDateSurvey = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newEndDate = await showDatePicker(
          context: context,
          initialDate: _endDateSurvey
          firstDate: _startDateSurvey,
          lastDate: DateTime(2100),
        );
        if (newEndDate == null) return;
        setState(() {
          _endDateSurvey = newEndDate;
        });
        endDateSurveyController.text = _endDateSurvey.toIso8601String();
        endDateSurveySelect = _endDateSurvey.millisecondsSinceEpoch;
        endDateSurveyController.text =
            DateFormat("dd-MM-yyyy").format(_endDateSurvey);
      },
      controller: endDateSurveyController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.black, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.black),
        hintText: 'pick-end-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    return Column(
      children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: sizeHeight(16, context)),
            child: Column(
              children: [
                Container(
                  color: Colors.tealAccent[50],
                  padding:  EdgeInsets.all(sizeHeight(20, context)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: codeNameController,
                        decoration: InputDecoration(
                          labelText: 'field-address'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
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
                          labelText: 'name-field-label'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
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
                          labelText: 'owner'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
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
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
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
                                  "plant-start-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: startDatePlanting,
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
                                   "plant-end-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: endDatePlanting,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                                   "survey-start-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: startDateSurvey,
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
                                  "survey-end-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: endDateSurvey,
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
                  margin:
                      EdgeInsets.only(
                      top: sizeHeight(2, context),
                      left: sizeWidth(20, context),
                      right: sizeWidth(20, context),
                      bottom: sizeHeight(20, context)),
                  height: sizeHeight(50, context),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(sizeHeight(18, context)),
                      //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
                    ),
                    onPressed: () {
                      if (addressValue == "" && fieldNameValue == "" && ownerNameValue == "" && plantingNameValue == "" && startDateSurveySelect == 0 && endDateSurveySelect == 0 && startDatePlantingSelect == 0 && endDatePlantingSelect == 0) {
                        asyncFunction();
                      }
                      else {
                        _handleSearchButton();
                      }
                       Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SurveyTable(widget.mainTapController,widget.surveyProvider),
                        //   ));
                        widget
                        .mainTapController
                        .animateTo(3);
                        
                   
                    },
                    padding: EdgeInsets.all(sizeHeight(10, context)),
                    color: theme_color2,
                    textColor: Colors.black,
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

    void _handleSearchButton() async {
    //call Service
    Map<String, dynamic> jsonData = {
      "address": addressValue,
      "endDate": endDatePlantingSelect,
      "fieldName": fieldNameValue,
      "ownerName": ownerNameValue,
      "plantingName": plantingNameValue,
      "startDate": startDatePlantingSelect,
      "surveyEndDate": endDateSurveySelect,
      "surveyStartDate": startDateSurveySelect,
    };

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    widget.surveyProvider.isSearch =true;
     widget.surveyProvider.search(jsonData);

    isSearching = true;
  }


  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
     SurveyProvider surveyProvider =widget.surveyProvider;
    print("Page Base SurveySearch Context: $context");
    
    return 
       Scaffold(
      appBar: AppBar(
        toolbarHeight: sizeHeight(60, context),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'more-filer-label'.i18n(),
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: sizeHeight(24, context),
          ),
        ),
        backgroundColor: theme_color,
        elevation: 0,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: sizeWidth(20, context)),
            child: IconButton(
                icon: Icon(
                  Icons.cancel_rounded,
                  color: Colors.black,
                  size: sizeHeight(28, context),
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          )
        ],
      ),
      //extendBodyBehindAppBar: true,
      body: searchMore1(surveyProvider),

    );
    
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  void itemSelectionChanged(String? s) {
    print(s);
  }


}
