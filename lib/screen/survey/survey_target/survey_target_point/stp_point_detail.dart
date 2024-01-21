import 'package:flutter/rendering.dart';
import 'package:localization/src/localization_extension.dart';

import 'package:mun_bot/entities/survey.dart';

import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/targetpoint_provider.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mun_bot/entities/enemy.dart';

import 'package:provider/provider.dart';

import 'package:mun_bot/env.dart';

final _colorBase = Color(0xFF645CAA);
TextEditingController humidityController = TextEditingController();

class BaseSurveySubPointEnemy extends StatefulWidget {
  Survey survey;

  int surveyPoint;

  BaseSurveySubPointEnemy(this.survey, this.surveyPoint);
  @override
  State<StatefulWidget> createState() => _BaseSurveySubPointEnemy();
}

class _BaseSurveySubPointEnemy extends State<BaseSurveySubPointEnemy> {
  String? status;

  int _selectedView = 1;

  void clearParameter() {
    Provider.of<TabPassModel>(context, listen: false).passParameter("");
  }

  @override
  initState() {
    super.initState();
    clearParameter();
  }

  bool isSelected = false;

  bool isLoading = false;

  final List<Color> _colorList = [theme_color4.withOpacity(0.7)];

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
              width: AppBar().preferredSize.height + sizeWidth(20, context),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back,
                      size: sizeWidth(20, context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'point-detail-label'.i18n() +
                      " " +
                      'point'.i18n() +
                      " : ${widget.surveyPoint + 1}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(20, context),
                  ),
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

