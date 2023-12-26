import 'dart:async';

import 'package:flutter/material.dart';

import 'package:localization/src/localization_extension.dart';

import 'package:mun_bot/entities/stp_value.dart';

import 'package:mun_bot/env.dart';

import 'package:mun_bot/providers/survey_targetpoint_provider.dart';

import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant_gallery.dart';

import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_detail.dart';

import 'package:mun_bot/util/size_config.dart';

import 'package:mun_bot/util/ui/checkbox.dart';

import 'package:mun_bot/util/ui/input.dart';

import 'dart:math';

import 'package:flutter/cupertino.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:provider/provider.dart';



class BaseSurveyScreenEnemy extends StatefulWidget {
  int surveyID;
  late int point;
  late int number;
  int diseaseSize ;
  int enemySize ;
  int pestSize  ;

  List<String> radioValue = [];
  BaseSurveyScreenEnemy(this.point, this.number, this.surveyID,this.diseaseSize,this.enemySize,this.pestSize);
  @override
  State<StatefulWidget> createState() => _BaseSurveyScreenEnemy();
}

class _BaseSurveyScreenEnemy extends State<BaseSurveyScreenEnemy>
    with TickerProviderStateMixin {
  String? selectedValue;
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  int usedController = 0;


  ScrollController? _scrollController;

  double _opacity = 0.0;

  BaseSurveySubPointEnemy? baseSurveySubPointEnemy;
  _scrollListener() {}
  int length = Random().nextInt(10);
  bool isLoading = true;

  List<List<CheckBoxState>> twoDList = [];

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

    _scrollController = ScrollController();
    _scrollController!.addListener(_scrollListener);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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


  int selectedValues = 1;
  int _tabIndex = 0;

  bool isInit = true;

  void _initRadioRating(){
    for (int i = 0; i < widget.diseaseSize; i++) {
      twoDList.add([
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState(),
        CheckBoxState()
      ]);
      // widget.radioValue.add("0");
    }

    colors = List.generate(widget.diseaseSize,
            (i) => List.generate(6 + 1, (j) => false, growable: false),
        growable: false);
  }

  TabController? _tabController;
  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: DefaultTabController(
        length: 3,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) {
              return SurveyTargetPointProvider();
            }),
          ],
          child: Consumer<SurveyTargetPointProvider>(
              builder:(context, surveyTargetPointProvider, index){

                if(isInit) {
                  isInit = !isInit ;
                  _initRadioRating();
                  surveyTargetPointProvider.fetchData(widget.surveyID, widget.point,widget.number);

                }
                return Scaffold(

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
                                                                  .pop(true);
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

                                    Container(
                                      child:ClipRRect(
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
                                                                    child:/* !isLoading
                                                                      ?*/ _buildListViewDisease(
                                                                        surveyTargetPointProvider)
                                                                  /* : SizedBox(
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
                                                                  ),*/
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
                                                                    child: /*!isLoading
                                                                      ? */_buildListViewNaturalAndPest(
                                                                        surveyTargetPointProvider,false)
                                                                  /* : SizedBox(
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
                                                                  ),*/
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
                                                                    child: /*!isLoading
                                                                      ?*/ _buildListViewNaturalAndPest(
                                                                        surveyTargetPointProvider,true)
                                                                  /*  : SizedBox(
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
                                                                  ),*/
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                              onPressed: () {
                               surveyTargetPointProvider.upDatesurveyTargetPoints(widget.point,widget.number).then((isCompleted) {
                                 if(isCompleted){
                                   if (mounted) {
                                     Navigator.of(context,
                                         rootNavigator: false)
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

                );
             },

          ),
        ),
      ),
    );
  }

  bool _isVertical = false;

  _buildListViewDisease(SurveyTargetPointProvider surveyTargetPointProvider) {
    List<Widget> widgetShow = [];

    for (int i = 0; i < surveyTargetPointProvider.diseases.length; i++) {
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
                            "${surveyTargetPointProvider.diseases[i].stp.surveyTargetName}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                // fontStyle: FontStyle.normal,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildRating(i,surveyTargetPointProvider),
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
                                      builder: (context) => Gallery(surveyTargetPointProvider.diseases[i].stp.surveyTargetPoint.surveyTargetPointId)),
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

    if (surveyTargetPointProvider.diseases.isNotEmpty) {
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

  Widget buildRating(int i,SurveyTargetPointProvider targetPointProvider) {
    //widget.radioValue[i]v
    int x = int.parse(targetPointProvider.diseases[i].stp.surveyTargetPoint.value.toInt().toString());

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
            targetPointProvider.upDateDisease(i, -1);

          } else {
            targetPointProvider.upDateDisease(i, rating.toInt());

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

  }

  _buildListViewNaturalAndPest(SurveyTargetPointProvider surveyTargetPointProvider,bool isPest) {
    List<Widget> widgetForShow = [];
    List<String> input = [];
    List  surverTargetpoints = isPest ? surveyTargetPointProvider.pest : surveyTargetPointProvider.naturalEmemy ;

    for (int i = 0; i < surverTargetpoints.length; i++) {
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
                      "${surverTargetpoints[i].stp.surveyTargetName}",
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
                            surveyTargetPointProvider.upDatesurveyTargetPointAt(i, double.parse(text).toInt(), isPest) ;

                          } catch (e) {
                            print(e);
                            surveyTargetPointProvider.upDatesurveyTargetPointAt(i, 0, isPest) ;
                          }
                        }),
                      },
                      labelText: surverTargetpoints[i].stp.surveyTargetPoint.value.toString(),
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
    return Container(
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
