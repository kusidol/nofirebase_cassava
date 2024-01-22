import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/survey_point_provider.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_detail.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/change_date_time.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:provider/provider.dart';

class BaseSurveyPoint extends StatefulWidget {
  Survey survey;
  final String plantingCode;
  BaseSurveyPoint(this.survey, this.plantingCode);
  @override
  State<StatefulWidget> createState() => _BaseSurveyPoint();
}

enum SurveyPointStutus { edit, complete }

class _BaseSurveyPoint extends State<BaseSurveyPoint> {
  //List<bool> pointStatus = [false, false, false, false, false];
  //bool isLoading = false;
  //List<int> pointNo = [];
  bool surveyStatus = false;
  String? status;

  //List<Map<String, dynamic>> surveyPointList = [];
  ///String? token;
  @override
  void initState() {
    super.initState();
    //token = tokenFromLogin?.token;
    // getAllsurveyStatus();
    //reFreshstatus();
  }

  /*Future<void> asyncFunction() async {
    String? token = tokenFromLogin?.token;
    SurveyTargetPoint surveyTargetPoint = SurveyTargetPoint();

    List<SurveyPoint> stpsPest = [];
    List<SurveyPoint> stpsNatural = [];
    List<SurveyPoint> stpsDisease = [];

    for (int i = 0; i < 5; i++) {
      stpsDisease = await surveyTargetPoint.surveyPointDiseaseBySurveyId(
          token.toString(), widget.survey.surveyID, i);
      for (int j = 0; j <= 19; j++) {
        if (stpsDisease.isNotEmpty) {
          if (stpsDisease[j].value.toDouble() > 0.00) {
            pointStatus[i] = true;
            // break;
          }
        }
      }
      stpsNatural = await surveyTargetPoint.surveyPointNaturalBySurveyId(
          token.toString(), widget.survey.surveyID, i);
      for (int j = 0; j <= 19; j++) {
        if (stpsNatural.isNotEmpty) {
          if (stpsNatural[j].value.toDouble() > 0.00) {
            pointStatus[i] = true;
            // break;
          }
        }
      }
      stpsPest = await surveyTargetPoint.surveyPointPestphaseBySurveyId(
          token.toString(), widget.survey.surveyID, i);
      for (int j = 0; j <= 19; j++) {
        if (stpsPest.isNotEmpty) {
          if (stpsPest[j].value.toDouble() > 0.00) {
            pointStatus[i] = true;
            //break;
          }
        }
      }
      setState(() {
        if (pointStatus[i] == true) {
          status = "Complete";
          putPointStatus(widget.survey.surveyID, i, status!);
        } else {
          status = "Editing";
          putPointStatus(widget.survey.surveyID, i, status!);
        }
      });
    }

    isLoading = true;
    if (mounted) {
      setState(() {});
    }
  }*/

  /*Future<void> getAllsurveyStatus() async {

    var surveyService = SurveyService();
    List<Map<String, dynamic>> surveyPointListAdd =
        await surveyService.getSurveyPoint(token!, widget.survey.surveyID);
    //surveyPointList = surveyPointListAdd;
    setState(() {
      surveyPointListAdd.forEach((item) {

        //print("${item['pointNo']}          ${item['status']}") ;
        int i = item['pointNo'] ;
        pointStatus[i] =
            item['status'] == "Complete" ? true : false;
        int k = pointStatus[i] == true ? 1 : 0 ;
        //_selectedStatus[item['pointNo']][i] = true ;

        for (int j = 0; j < _selectedStatus[i].length; j++) {
          _selectedStatus[i][j] = j  == k;

        }

      });
    });
    isLoading = true;
  }*/

  List<String> diseaseList = [];

  Future<String?> countDiseaseBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPointService surveyTarget = SurveyTargetPointService();
      final countDiseases =
          await surveyTarget.countDiseaseBySurveyId(id, token.toString());
      if (countDiseases != null) {
        List<dynamic> Name = countDiseases["disease"];
        diseaseList = Name.map((e) => e["name"].toString()).toList();
        return countDiseases["count"].toString();
      }

