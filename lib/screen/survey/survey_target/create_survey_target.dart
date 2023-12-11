import 'dart:collection';
import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
//import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/subdistrict_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/target_of_survey.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/subdistrict.dart';
import 'package:mun_bot/entities/target_of_survey/disease.dart';
import 'package:mun_bot/entities/target_of_survey/natural_enermy.dart';
import 'package:mun_bot/entities/target_of_survey/pest_phase_survey.dart';
import 'package:mun_bot/entities/target_of_survey/target.dart';

import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/util/size_config.dart';

import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/ui/checkbox.dart';
import 'package:mun_bot/util/ui/input.dart';
import '../../../entities/field.dart';
import '../../../entities/planting.dart';
import '../../../entities/survey.dart';
import '../../../entities/targetofsurvey.dart';
import '../../../entities/userinfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/env.dart';

import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/ui/radio_item.dart';
import 'package:mun_bot/util/shake_widget.dart';

import 'package:localization/src/localization_extension.dart';
//Adding by Chanakan
import 'package:dropdown_search/dropdown_search.dart';

import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class BaseSurveyDetailInfo extends StatefulWidget {
  final Survey surveyFromPassPage;
  final bool isCreate;
  const BaseSurveyDetailInfo(this.surveyFromPassPage, this.isCreate);
  @override
  State<StatefulWidget> createState() => _BaseSurveyDetail();
}