  Widget allSurveySubPointExpansionTile(targetPointProvider) {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: sizeHeight(3, context))),
          for (int i = 0; i < 4; i++)
            surveySubPointExpansionTile(i, targetPointProvider),
        ],
      ),
    );
  }

  List<Widget> surveyTileList(int point, targetPointProvider) {
    List<Widget> surveyList = [];

    for (int i = 0; i < 5; i++) {
      surveyList.add(surveyListTile(point, i, targetPointProvider));
    }
    return surveyList;
  }

  bool expansion = false;
  Widget surveySubPointExpansionTile(int spotIndex, targetPointProvider) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeHeight(10, context)),
        ),
        elevation: 5,
        child: Container(
          width: SizeConfig.screenWidth! * 0.95,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(sizeHeight(16, context)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: sizeHeight(20, context),
                      backgroundColor:
                          HotelAppTheme.buildLightTheme().primaryColor,
                      child: Icon(
                        Icons.grass_sharp,
                        size: sizeHeight(25, context),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    Text(
                      (targetPointProvider.isSpotComplete(spotIndex)
                          ? "not-found-point-plant-label".i18n()
                          : "found-point-plant-label".i18n()),
                      style: TextStyle(
                          fontSize: sizeHeight(18, context),
                          color: targetPointProvider.isPointComplete(spotIndex)
                              ? Colors.grey[400]
                              : Colors.black),
                    ),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    ToggleButtons(
                        children: [
                          Icon(
                            Icons.delete,
                            size: sizeHeight(25, context),
                          ),

                          //  Icon(Icons.task_alt_outlined),
                        ],
                        isSelected: targetPointProvider.spots[spotIndex],
                        borderRadius: BorderRadius.all(
                            Radius.circular(sizeWidth(8, context))),
                        borderColor: Colors.red,
                        selectedBorderColor: Colors.white,
                        selectedColor: Colors.grey[300],
                        fillColor: Colors.white,
                        color: Colors.red,
                        onPressed: (int index) => _spotAlert(
                            context,
                            targetPointProvider,
                            widget.surveyPoint,
                            spotIndex,
                            index))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: sizeHeight(16, context)),
                child: Container(
                  width: SizeConfig.screenWidth! * 0.9,
                  height: sizeHeight(1, context),
                  color: Colors.grey.shade300,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: sizeHeight(8, context)),
                child: ExpansionTile(
                    title: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "tree".i18n() +
                            " ${spotIndex * 5 + 1}-" +
                            (spotIndex * 5 + 5).toString(),
                        style: TextStyle(
                            fontSize: sizeHeight(22, context),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    children: surveyTileList(spotIndex, targetPointProvider)),
              ),
            ],
          ),
        ));
  }

  _pointAlert(BuildContext context, targetPointProvider, int surveyPoint,
          int spotIndex, int pointIndex, index) =>
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'confirm-delete'.i18n(),
          ),
          content: Column(
            children: [
              Text(
                'survey-point-delete'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'no'.i18n(),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                setState(() {
                  if (!targetPointProvider
                      .isPointComplete(spotIndex * 5 + pointIndex)) {
                    targetPointProvider.deletePointAt(
                        widget.surveyPoint, spotIndex, pointIndex, index);
                  }
                });
                Navigator.of(context).pop(true);
              },
              child: Text(
                'yes'.i18n(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );

  _spotAlert(BuildContext context, targetPointProvider, int surveyPoint,
          int spotIndex, int index) =>
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'confirm-delete'.i18n(),
          ),
          content: Column(
            children: [
              Text(
                'survey-point-delete-all'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'no'.i18n(),
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                setState(() {
                  if (!targetPointProvider.isSpotComplete(spotIndex)) {
                    targetPointProvider.deleteSpotAt(
                        widget.surveyPoint, spotIndex, index);
                  }
                });

                Navigator.of(context).pop(true);
              },
              child: Text(
                'yes'.i18n(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      );

  Widget surveyListTile(
      int spotIndex, int pointIndex, TargetPointProvider targetPointProvider) {
    return GestureDetector(
        onTap: () {
          // print("${spotIndex}  +  ${pointIndex} ${targetPointProvider.getPointAt(spotIndex, pointIndex).}");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BaseSurveyScreenEnemy(
                      widget.surveyPoint,
                      spotIndex * 5 + pointIndex,
                      widget.survey.surveyID,
                      targetPointProvider.diseaseSize,
                      targetPointProvider.enemySize,
                      targetPointProvider.pestSize))).then((value) {
            if (value == true) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BaseSurveySubPointEnemy(
                          widget.survey, widget.surveyPoint)));
            }
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
          ),
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.all(sizeWidth(10, context)),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: sizeHeight(16, context)),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.grass_rounded,
                            size: sizeHeight(25, context),
                            color: HotelAppTheme.buildLightTheme().primaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenHeight! * 0.01,
                            ),
                            child: Text(
                                "tree".i18n() +
                                    " ${spotIndex * 5 + pointIndex + 1}",
                                style: TextStyle(
                                    fontSize: sizeHeight(20, context))),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenHeight! * 0.01,
                            ),
                            child: Text(
                                (targetPointProvider.isPointComplete(
                                        spotIndex * 5 + pointIndex)
                                    ? "not-found-point-plant-label".i18n()
                                    : "found-point-plant-label".i18n()),
                                style: TextStyle(
                                    fontSize: sizeHeight(16, context),
                                    color: targetPointProvider.isPointComplete(
                                            spotIndex * 5 + pointIndex)
                                        ? Colors.grey[400]
                                        : Colors.black)),
                          )
                        ],
                      ),
                      Spacer(),
                      Container(
                          child: ToggleButtons(
                              children: [
                            Icon(
                              Icons.delete,
                              size: sizeWidth(20, context),
                            ),

                            //  Icon(Icons.task_alt_outlined),
                          ],
                              isSelected: targetPointProvider
                                  .surveyPointData
                                  .targetPoints[spotIndex * 5 + pointIndex]
                                  .points,
                              //isSelected: targetPointProvider.spots[spotIndex] ,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(sizeWidth(8, context))),
                              borderColor: Colors.red,
                              selectedBorderColor: Colors.white,
                              selectedColor: Colors.grey[300],
                              fillColor: Colors.white,
                              color: Colors.red,
                              onPressed: (int index) => _pointAlert(
                                  context,
                                  targetPointProvider,
                                  widget.surveyPoint,
                                  spotIndex,
                                  pointIndex,
                                  index))),
                      Container(height: sizeHeight(20, context)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: sizeHeight(16, context)),
                  child: Container(
                    width: SizeConfig.screenWidth! * 0.9,
                    height: sizeHeight(1, context),
                    color: Colors.grey.shade300,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(60, context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenHeight! * 0.01,
                        ),
                        child: Container(
                            height: sizeHeight(40, context),
                            width: sizeWidth(40, context),
                            child: new GestureDetector(
                              onTap: () {},
                              child: new Stack(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 1.55,
                                    child: IconButton(
                                      icon: ImageIcon(
                                        AssetImage(
                                            "assets/images/noun-cassava.png"),
                                        color: Colors.pink,
                                        size: sizeWidth(25, context),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                          width: sizeWidth(65, context),
                          child: Row(
                            children: [
                              Text(
                                  targetPointProvider
                                      .surveyPointData
                                      .targetPoints[spotIndex * 5 + pointIndex]
                                      .diseases
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: sizeWidth(12, context))),
                              Text(
                                "/${targetPointProvider.diseaseSize}",
                                style:
                                    TextStyle(fontSize: sizeWidth(12, context)),
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenHeight! * 0.01,
                        ),
                        child: Container(
                            height: sizeHeight(40, context),
                            width: sizeWidth(40, context),
                            child: new GestureDetector(
                              onTap: () {},
                              child: new Stack(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 1.65,
                                    child: IconButton(
                                      icon: ImageIcon(
                                        AssetImage(
                                            "assets/images/noun-bettle.png"),
                                        color: Colors.amber,
                                        size: sizeWidth(25, context),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                          width: sizeWidth(65, context),
                          child: Row(
                            children: [
                              Text(
                                  targetPointProvider
                                      .surveyPointData
                                      .targetPoints[spotIndex * 5 + pointIndex]
                                      .enemies
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: sizeWidth(12, context))),
                              Text("/${targetPointProvider.enemySize}",
                                  style: TextStyle(
                                      fontSize: sizeWidth(12, context))),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenHeight! * 0.01,
                        ),
                        child: Container(
                            height: sizeHeight(40, context),
                            width: sizeWidth(40, context),
                            child: new GestureDetector(
                              onTap: () {},
                              child: new Stack(
                                children: <Widget>[
                                  Transform.scale(
                                    scale: 1.55,
                                    child: IconButton(
                                      icon: ImageIcon(
                                        AssetImage(
                                            "assets/images/noun-insect.png"),
                                        color: Colors.blueAccent,
                                        size: sizeWidth(25, context),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      SizedBox(
                          width: sizeWidth(65, context),
                          child: Row(
                            children: [
                              Text(
                                targetPointProvider
                                    .surveyPointData
                                    .targetPoints[spotIndex * 5 + pointIndex]
                                    .pests
                                    .toString(),
                                style:
                                    TextStyle(fontSize: sizeWidth(12, context)),
                              ),
                              Text(
                                "/${targetPointProvider.pestSize}",
                                style:
                                    TextStyle(fontSize: sizeWidth(12, context)),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                        left: SizeConfig.screenHeight! * 0.025,
                      ),
                      child: Icon(
                        Icons.image,
                        size: sizeWidth(25, context),
                        color: HotelAppTheme.buildLightTheme().primaryColor,
                      ),
                    ),
                    Text(
                        " : ${targetPointProvider.surveyPointData.targetPoints[spotIndex * 5 + pointIndex].amountOfImage}  รูป",
                        style: TextStyle(fontSize: sizeHeight(18, context))),
                    SizedBox(
                      width: sizeWidth(20, context),
                    ),
                    GestureDetector(
                        child: CircleAvatar(
                      radius: sizeHeight(15, context),
                      backgroundColor:
                          HotelAppTheme.buildLightTheme().primaryColor,
                      child: Icon(
                        Icons.navigate_next,
                        size: sizeHeight(25, context),
                        color: Colors.white,
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.085),
            child: getAppBarUI(),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(1),
                  theme_color3.withOpacity(.4),
                  theme_color4.withOpacity(1),
                ],
              ),
            ),
            height: SizeConfig.screenHeight! * 2.0,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) {
                    return TargetPointProvider();
                  },
                ),
              ],
              child: Consumer<TargetPointProvider>(
                  builder: (context, targetPointProvider, index) {
                if (!isInit) {
                  targetPointProvider.fetchData(
                      widget.survey.surveyID, widget.surveyPoint);
                  isInit = true;
                }

                return Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      allSurveySubPointExpansionTile(targetPointProvider)
                    ],
                  ),
                );
              }),
            ),
          )),
    );
  }
}