      return "0";
    } catch (e) {
      //print(e);
    }
  }

  List<String> naturalEnemyList = [];
  Future<String?> countNaturalEnemyBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPointService surveyTarget = SurveyTargetPointService();
      final countNaturalEnemy =
          await surveyTarget.countNaturalEnemy(id, token.toString());
      if (countNaturalEnemy != null) {
        List<dynamic> naturalName = countNaturalEnemy["naturalEnemy"];
        naturalEnemyList =
            naturalName.map((e) => e["name"].toString()).toList();
        return countNaturalEnemy["count"].toString();
      }

      return "0";
    } catch (e) {
      //print(e);
    }
  }

  List<String> pestPhaseList = [];
  Future<String?> countPestPhaseSurveyBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPointService surveyTarget = SurveyTargetPointService();
      final countPestPhaseSurvey =
          await surveyTarget.countPestPhaseSurvey(id, token.toString());
      if (countPestPhaseSurvey != null) {
        List<dynamic> Name = countPestPhaseSurvey["pestphasesurvey"];
        pestPhaseList = Name.map((e) => e["name"].toString()).toList();
        return countPestPhaseSurvey["count"].toString();
      }

      return "0";
    } catch (e) {
      //print(e);
    }
  }

  Future<bool> putPointStatus(
      int surveyId, int pointNumber, String status) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyService surveyPoint = SurveyService();
      final code = await surveyPoint.postSurveyPointStatus(
          surveyId, pointNumber, status, token);

      if (code == 200) {
        // The update was successful, handle the response if necessary
        return true;
      }
    } catch (e) {}
    return false;
  }

  Future<bool> updateSurveyStatus() async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyService surveyService = SurveyService();
      int statusCode =
          await surveyService.updateSurvey(token.toString(), widget.survey);
      if (statusCode == 200) {
        return true;
        //print('Resource updated successfully.');
      } else {
        //print('Failed to update resource. Status code: ${statusCode}');
      }
    } catch (e) {
      //print('Error during update: $e');
    }
    return false;
  }

  Widget getAppBarUI() {
    return Container(
      height: sizeHeight(110, context),
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
            top: MediaQuery.of(context).padding.top,
            left: sizeWidth(8, context),
            right: sizeHeight(8, context)),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeWidth(32, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(8, context)),
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
                child: Column(
                  children: [
                    Text(
                      'survey-target-point-label'.i18n(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(22, context),
                      ),
                    ),
                    Text(
                      "(" +
                          widget.plantingCode +
                          ")  " +
                          ChangeDateTime(widget.survey.date),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(18, context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 0,
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
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeWidth(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
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

  Widget allSummaryBox() {
    return Padding(
      padding: EdgeInsets.only(top: sizeHeight(15, context)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<String?>(
                future: countDiseaseBySurveyId(widget.survey.surveyID),
                builder: (context, snapshot) {
                  String countData = '';
                  countData =
                      snapshot.data == null ? '' : snapshot.data.toString();

                  return summaryBox(
                      "Disease".i18n(),
                      Icons.grass,
                      countData,
                      Colors.purple,
                      Colors.purpleAccent,
                      Colors.purpleAccent.shade100,
                      sizeWidth(100, context),
                      diseaseList);
                },
              ),
              FutureBuilder<String?>(
                future: countNaturalEnemyBySurveyId(widget.survey.surveyID),
                builder: (context, snapshot) {
                  String countData = '';

                  countData =
                      snapshot.data == null ? '' : snapshot.data.toString();

                  return summaryBox(
                      "NaturalEnermies".i18n(),
                      Icons.bug_report,
                      countData,
                      Colors.orange,
                      Colors.orangeAccent,
                      Colors.orangeAccent.shade100,
                      sizeWidth(130, context),
                      naturalEnemyList);
                },
              ),
              FutureBuilder<String?>(
                future: countPestPhaseSurveyBySurveyId(widget.survey.surveyID),
                builder: (context, snapshot) {
                  String countData = '';
                  countData =
                      snapshot.data == null ? '' : snapshot.data.toString();

                  return summaryBox(
                      "PestPhase".i18n(),
                      Icons.bug_report_outlined,
                      countData,
                      Colors.blue,
                      Colors.blueAccent,
                      Colors.blueAccent.shade100,
                      sizeHeight(100, context),
                      pestPhaseList);
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: sizeHeight(15, context),
                top: sizeHeight(15, context),
                right: sizeWidth(10, context)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryBox(
      String headerText,
      IconData icon,
      String count,
      Color color1,
      Color color2,
      Color color3,
      double width,
      List<String> list) {
    return GestureDetector(
      onTap: () {
        indexEnemy = int.parse(count);
        if (indexEnemy != 0) {
          setState(() {
            showList = list;
            indexEnemy = int.parse(count);
            if (isShowEnemy == false) {
              showEnemyHeight = 0;
            } else {
              showEnemyHeight = 200;
            }
            isShowEnemy = !isShowEnemy;
          });
        }
      },
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1, color2, color3],
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            width: width,
            height: sizeHeight(80, context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                      size: sizeWidth(25, context),
                    ),
                    Text(
                      "$count",
                      style: TextStyle(
                        fontSize: sizeHeight(28, context),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                Text(
                  "$headerText",
                  style: TextStyle(
                      fontSize: sizeHeight(14, context),
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget surveySwitch() {
    return GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: EdgeInsets.only(left: sizeWidth(20, context)),
            //   child: Text(
            //     "survey-more-detail-label".i18n(),
            //     style: TextStyle(fontSize: sizeHeight(20, context)),
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.only(
                  right: sizeWidth(8, context), left: sizeWidth(8, context)),
              child: AnimatedToggleSwitch<bool>.dual(
                current: widget.survey.status == "Complete" ? true : false,
                first: false,
                second: true,
                dif: sizeWidth(235, context),
                borderColor: Colors.transparent,
                borderWidth: sizeWidth(7, context),
                height: sizeHeight(55, context),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1.5),
                  ),
                ],
                onChanged: (value) async {
                  int index = value ? 1 : 0;

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => LoadingWidget(
                      message: "Submitting",
                    ),
                  );

                  await updateSurveyStatus().then((value) {
                    if (value) {
                      setState(() {
                        widget.survey.status = _statusList[index];
                      });
                    }
                  });

                  await Future.delayed(Duration(milliseconds: 500));

                  Navigator.pop(context);
                },
                colorBuilder: (value) =>
                    value == false ? Colors.red : Colors.green,
                iconBuilder: (value) => value == false
                    ? Icon(
                        Icons.cancel,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                textBuilder: (value) => value == false
                    ? Center(
                        child: Text(
                        'not-confirm-data'.i18n(),
                        style: TextStyle(fontSize: sizeWidth(14, context)),
                      ))
                    : Center(
                        child: Text(
                        'confirm-data'.i18n(),
                        style: TextStyle(fontSize: sizeWidth(14, context)),
                      )),
              ),
            ),
          ],
        ));
  }

  Widget surveyBoxSwitch(int point, Widget switchWidget, bool status) {
    return Padding(
      padding: EdgeInsets.only(bottom: sizeHeight(8, context)),
      child: GestureDetector(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BaseSurveySubPointEnemy(widget.survey, point)))
                .then((value2) {
              if (value2 == true) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BaseSurveyPoint(
                            widget.survey, widget.plantingCode)));
              }
            });
          },
          child: Card(
            shadowColor: Colors.orangeAccent,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sizeHeight(15, context)),
            ),
            child: Container(
              width:
                  sizeWidth(MediaQuery.of(context).size.width * 0.925, context),
              height: SizeConfig.screenWidth! < 450
                  ? sizeHeight(
                      MediaQuery.of(context).size.height * 0.15, context)
                  : sizeHeight(
                      MediaQuery.of(context).size.height * 0.09, context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: sizeWidth(
                                MediaQuery.of(context).size.width * 0.045,
                                context)),
                        child: Text(
                          status == true
                              ? "point".i18n() + " " + (point + 1).toString()
                              : "point".i18n() + " " + (point + 1).toString(),
                          style: TextStyle(fontSize: sizeHeight(19, context)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth! < 450
                                ? sizeWidth(
                                    MediaQuery.of(context).size.width * 0.25,
                                    context)
                                : sizeWidth(
                                    MediaQuery.of(context).size.width * 0.10,
                                    context)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: sizeWidth(32, context),
                            top: sizeHeight(8, context)),
                        child: switchWidget,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(10, context),
                  ),
                  //Divider(indent: 0, thickness: 1,),

                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: sizeWidth(
                                  MediaQuery.of(context).size.width * 0.045,
                                  context)),
                          child: Text(
                            "status".i18n() + ":",
                            style: TextStyle(
                                fontSize: sizeWidth(16, context),
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sizeWidth(
                                MediaQuery.of(context).size.width * 0.025,
                                context)),
                        child: Text(
                          !status
                              ? "adding-data".i18n()
                              : "adding-complete".i18n(),
                          style: TextStyle(fontSize: sizeHeight(16, context)),
                        ),
                      ),
                    ],
                  )

                  // switchWidget
                ],
              ),
            ),
          )),
    );
  }

  /*bool switchValue(point, bool valuep) {
    if (surveyPointList.isNotEmpty) {
      if (surveyPointList[point]['status'] == 'Complete') {
        return valuep = true;
      } else {
        return valuep = false;
      }
    } else {
      return valuep;
    }
  }*/

  double showEnemyHeight = 0;
  bool isShowEnemy = false;
  int indexEnemy = 0;
  List<String> showList = [];
  Widget showEnemy() {
    return Padding(
      padding: EdgeInsets.only(
          bottom: isShowEnemy == false ? sizeHeight(16, context) : 0),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          height: showEnemyHeight,
          width: sizeWidth(343, context),
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color
            borderRadius: BorderRadius.circular(
                sizeWidth(12, context)), // Adjust the radius as needed
          ),
          child: ListView(
            children: [
              for (int i = 0; i < indexEnemy; i++)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Choose the color of the border
                        width: sizeWidth(
                            1, context), // Choose the width of the border
                      ),
                    ),
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          showList[i],
                          style: TextStyle(fontSize: sizeWidth(16, context)),
                        )
                      ],
                    ),
                    onTap: () {
                      // Handle tile tap here
                      // For example, you can navigate to a new screen or perform an action.
                    },
                  ),
                )
            ],
          )),
    );
  }

  //List<String> txtList = ["","","","",""];
  //final List<bool> _selectedStatus = <bool>[true, false];

  final List<String> _statusList = ["Editing", "Complete"];

  List<Widget> getCompleteBox(SurveyPointProvider surveyPointProvider) {
    List<Widget> completeBoxes = [];
    for (int i = 0; i < 5; i++) {
      completeBoxes.add(surveyBoxSwitch(
          i,
          ToggleButtons(
            isSelected: surveyPointProvider.selectedStatus[i],
            children: [
              Icon(
                Icons.edit_outlined,
              ),
              Icon(Icons.task_alt_outlined),
              //  Container(width: (MediaQuery.of(context).size.width - 22)/2.25, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Icon(Icons.edit,size: 16.0,color: Colors.red,),new SizedBox(width: 4.0,), Text('adding-data'.i18n(),style: TextStyle(color: Colors.red),)],)),
              //  Container(width: (MediaQuery.of(context).size.width - 22)/2.25, child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[new Icon(Icons.task_alt_outlined,size: 16.0,color: Colors.green[800],),new SizedBox(width: 4.0,), Text('adding-complete'.i18n(),)],)),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: !surveyPointProvider.pointStatus[i]
                ? Colors.amber[400]
                : Colors.green[400],
            selectedColor: Colors.white,
            fillColor: surveyPointProvider.pointStatus[i]
                ? Colors.green[400]
                : Colors.amber[400],
            color: !surveyPointProvider.pointStatus[i]
                ? Colors.green[400]
                : Colors.amber[400],
            onPressed: (int index) async {
              setState(() {
                // The button that is tapped is set to true, and the others to false.
                for (int j = 0;
                    j < surveyPointProvider.selectedStatus[i].length;
                    j++) {
                  surveyPointProvider.setSelectedStatus(i, j, j == index);
                }
              });

              await surveyPointProvider
                  .updateSelectedStatus(widget.survey.surveyID, i, index)
                  .then((value) {
                if (value) {
                  // isInit = true ;
                  surveyPointProvider.fetchData(widget.survey.surveyID);
                }
              });
              //surveyPointProvider.pointStatus[]
              //pointStatus[i] = !pointStatus[i] ;

              /*showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => LoadingWidget(
                      message: "Submitting",
                    ),
                  );*/

              /*await putPointStatus(widget.survey.surveyID, i, _statusList[index])
                      .then((value) {
                    ////print(value);

                    if (value) {

                      reFreshstatus();
                      pointStatus[i] = !pointStatus[i];

                    }
                  });

                  await Future.delayed(Duration(milliseconds: 500));

                  Navigator.pop(context);*/
            },
            constraints: BoxConstraints(
              minHeight: sizeHeight(40, context),
              minWidth: sizeWidth(80, context),
            ),
          ),
          /*AnimatedToggleSwitch<bool>.dual(
            current: pointStatus[i],
            first: false,
            second: true,
            dif: sizeWidth(70, context),
            borderColor: Colors.transparent,
            borderWidth: sizeWidth(7, context),
            height: sizeHeight(55, context),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 1.5),
              ),
            ],
            onChanged: (value) async {
              int index = value ? 1 : 0;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => LoadingWidget(
                  message: "Submitting",
                ),
              );

              await putPointStatus(widget.survey.surveyID, i, statusList[index])
                  .then((value) {
                ////print(value);

                if (value) {
                  setState(() {
                    reFreshstatus();
                    pointStatus[i] = !pointStatus[i];
                  });
                }
              });

              await Future.delayed(Duration(milliseconds: 500));

              Navigator.pop(context);
            },
            colorBuilder: (value) => value == false ? Colors.red : Colors.green,
            iconBuilder: (value) => value == false
                ? Icon(
                    Icons.cancel,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
            textBuilder: (value) => value == false
                ? Center(child: Text('adding-data'.i18n()))
                : Center(child: Text('adding-complete'.i18n())),
          ),*/
          surveyPointProvider.pointStatus[i]));
    }
    return completeBoxes;
  }

  Widget allSurveyBoxSwitch(surveyPointProvider) {
    return SingleChildScrollView(
        child: Column(children: getCompleteBox(surveyPointProvider)));
  }

  bool isInit = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
        data: HotelAppTheme.buildLightTheme(),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.085),
            child: getAppBarUI(),
          ),
          body: Container(
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) {
                    return SurveyPointProvider();
                  },
                ),
              ],
              child: Consumer<SurveyPointProvider>(
                  builder: (context, surveyProvider, index) {
                if (isInit) {
                  isInit = !isInit;
                  surveyProvider.fetchData(widget.survey.surveyID);
                }

                return Container(
                  child: ListView(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.915,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white,
                                theme_color3.withOpacity(.4),
                                theme_color4.withOpacity(1),
                              ],
                            ),
                          ),
                          child: Column(children: [
                            allSummaryBox(),
                            showEnemy(),
                            surveySwitch(),
                            SizedBox(
                              height: sizeHeight(16, context),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.65,
                              child: Padding(
                                padding: EdgeInsets.all(sizeWidth(8, context)),
                                child: allSurveyBoxSwitch(surveyProvider),
                              ),
                            )
                          ])
                          /*: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),*/
                          )
                    ],
                  ),
                );
              }),
            ),
          ),
        ));
  }
}