class _BaseSurveyDetail extends State<BaseSurveyDetailInfo>
    with TickerProviderStateMixin {
  String? selectedValue;
  TabController? _tabController;
  int selectedValues = 1;
  int _tabIndex = 0;
  List<Target> listDisease = [];
  List<Target> listNaturalEnermy = [];
  List<Target> listPestPhaseSurvey = [];

  List<int> _checkBoxDiseaseFromFetch = [];
  List<int> _checkBoxNaturalFromFetch = [];
  List<int> _checkBoxPestPhaseFromFetch = [];

  List<int> _checkBoxDiseaseAll = [];
  List<int> _checkBoxNaturalAll = [];
  List<int> _checkBoxPestPhaseAll = [];
  bool checkBoxAllDisease = false;
  bool checkBoxAllNatural = false;
  bool checkBoxAllPestPhase = false;

  bool isPassSurvey = false;
  TextEditingController surveyDateController = TextEditingController();
  int _currentStep = 0;

  final _formKey = GlobalKey<FormState>();

  StepperType stepperType = StepperType.vertical;
  bool _isLoading = true;
  bool _isLoadingPlanting = false;
  @override
  void dispose() {
    super.dispose();
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

  TextEditingController dateinputPlanting = TextEditingController();
  TextEditingController dateinputSurvey = TextEditingController();

  ScrollController? _scrollController;

  _scrollListener() {}
  int length = Random().nextInt(10);
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);
    super.initState();
    asyncFunction();
  }

  asyncFunction() async {
    isPassSurvey = true;
    int survey = widget.surveyFromPassPage.surveyID;

    PlantingService plantingService = PlantingService();
    TargetOfSurveyService targetOfSurveyService = TargetOfSurveyService();

    String? token = tokenFromLogin?.token;

    listDisease = await targetOfSurveyService.getAllDisease(token.toString());
    listNaturalEnermy =
        await targetOfSurveyService.getAllNaturalEnermy(token.toString());
    listPestPhaseSurvey =
        await targetOfSurveyService.getAllPestPhaseSurvey(token.toString());

    List<Disease> diseaseFromFetch = await targetOfSurveyService
        .getAllDiseaseBySurveyID(token.toString(), survey);
    List<NaturalEnermy> naturalFromFetch = await targetOfSurveyService
        .getAllNaturalEnermyBySurveyID(token.toString(), survey);
    List<PestPhaseSurvey> pestFromFetch = await targetOfSurveyService
        .getAllPestPhaseSurveyBySurveyID(token.toString(), survey);

    _checkBoxDiseaseFromFetch = [];
    _checkBoxDiseaseAll = [];

    diseaseFromFetch.forEach((e) {
      _checkBoxDiseaseFromFetch.add(e.diseaseId);
      _checkBoxDiseaseAll.add(e.diseaseId);
    });

    _checkBoxNaturalFromFetch = [];
    _checkBoxNaturalAll = [];

    naturalFromFetch.forEach((e) {
      _checkBoxNaturalAll.add(e.naturalEnemyId);
      _checkBoxNaturalFromFetch.add(e.naturalEnemyId);
    });

    _checkBoxPestPhaseAll = [];
    _checkBoxPestPhaseFromFetch = [];

    pestFromFetch.forEach((e) {
      _checkBoxPestPhaseAll.add(e.pestPhaseSurveyId);
      _checkBoxPestPhaseFromFetch.add(e.pestPhaseSurveyId);
    });

    if (mounted) {
      setState(() {
        _isloading = false;
      });
    }
  }

  var _userNameColor = Colors.black;

  bool isVisible = true;

  findSurveyTarget(List db, List cb) {
    var targetsurvey = Map<int, int>();

    var targetsurveyUpdate = Map<int, int>();

    var targetsurveyTemp = Map<int, int>();
    for (int i = 0; i < db.length; i++) {
      targetsurvey[db[i]] = 1;
    }

    for (int i = 0; i < cb.length; i++) {
      if (!targetsurvey.containsKey(cb[i])) {
        targetsurveyUpdate[cb[i]] = 1;
      } else {
        targetsurveyUpdate[cb[i]] = 0;
      }
    }

    targetsurveyUpdate.forEach((k, v) {
      if (v == 1) {
        targetsurvey[k] = 1;
      } else {
        targetsurvey.remove(k);
      }
    });

    for (int i = 0; i < db.length; i++) {
      if (targetsurvey.containsKey(db[i])) {
        targetsurveyTemp[db[i]] = 0;
      } else {
        targetsurveyTemp[db[i]] = 1;
      }
    }

    targetsurveyTemp.forEach((key, value) {
      targetsurvey[key] = value;
    });
    return targetsurvey;
  }

  void submitFunction() async {
    List<Map<String, dynamic>> dataCreate = [];
    List<Map<String, dynamic>> dataDelete = [];

    var diseases =
        findSurveyTarget(_checkBoxDiseaseFromFetch, _checkBoxDiseaseAll);
    var pestPhase =
        findSurveyTarget(_checkBoxPestPhaseFromFetch, _checkBoxPestPhaseAll);
    var natural =
        findSurveyTarget(_checkBoxNaturalFromFetch, _checkBoxNaturalAll);

    diseases.forEach((k, v) => dataCreate.add(
          {
            'checked': v == 1 ? true : false,
            'targetofsurvey': {
              'name': 'string',
              'targetOfSurveyId': k,
            },
          },
        ));
    pestPhase.forEach((k, v) => dataCreate.add(
          {
            'checked': v == 1 ? true : false,
            'targetofsurvey': {
              'name': 'string',
              'targetOfSurveyId': k,
            },
          },
        ));
    natural.forEach((k, v) => dataCreate.add(
          {
            'checked': v == 1 ? true : false,
            'targetofsurvey': {
              'name': 'string',
              'targetOfSurveyId': k,
            },
          },
        ));

    if (widget.surveyFromPassPage != null) {
      int statusCode = 500;
      //int temp = 500;
      TargetOfSurveyService targetOfSurveyService = TargetOfSurveyService();
      String? token = tokenFromLogin?.token;
      if (widget.isCreate) {
        statusCode = await targetOfSurveyService.createTargetBySurveyID(
            widget.surveyFromPassPage.surveyID, token.toString(), dataCreate);
      } else {
        statusCode = await targetOfSurveyService.updateTargetBySurveyID(
            widget.surveyFromPassPage.surveyID, token.toString(), dataCreate);
      }

      if (statusCode == 200) {
        Navigator.pop(context, true);
      }
    }
  }

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
                  width: sizeWidth(50, context),
                  height: sizeHeight(50, context),
                  color: Colors.amber,
                ),
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
                      height: MediaQuery.of(context).size.height + 15,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white38.withOpacity(.3),
                            theme_color2.withOpacity(.7),
                            theme_color3.withOpacity(.8),
                            Colors.white.withOpacity(.8),
                            Colors.white.withOpacity(1),
                          ],
                        ),
                      ),
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
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back_ios,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              width: sizeWidth(25, context)),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "survey-data-2".i18n(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    sizeHeight(20, context),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              const SizedBox(height: 15),
                                              Container(
                                                // height: 80,
                                                // width: MediaQuery.of(context).size.width,
                                                decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            35.0)),
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
                                                            25.0),
                                                  ),
                                                  labelColor: Colors.black,
                                                  unselectedLabelColor:
                                                      Colors.black87,
                                                  labelStyle: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                  tabs: [
                                                    Tab(
                                                      text: 'Disease'.i18n(),
                                                      icon: Icon(Icons.grass),
                                                    ),
                                                    Tab(
                                                      text: 'NaturalEnermies'
                                                          .i18n(),
                                                      icon: Icon(
                                                          Icons.bug_report),
                                                    ),
                                                    Tab(
                                                      text: 'PestPhase'.i18n(),
                                                      icon: Icon(Icons
                                                          .bug_report_outlined),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 15),
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
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                            ),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height / 1.28,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: _diseaseSelectBox(),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: _naturalSelectBox(),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: _pestSelectBox(),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            floatingActionButton: Row(
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
                            onPressed: () => {submitFunction()},
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
                ])),
      ),
    );
  }

  Widget _diseaseSelectBox() {
    List<Widget> listWidgetDisease = [];

    for (int i = 0; i < listDisease.length; i++) {
      listWidgetDisease.add(
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(15),
            //set border radius more than 50% of height and width to make circle
          ),
          child: ClipPath(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.greenAccent, width: 12),
                ),
              ),
              child: SwitchListTile(
                activeColor: Colors.greenAccent,
                title: Text(listDisease[i].name),
                value: _checkBoxDiseaseAll
                    .contains(listDisease[i].targetOfSurveyId),
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      if (value == true) {
                        _checkBoxDiseaseAll
                            .add(listDisease[i].targetOfSurveyId);
                      } else {
                        _checkBoxDiseaseAll
                            .remove(listDisease[i].targetOfSurveyId);
                      }
                    });
                  }
                },
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
      );
    }
    List<Widget> loadTestData = [
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 380,
          ),
          Container(
            child: Text(
              "เลือกทั้งหมด",
              style: TextStyle(
                  color: _userNameColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'OpenSans',
                  fontSize: 18),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width - 212,
          // ),
          Switch(
            activeColor: Colors.greenAccent,
            value: checkBoxAllDisease,
            // visualDensity:
            //     const VisualDensity(horizontal: -4.0, vertical: -4.0),
            onChanged: (newBool) {
              setState(() {
                checkBoxAllDisease = newBool;

                if (newBool == true) {
                  _checkBoxDiseaseAll = [];
                  for (int i = 0; i < listDisease.length; i++) {
                    _checkBoxDiseaseAll.add(listDisease[i].targetOfSurveyId);
                  }
                } else {
                  _checkBoxDiseaseAll = [];
                }
              });
            },
          )
        ],
      ),
      Container(
        child: Column(children: listWidgetDisease),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 9.5,
      ),
    ];
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: loadTestData.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: loadTestData[index],
              );
            }));
  }

  Widget _naturalSelectBox() {
    List<Widget> listWidgetNatural = [];
    for (int i = 0; i < listNaturalEnermy.length; i++) {
      listWidgetNatural.add(
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(15),
            //set border radius more than 50% of height and width to make circle
          ),
          child: ClipPath(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.greenAccent, width: 12),
                ),
              ),
              child: SwitchListTile(
                activeColor: Colors.greenAccent,
                title: Text(listNaturalEnermy[i].name),
                value: _checkBoxNaturalAll
                    .contains(listNaturalEnermy[i].targetOfSurveyId),
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      if (value == true) {
                        _checkBoxNaturalAll
                            .add(listNaturalEnermy[i].targetOfSurveyId);
                      } else {
                        _checkBoxNaturalAll
                            .remove(listNaturalEnermy[i].targetOfSurveyId);
                      }
                    });
                  }
                },
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
      );
    }

    List<Widget> loadTestData = [
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 380,
          ),
          Container(
            child: Text(
              "เลือกทั้งหมด",
              style: TextStyle(
                  color: _userNameColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'OpenSans',
                  fontSize: 18),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width - 212,
          // ),
          Switch(
            activeColor: Colors.greenAccent,
            value: checkBoxAllNatural,
            // visualDensity:
            //     const VisualDensity(horizontal: -4.0, vertical: -4.0),
            onChanged: (newBool) {
              setState(() {
                checkBoxAllNatural = newBool;

                if (newBool == true) {
                  _checkBoxNaturalAll = [];
                  for (int i = 0; i < listNaturalEnermy.length; i++) {
                    _checkBoxNaturalAll
                        .add(listNaturalEnermy[i].targetOfSurveyId);
                  }
                } else {
                  _checkBoxNaturalAll = [];
                }
              });
            },
          )
        ],
      ),
      Container(
        child: Column(
          children: listWidgetNatural,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 9.5,
      ),
    ];
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: loadTestData.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: loadTestData[index],
              );
            }));
  }

  Widget _pestSelectBox() {
    List<Widget> listWidgetPest = [];

    for (int i = 0; i < listPestPhaseSurvey.length; i++) {
      listWidgetPest.add(
        Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(15),
            //set border radius more than 50% of height and width to make circle
          ),
          child: ClipPath(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.greenAccent, width: 12),
                ),
              ),
              child: SwitchListTile(
                activeColor: Colors.greenAccent,
                title: Text(listPestPhaseSurvey[i].name),
                value: _checkBoxPestPhaseAll
                    .contains(listPestPhaseSurvey[i].targetOfSurveyId),
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      if (value == true) {
                        _checkBoxPestPhaseAll
                            .add(listPestPhaseSurvey[i].targetOfSurveyId);
                      } else {
                        _checkBoxPestPhaseAll
                            .remove(listPestPhaseSurvey[i].targetOfSurveyId);
                      }
                    });
                  }
                },
              ),
            ),
            clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
      );
    }

    List<Widget> loadTestData = [
      Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 380,
          ),
          Container(
            child: Text(
              "เลือกทั้งหมด",
              style: TextStyle(
                  color: _userNameColor,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'OpenSans',
                  fontSize: 18),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width - 212,
          // ),
          Switch(
            activeColor: Colors.greenAccent,
            value: checkBoxAllPestPhase,
            // visualDensity:
            //     const VisualDensity(horizontal: -4.0, vertical: -4.0),
            onChanged: (newBool) {
              setState(() {
                checkBoxAllPestPhase = newBool;

                if (newBool == true) {
                  _checkBoxPestPhaseAll = [];
                  for (int i = 0; i < listPestPhaseSurvey.length; i++) {
                    _checkBoxPestPhaseAll
                        .add(listPestPhaseSurvey[i].targetOfSurveyId);
                  }
                } else {
                  _checkBoxPestPhaseAll = [];
                }
                //print(_checkBoxPestPhaseAll);
              });
            },
          )
        ],
      ),
      Container(
        child: Column(
          children: listWidgetPest,
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 9.5,
      ),
    ];
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: loadTestData.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: loadTestData[index],
              );
            }));
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
    //print(s);
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
    _currentStep < 4 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
