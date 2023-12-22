import 'dart:async';
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
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/stp_value.dart';
import 'package:mun_bot/entities/subdistrict.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant_gallery.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_detail.dart';

import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/ui/checkbox.dart';
import 'package:mun_bot/util/ui/input.dart';
import '../../../../../entities/field.dart';
import '../../../../../entities/planting.dart';
import '../../../../../entities/survey.dart';
import '../../../../../entities/targetofsurvey.dart';
import '../../../../../entities/userinfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/survey/base_survey_screen.dart';

import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/ui/radio_item.dart';
import 'package:mun_bot/util/shake_widget.dart';

//Adding by Chanakan
import 'package:dropdown_search/dropdown_search.dart';

import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../util/size_config.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class STPvalueAndCon {
  SurveyTargetPointValue stp;
  TextEditingController controller;
  double himidityValue;
  int point;

  STPvalueAndCon(this.stp, this.controller, this.himidityValue, this.point);
}

class BaseSurveyScreenEnemy extends StatefulWidget {
  Survey survey;
  late int point;
  late int number;

  List<String> radioValue = [];
  BaseSurveyScreenEnemy(this.point, this.number, this.survey);
  @override
  State<StatefulWidget> createState() => _BaseSurveyScreenEnemy();
}

class _BaseSurveyScreenEnemy extends State<BaseSurveyScreenEnemy>
    with TickerProviderStateMixin {
  String? selectedValue;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  int usedController = 0;
  List<STPvalueAndCon> stpDisease = [];
  List<STPvalueAndCon> stpNatural = [];
  List<STPvalueAndCon> stpPest = [];
  //date
  TextEditingController dateinputPlanting = TextEditingController();
  TextEditingController dateinputSurvey = TextEditingController();
  TextEditingController humidityController = TextEditingController();
  //text editing controller for text field
  ScrollController? _scrollController;

  double _opacity = 0.0;

  List<SurveyTargetPointValue> stpsPest = [];
  List<SurveyTargetPointValue> stpsNatural = [];
  List<SurveyTargetPointValue> stpsDisease = [];

  BaseSurveySubPointEnemy? baseSurveySubPointEnemy;
  _scrollListener() {}
  int length = Random().nextInt(10);
  bool isLoading = true;

  List<List<CheckBoxState>> twoDList = [];

  Future<bool> submitFunction() async {
    String? token = tokenFromLogin?.token;
    SurveyTargetPointService surveyTargetPoint = SurveyTargetPointService();
    List<Map<String, dynamic>> updateDisease = [];
    List<Map<String, dynamic>> updateNatural = [];
    List<Map<String, dynamic>> updatePest = [];

    for (int i = 0; i < widget.radioValue.length; i++) {
      updateDisease.add(
        {
          "surveyTargetId": stpDisease[i].stp.surveyTargetId,
          "targetOfSurveyName": "string",
          "value": widget.radioValue[i].substring(0, 1)
        },
      );
    }

    stpNatural.forEach((e) {
      updateNatural.add(
        {
          "surveyTargetId": e.stp.surveyTargetId,
          "targetOfSurveyName": "string",
          "value": e.himidityValue.toInt()
        },
      );
    });

    stpPest.forEach((e) {
      updatePest.add(
        {
          "surveyTargetId": e.stp.surveyTargetId,
          "targetOfSurveyName": "string",
          "value": e.himidityValue.toInt()
        },
      );
    });

    // //print("---- update disease -----");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingWidget(
        message: "Submiting...",
      ),
    );
    // //print(updateDisease);
    int statusCodeDisease =
        await surveyTargetPoint.updateSurveyTargetPointDisease(
            token.toString(), widget.point, widget.number, updateDisease);
    int statusCodeNatural =
        await surveyTargetPoint.updateSurveyTargetPointNatural(
            token.toString(), widget.point, widget.number, updateNatural);
    int statusCodePest =
        await surveyTargetPoint.updateSurveyTargetPointPestPhase(
            token.toString(), widget.point, widget.number, updatePest);

    // //print(
    //     " statusCode : ${statusCodeDisease} ${statusCodeNatural} ${statusCodePest}");
    if (statusCodeDisease == 200 &&
        statusCodeNatural == 200 &&
        statusCodePest == 200) {
      Navigator.pop(context);
      return true;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    // baseSurveySubPointEnemy!.MyCallback(1);
    // Trigger the opacity animation after a delay of 500ms
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    //print("item : ${widget.point}  ${widget.number} surveyId : ${widget.survey.surveyID}");
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    dateinputPlanting.text = "";
    dateinputSurvey.text = "";
    asyncFunction();
  }

  void _toggleTab() {
    setState(() {
      _tabIndex = _tabController!.index;
      if (_tabIndex <= 1) {
        _tabIndex = _tabController!.index + 1;
        _tabController!.animateTo(_tabIndex);
      }
    });
  }

  void _toggleTabBack() {
    setState(() {
      _tabIndex = _tabController!.index;
      if (_tabIndex > 0) {
        _tabIndex = _tabController!.index - 1;
        _tabController!.animateTo(_tabIndex);
      } else {
        Navigator.of(context).pop();
      }
    });
  }

  asyncFunction() async {
    stpsPest = [];
    stpsNatural = [];
    stpsDisease = [];

    usedController = 0;
    //print("${widget.survey.surveyID} + "" +  ${widget.point} + "" + ${widget.number}");
    String? token = tokenFromLogin?.token;
    SurveyTargetPointService surveyTargetPoint = SurveyTargetPointService();
    stpsDisease = await surveyTargetPoint.surveyTargetPointDiseaseBySurveyId(
        token.toString(), widget.survey.surveyID, widget.point, widget.number);
    stpsNatural = await surveyTargetPoint.surveyTargetPointNaturalBySurveyId(
        token.toString(), widget.survey.surveyID, widget.point, widget.number);
    stpsPest = await surveyTargetPoint.surveyTargetPointPestphaseBySurveyId(
        token.toString(), widget.survey.surveyID, widget.point, widget.number);

    stpsDisease.forEach((e) {
      stpDisease.add(STPvalueAndCon(e, TextEditingController(),
          e.surveyTargetPoints.value.toDouble(), widget.point));
    });
    stpsNatural.forEach((e) {
      stpNatural.add(STPvalueAndCon(e, TextEditingController(),
          e.surveyTargetPoints.value.toDouble(), widget.point));
    });
    stpsPest.forEach((e) {
      stpPest.add(STPvalueAndCon(e, TextEditingController(),
          e.surveyTargetPoints.value.toDouble(), widget.point));
      //print("stpPest = ${e.surveyTargetPoints.surveyTargetPointId}");
      //print("stpPestV = ${e.surveyTargetPoints.value.toDouble()}");
    });

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
    twoDList = [];
    for (int i = 0; i < stpDisease.length; i++) {
      twoDList.add([
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState()
      ]);
      widget.radioValue.add(stpDisease[i].himidityValue.toInt().toString());
    }
    for (int i = 0; i < twoDList.length; i++) {
      twoDList[i][stpDisease[i].himidityValue.toInt()].value = true;
    }

    colors = List.generate(twoDList.length,
        (i) => List.generate(6 + 1, (j) => false, growable: false),
        growable: false);
  }

  bool isVisible = true;

  int selectedValues = 1;
  int _tabIndex = 0;

  TabController? _tabController;
  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
            // appBar: PreferredSize(
            //   preferredSize:
            //       Size.fromHeight(MediaQuery.of(context).size.height * 0.085),
            //   child: getAppBarUI(),
            // ),
            // //extendBodyBehindAppBar: true,
            body: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white38.withOpacity(1.0),
                            theme_color2.withOpacity(.9),
                            theme_color3.withOpacity(.8),
                            Colors.white.withOpacity(.8),
                            Colors.white.withOpacity(1),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.black,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                width: sizeWidth(80, context)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "สิ่งสำรวจ",
                                                  style: TextStyle(
                                                      fontSize: sizeHeight(
                                                          25, context),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            // const SizedBox(width: 70),
                                            // Column(
                                            //   children: [
                                            //     Material(
                                            //       color: Colors.transparent,
                                            //       child: InkWell(
                                            //         borderRadius:
                                            //             const BorderRadius.all(
                                            //           Radius.circular(32.0),
                                            //         ),
                                            //         onTap: () {
                                            //           //print(
                                            //               "--------------------123-----test-----------------");
                                            //           submitFunction();
                                            //         },
                                            //         child: Padding(
                                            //           padding:
                                            //               const EdgeInsets.all(
                                            //                   8.0),
                                            //           child: Icon(Icons.save,
                                            //               color: Colors.greenAccent),
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                const SizedBox(width: 90),
                                                Container(
                                                  height: 45,
                                                  // width: MediaQuery.of(context).size.width,
                                                  // decoration: BoxDecoration(
                                                  //     color: Colors.transparent,
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             10.0)),
                                                  child: TabBar(
                                                    onTap: (value) {
                                                      setState(() {
                                                        //print("value${value}");
                                                        _tabController!.index =
                                                            value;
                                                        _tabIndex = value;
                                                      });
                                                    },
                                                    controller: _tabController,
                                                    isScrollable: true,
                                                    // labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
                                                    indicator: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                    ),
                                                    labelColor: Colors.black,
                                                    unselectedLabelColor:
                                                        Colors.white,
                                                    labelStyle: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey),
                                                    tabs: [
                                                      Tab(
                                                        text: 'Disease'.i18n(),
                                                      ),
                                                      Tab(
                                                        text: 'NaturalEnermies'
                                                            .i18n(),
                                                      ),
                                                      Tab(
                                                        text:
                                                            'PestPhase'.i18n(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.26,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, left: 10, right: 10),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: TabBarView(
                                            controller: _tabController,
                                            children: [
                                              Container(
                                                child: ListView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  children: [
                                                    AnimatedOpacity(
                                                      opacity: _opacity,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: !isLoading
                                                            ? _buildListViewDisease(
                                                                stpDisease)
                                                            : SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight! *
                                                                    0.7,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<Color>(
                                                                            theme_color),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: ListView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  children: [
                                                    AnimatedOpacity(
                                                      opacity: _opacity,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: !isLoading
                                                            ? _buildListViewNaturalAndPest(
                                                                stpNatural)
                                                            : SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight! *
                                                                    0.7,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<Color>(
                                                                            theme_color),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: ListView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  children: [
                                                    AnimatedOpacity(
                                                      opacity: _opacity,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 15),
                                                        child: !isLoading
                                                            ? _buildListViewNaturalAndPest(
                                                                stpPest)
                                                            : SizedBox(
                                                                height: SizeConfig
                                                                        .screenHeight! *
                                                                    0.7,
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    valueColor:
                                                                        AlwaysStoppedAnimation<Color>(
                                                                            theme_color),
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // floatingActionButton: FloatingActionButton.extended(
            //   onPressed: () {
            //     submitFunction();
            //   },
            //   backgroundColor: theme_color2,
            //   icon: Icon(Icons.check_box),
            //   label: Text(
            //     "บันทึก",
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            floatingActionButton: !isLoading
                ? Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        SizedBox(
                          width: sizeWidth(32, context),
                        ),
                        _tabIndex > 0
                            ? SizedBox(
                                width: sizeWidth(170, context),
                                height: sizeHeight(50, context),
                                child: FloatingActionButton(
                                  backgroundColor: theme_color2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        sizeHeight(18, context)),
                                  ),
                                  mini: true,
                                  onPressed: () => {_toggleTabBack()},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.navigate_before),
                                      Text(
                                        "previous-label".i18n(),
                                        style: TextStyle(
                                            fontSize: sizeHeight(18, context)),
                                      ),
                                    ],
                                  ),
                                  heroTag: "fab2",
                                ),
                              )
                            : Container(
                                width: 0,
                                height: 0,
                              ),
                        Spacer(),
                        _tabIndex <= 1
                            ? SizedBox(
                                width: _tabIndex == 0
                                    ? sizeWidth(350, context)
                                    : sizeWidth(170, context),
                                height: sizeHeight(50, context),
                                child: FloatingActionButton(
                                  backgroundColor: theme_color2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        sizeHeight(18, context)),
                                  ),
                                  mini: true,
                                  onPressed: () => {_toggleTab()},
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "next-label".i18n(),
                                        style: TextStyle(
                                            fontSize: sizeHeight(18, context)),
                                      ),
                                      Icon(Icons.navigate_next),
                                    ],
                                  ),
                                  heroTag: "fab3",
                                ),
                              )
                            : SizedBox(
                                width: sizeWidth(170, context),
                                height: sizeHeight(50, context),
                                child: FloatingActionButton(
                                  backgroundColor: theme_color2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        sizeHeight(18, context)),
                                  ),
                                  mini: true,
                                  onPressed: () async {
                                    await submitFunction().then((value) {
                                      if (value) {
                                        if (mounted) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop(true);
                                        }
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_box),
                                      Text(
                                        "save".i18n(),
                                        style: TextStyle(
                                            fontSize: sizeHeight(18, context)),
                                      ),
                                    ],
                                  ),
                                  heroTag: "fab3",
                                ),
                              ),
                      ])
                : Container()

            //
            ),
      ),
    );
  }

  Widget _buildListView(List<STPvalueAndCon> data, int index) {
    String surveyImage = 'assets/images/cassava_field.jpg';
    List<Widget> t = [];

    return Container(
        width: SizeConfig.screenWidth! * 0.9,
        height: SizeConfig.screenHeight,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: 1,
          itemBuilder: (context, index) {
            t = [];
            for (int i = 0; i < data.length; i++) {
              t.add(
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  elevation: 5,
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: SizeConfig.screenWidth! * 0.9,
                    height: SizeConfig.screenHeight! * 0.5,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              Gallery(data[i].stp.surveyTargetId))),
                      child: AspectRatio(
                        aspectRatio: 1.6 / 2,
                        child: Container(
                          //margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Text(
                                    data[i].stp.surveyTargetName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'OpenSans',
                                        fontSize: 20),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                  Image.asset(
                                    surveyImage,
                                    width: SizeConfig.screenWidth! * 0.77,
                                    fit: BoxFit.cover,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'level'.i18n(),
                                        style: TextStyle(
                                            color: theme_color,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize: 18),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0)),
                                      Container(
                                          height:
                                              SizeConfig.screenHeight! * 0.06,
                                          width: SizeConfig.screenWidth! * 0.09,
                                          //width: SizeConfig.screenWidth! * 0.1,
                                          child: TextField(
                                            controller: data[i].controller,
                                          )),
                                    ],
                                  ),
                                  Container(
                                    width: SizeConfig.screenWidth! * 0.7,
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        thumbColor: theme_color2,
                                        overlayColor: theme_color,
                                        activeTrackColor: theme_color,
                                        inactiveTrackColor:
                                            Colors.purple.shade50,
                                        //thumbShape: RoundSliderThumbShape(
                                        //enabledThumbRadius: 10)
                                      ),
                                      child: Slider(
                                        min: 0,
                                        max: 5,
                                        divisions: 5,
                                        value: data[i].himidityValue,
                                        onChanged: (value) {
                                          data[i].himidityValue = value;
                                          setState(() {
                                            String t =
                                                ((((data[i].himidityValue * 1000)
                                                                        .ceil() /
                                                                    1000) *
                                                                100)
                                                            .ceil() /
                                                        100)
                                                    .toString()
                                                    .substring(0, 1);
                                            data[i].controller.text = t;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ]),
                              ],
                            ),

                            //padding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return SafeArea(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      //color: theme_color2,
                      child: Column(children: t),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
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
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'point-plant-label'.i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        //print("--------------------123-----test-----------------");
                        submitFunction();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.save, color: Colors.grey),
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

  // _buildListViewDisease(List<STPvalueAndCon> data) {
  //   List<Widget> widgetShow = [];
  //   List<Widget> widgetCheckBox = [];

  //   for (int i = 0; i < twoDList.length; i++) {
  //     widgetCheckBox = [];
  //     for (int j = 0; j < twoDList[i].length; j++) {
  //       widgetCheckBox.add(buildSingleCheckBox(twoDList[i][j], i));
  //     }

  //     widgetShow.add(Container(
  //       //color: Colors.cyan,
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           side: BorderSide(
  //             color: Colors.transparent,
  //             // width: 2
  //           ),
  //           borderRadius: BorderRadius.circular(9.0), //<-- SEE HERE
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               //color: Colors.blue,
  //               padding: EdgeInsets.only(
  //                   left: MediaQuery.of(context).size.width * 0.05),
  //               width: MediaQuery.of(context).size.width * 0.4,
  //               height: MediaQuery.of(context).size.width * 0.09722222222,
  //               child: Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text("${data[i].stp.surveyTargetName}"),
  //               ),
  //             ),
  //             Container(
  //               //color: Colors.red,
  //               width: MediaQuery.of(context).size.width * 0.42,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: widgetCheckBox,
  //               ),
  //             ),
  //             Container(
  //               width: MediaQuery.of(context).size.width * 0.1,
  //               child: InkWell(
  //                 child: Icon(Icons.add),
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         maintainState: false,
  //                         builder: (context) => Gallery()),
  //                   );
  //                 },
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     ));
  //   }

  //   if (data.isNotEmpty) {
  //     return Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             child: Row(
  //               children: [
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.4,
  //                 ),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.4,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                     children: [
  //                       Text("0"),
  //                       Text("1"),
  //                       Text("2"),
  //                       Text("3"),
  //                       Text("4"),
  //                     ],
  //                   ),
  //                 ),
  //                 Container(
  //                   width: MediaQuery.of(context).size.width * 0.1,
  //                 )
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           ...widgetShow
  //         ],
  //       ),
  //     );
  //   }
  //   return Container();
  // }

  double _initialRating = 1.0;
  bool _isVertical = false;

  _buildListViewDisease(List<STPvalueAndCon> data) {
    List<Widget> widgetShow = [];
    late final _ratingController;
    late double _rating;

    double _userRating = 3.0;
    int _ratingBarMode = 1;

    bool _isRTLMode = false;

    IconData? _selectedIcon;
    int diseaseSLength = twoDList.length;

    for (int i = 0; i < twoDList.length; i++) {
      widgetShow.add(Container(
        //color: Colors.cyan,
        child: Column(
          children: [
            Card(
              color: Colors.white,
              // elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipPath(
                child: Container(
                  // height: 100,
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.greenAccent, width: 5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${data[i].stp.surveyTargetName}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                // fontStyle: FontStyle.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      // SizedBox(width: 10,),
                      // Divider(
                      //   color: Colors.grey[200], //color of divider
                      //   height: 5, //height spacing of divider
                      //   thickness: 1, //thickness of divier line
                      //   indent: 10, //spacing at the start of divider
                      //   endIndent: 80, //spacing at the end of divider
                      // ),
                      SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildRating(i),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 30,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            child: InkWell(
                              child: Icon(
                                Icons.image,
                                size: 35,
                                color: theme_color2,
                              ),
                              onTap: () {
                                //print(data[i].stp.surveyTargetId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      maintainState: false,
                                      //builder: (context) => Gallerys(1, 1,widget.survey)),
                                      builder: (context) => Gallery(data[i]
                                          .stp
                                          .surveyTargetPoints
                                          .surveyTargetPointId)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),
            ),
            SizedBox(
              height: 2,
            ),
          ],
        ),
      ));
    }

    if (data.isNotEmpty) {
      return Container(
        child: Column(
          children: [
            ...widgetShow,
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            ),
          ],
        ),
      );
    }
    return Container();
  }

  int col = 6;
  late List<RatingBar> ratingBars = [];
  late var colors;

  Widget buildRating(int i) {
    //widget.radioValue[i]v
    int x = int.parse(widget.radioValue[i].toString());
    //print(i);
    //print(" ");
    //print(x);
    //print("Rating = ");
    //print(colors[i][x]);
    colors[i][x] = true;
    ratingBars.add((RatingBar.builder(
      initialRating: 6,
      minRating: 1,
      itemSize: 35,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      itemCount: 6,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return Icon(
              IconData(0x1f10c, fontFamily: 'MaterialIcons'),
              color: colors[i][0] ? Colors.green : Colors.grey,
              size: 2,
            );
          case 1:
            return Icon(
              IconData(0x2776, fontFamily: 'MaterialIcons'),
              color: colors[i][1] ? Colors.lightGreen : Colors.grey,
              size: 2,
            );
          case 2:
            return Icon(
              IconData(0x2777, fontFamily: 'MaterialIcons'),
              color: colors[i][2] ? Colors.yellow : Colors.grey,
              size: 2,
            );
          case 3:
            return Icon(
              IconData(0x2778, fontFamily: 'MaterialIcons'),
              color: colors[i][3] ? Colors.amber : Colors.grey,
              size: 2,
            );
          case 4:
            return Icon(
              IconData(0x2779, fontFamily: 'MaterialIcons'),
              color: colors[i][4] ? Colors.orange : Colors.grey,
              size: 2,
            );
          case 5:
            return Icon(
              IconData(0x277a, fontFamily: 'MaterialIcons'),
              color: colors[i][5] ? Colors.red : Colors.grey,
              size: 2,
            );
          default:
            return Container();
        }
      },
      onRatingUpdate: (rating) {
        setState(() {
          rating = rating - 1;
          if (rating == -1) {
            widget.radioValue[i] = "0";
          } else {
            widget.radioValue[i] = rating.toInt().toString();
            for (int j = 0; j < 6; j++) {
              int k = rating.toInt();

              if (j == k) {
                colors[i][j] = true;
              } else {
                colors[i][j] = false;
              }
            }
          }
        });
      },
      updateOnDrag: true,
    )));

    return ratingBars[i];
    //return ratingBars;
    //}
  }

  Widget buildSingleCheckBox(CheckBoxState checkbox, int index) => Checkbox(
        value: checkbox.value,
        visualDensity: const VisualDensity(horizontal: -1.0, vertical: -4.0),
        onChanged: (newBool) {
          setState(() {
            for (int i = 0; i < twoDList[index].length; i++) {
              twoDList[index][i].value = false;
            }
            checkbox.value = newBool!;

            for (int i = 0; i < twoDList[index].length; i++) {
              if (twoDList[index][i].value) {
                stpDisease[index].himidityValue = i.toDouble();
              }
            }
          });
        },
      );

  _buildListViewNaturalAndPest(List<STPvalueAndCon> data) {
    List<Widget> widgetForShow = [];
    List<String> input = [];
    //print("natural and pest : ");
    //print(data.length);
    for (int i = 0; i < data.length; i++) {
      input.add("");
      widgetForShow.add(
        Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline:
                    TextBaseline.alphabetic, // Specify the baseline of the text
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05),
                    width: MediaQuery.of(context).size.width * 0.52,
                    child: Text(
                      "${data[i].stp.surveyTargetName}",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.only(
                    //     right: MediaQuery.of(context).size.width * 0),
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.height / 15,
                    child: AnimTFF(
                      (text) => {
                        setState(() {
                          try {
                            data[i].himidityValue = double.parse(text);
                          } catch (e) {
                            data[i].himidityValue = 0;
                          }
                        }),
                      },
                      labelText: data[i].himidityValue.toString(),
                      successText: "",
                      inputIcon: Icon(Icons.account_circle),
                      isOnlyNumber: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.002)
          ],
        ),
      );
    }
    return isLoading
        ? Container()
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetForShow.isEmpty ? [] : widgetForShow,
            ),
          );
  }

  bool isItemDisabled(String s) {
    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 3 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
