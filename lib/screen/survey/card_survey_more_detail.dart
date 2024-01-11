import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';

import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/util/change_date_time.dart';

import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_newui.dart';
import 'package:mun_bot/util/size_config.dart';

import 'package:mun_bot/screen/survey/survey_target/create_survey_target.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/screen/survey/create_survey_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import '../../env.dart';

class CardSurveyMoreDetail extends StatefulWidget {
  final Survey survey;
  final String plantingCode;
  SurveyProvider surveyProvider;

  CardSurveyMoreDetail(this.survey, this.plantingCode, this.surveyProvider);

  @override
  _CardSurveyMoreDetailState createState() => _CardSurveyMoreDetailState();
}

class _CardSurveyMoreDetailState extends State<CardSurveyMoreDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String countDis = '0';
  String countNatural = '0';
  String countPest = '0';
  bool? IsCountNull;
  @override
  void initState() {
    super.initState();
    countDiseaseBySurveyId(widget.survey.surveyID);
    countNaturalEnemyBySurveyId(widget.survey.surveyID);
    countPestPhaseSurveyBySurveyId(widget.survey.surveyID);

    _animationController = AnimationController(
      vsync:
          this, // Use 'this' if your widget class mixes in TickerProviderStateMixin
      duration: Duration(seconds: 1), // Animation duration
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Don't forget to dispose the controller
    super.dispose();
  }

  Future<void> checkCountSurveyNull() async {
    log("CountDis : ${countDis}, ${countNatural}, ${countPest}");
    if (countDis.toString() == '0' &&
        countNatural.toString() == '0' &&
        countPest.toString() == '0') {
      setState(() {
        IsCountNull = true;
      });
    } else if (countDis.toString() != '0' ||
        countNatural.toString() != '0' ||
        countPest.toString() != '0') {
      setState(() {
        IsCountNull = false;
      });
    }
  }

  Future<String?> countDiseaseBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPointService surveyTarget = SurveyTargetPointService();
      final countDiseases =
          await surveyTarget.countDiseaseBySurveyId(id, token.toString());
      if (countDiseases != null) {
        //print("infunction");
        setState(() {
          countDis = countDiseases["count"].toString();
          checkCountSurveyNull();
        });
        return countDiseases["count"].toString();
      }
      return "0";
    } catch (e) {
      //print(e);
    }
  }

  Future<String?> countPestPhaseSurveyBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPointService surveyTarget = SurveyTargetPointService();
      final countDiseases =
          await surveyTarget.countPestPhaseSurvey(id, token.toString());
      if (countDiseases != null) {
        //print("infunction");
        setState(() {
          countDis = countDiseases["count"].toString();
          checkCountSurveyNull();
        });
        return countDiseases["count"].toString();
      }
      return "0";
    } catch (e) {
      //print(e);
    }
  }

  Future<String?> countNaturalEnemyBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPointService surveyTarget = SurveyTargetPointService();
      final countNaturalEnemy =
          await surveyTarget.countNaturalEnemy(id, token.toString());
      if (countNaturalEnemy != null) {
        setState(() {
          countNatural = countNaturalEnemy["count"].toString();
          checkCountSurveyNull();
        });
        return countNaturalEnemy["count"].toString();
      }
      //print("countNaturalEnemy");
      //print(countNaturalEnemy);
      return "0";
    } catch (e) {
      //print(e);
    }
  }

  showAlertDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('alert'.i18n()),
          content: Column(
            children: [
              Text(
                'survey-point-create1'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              Text(
                'survey-point-create2'.i18n(),
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
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      maintainState: false,
                      builder: (context) =>
                          new BaseSurveyDetailInfo(widget.survey, false)),
                );
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

  Widget _buildSurveyBtn() {
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
        onPressed: () {
          if (IsCountNull == false) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    BaseSurveyPoint(widget.survey, widget.plantingCode),
              ),
            );
          } else {
            showAlertDialog(context);
          }
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
              "start-survey-target-point-label".i18n(),
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

  Widget CardRow() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the radius value as needed
      ),
      elevation: 8,
      color: theme_color4.withOpacity(0.9),
      child: Container(
        height: sizeHeight(120, context),
        width: sizeWidth(170, context),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              "data1",
              style: GoogleFonts.kanit(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: sizeHeight(25, context),
              ),
            ),
            SizedBox(
              height: sizeHeight(18, context),
            ),
            Expanded(
              child: Text(
                "area-label".i18n(),
                style: GoogleFonts.kanit(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: sizeHeight(16, context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDeletion() async {
    SurveyService surveyervice = SurveyService();
    String? token = tokenFromLogin?.token;
    // //print("widget.surveyProvider.surveys : ${widget.surveyProvider.surveys}");
    //print("widget.survey : ${widget.survey}");
    bool isDeleted = await widget.surveyProvider.deleteSurvey(widget.survey);
    if (isDeleted) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {}
  }

  _deleteConfirmation(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Confirm Deletion"),
          content: Column(
            children: [
              Text(
                'survey-point-delete1'.i18n(),
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
                _handleDeletion();
                Navigator.of(context).pop();
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

  Widget buildFourTextTwoRow(
      String label1,
      String value1,
      String label2,
      String value2,
      String label3,
      String value3,
      String label4,
      String value4,
      IconData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the radius value as needed
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
              child: Icon(
                IconData,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label1,
                    style: TextStyle(
                      fontSize: sizeHeight(16, context),
                      //fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                  Text(
                    value1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeHeight(16, context),
                      // fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(12, context),
                  ),
                  Text(
                    label3,
                    style: TextStyle(
                      fontSize: sizeHeight(16, context),
                      //fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                  Text(
                    value3,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeHeight(16, context),
                      // fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label2,
                    style: TextStyle(
                      fontSize: sizeHeight(16, context),
                      //fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                  Text(
                    value2,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeHeight(16, context),
                      // fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Text(
                    label4,
                    style: TextStyle(
                      fontSize: sizeHeight(16, context),
                      //fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                  Text(
                    value4,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sizeHeight(16, context),
                      // fontWeight: FontWeight.bold,
                      // color: Colors.grey
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: sizeWidth(25, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buidThreeText(String label1, String value1, String label2,
      String value2, String label3, String value3, IconData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the radius value as needed
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
              child: Icon(
                IconData,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        label1,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(170, context),
                        child: ExpandableText(
                          ' : ${value1}',
                          expandText: '${value1}',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label2,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(170, context),
                        child: ExpandableText(
                          ' : ${value2}',
                          expandText: '${value2}',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label3,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(170, context),
                        child: ExpandableText(
                          ' : ${value3}',
                          expandText: '${value3}',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buidThreeText2(String label1, String value1, String label2,
      String value2, String label3, String value3, IconData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the radius value as needed
      ),
      elevation: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
              child: Icon(
                IconData,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        label1,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(110, context),
                        child: ExpandableText(
                          ' : ${value1}',
                          expandText: '${value1}',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label2,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(110, context),
                        child: ExpandableText(
                          ' : ${value2}',
                          expandText: '${value2}',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label3,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(110, context),
                        child: ExpandableText(
                          ' : ${value3}',
                          expandText: '${value3}',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                ],
              ),
            ),
          ],
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
            padding: EdgeInsets.all(sizeWidth(10, context)),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight! * 1.30,
            child: GestureDetector(
              onTap: () {},
              child: AspectRatio(
                aspectRatio: 1.7 / 2,
                child: Container(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: sizeHeight(8, context),
                        ),
                        buildFourTextTwoRow(
                            "code-planting-label".i18n(),
                            widget.plantingCode,
                            "date-survey-label".i18n(),
                            ChangeDateTime(widget.survey.date),
                            "temperature".i18n(),
                            widget.survey.temperature.toString(),
                            "humidity".i18n(),
                            widget.survey.humidity.toString(),
                            Icons.details_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        buidThreeText(
                            "rain-type".i18n(),
                            widget.survey.rainType.toString(),
                            "sunlight-type".i18n(),
                            widget.survey.sunlightType.toString(),
                            "dew-type".i18n(),
                            widget.survey.dewType.toString(),
                            Icons.nature_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        buidThreeText(
                            "beside-plant-label".i18n(),
                            widget.survey.besidePlant.toString() == ""
                                ? "no-specified".i18n()
                                : widget.survey.besidePlant.toString(),
                            "primary-weed-label".i18n(),
                            widget.survey.weed.toString() == ""
                                ? "no-specified".i18n()
                                : widget.survey.weed.toString(),
                            "soil-type".i18n(),
                            widget.survey.soilType.toString() == ""
                                ? "no-specified".i18n()
                                : widget.survey.soilType.toString(),
                            Icons.landscape_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        buidThreeText2(
                            "chemical-damage".i18n(),
                            widget.survey.percentDamageFromHerbicide.toString(),
                            "picture-owner".i18n(),
                            widget.survey.imgOwner.toString() == "0" ||
                                    widget.survey.imgOwner.toString().isEmpty
                                ? "no-specified".i18n()
                                : widget.survey.imgOwner.toString(),
                            "photographer".i18n(),
                            widget.survey.imgPhotographer.toString() == "0" ||
                                    widget.survey.imgPhotographer
                                        .toString()
                                        .isEmpty
                                ? "no-specified".i18n()
                                : widget.survey.imgPhotographer.toString(),
                            Icons.camera_alt_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(top: sizeHeight(8, context))),
                        _buildSurveyBtn()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
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
              Colors.white,
              theme_color3.withOpacity(.4),
              theme_color4.withOpacity(1),
            ],
          ),
        ),
        child: mockShimmer());
  }

  @override
  Widget build(BuildContext context) {
    return widget.plantingCode != ""
        ? Container(
            padding: EdgeInsets.all(sizeWidth(10, context)),
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight! * 1.30,
            child: GestureDetector(
              onTap: () {},
              child: AspectRatio(
                aspectRatio: 1.7 / 2,
                child: Container(
                  child: Container(
                    padding: EdgeInsets.all(sizeWidth(5, context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: sizeHeight(8, context),
                        ),
                        buildFourTextTwoRow(
                            "code-planting-label".i18n(),
                            widget.plantingCode,
                            "date-survey-label".i18n(),
                            ChangeDateTime(widget.survey.date),
                            "temperature".i18n(),
                            widget.survey.temperature.toString(),
                            "humidity".i18n(),
                            widget.survey.humidity.toString(),
                            Icons.details_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        buidThreeText(
                            "rain-type".i18n(),
                            widget.survey.rainType.toString(),
                            "sunlight-type".i18n(),
                            widget.survey.sunlightType.toString(),
                            "dew-type".i18n(),
                            widget.survey.dewType.toString(),
                            Icons.nature_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        buidThreeText(
                            "beside-plant-label".i18n(),
                            widget.survey.besidePlant.toString() == ""
                                ? "no-specified".i18n()
                                : widget.survey.besidePlant.toString(),
                            "primary-weed-label".i18n(),
                            widget.survey.weed.toString() == ""
                                ? "no-specified".i18n()
                                : widget.survey.weed.toString(),
                            "soil-type".i18n(),
                            widget.survey.soilType.toString() == ""
                                ? "no-specified".i18n()
                                : widget.survey.soilType.toString(),
                            Icons.landscape_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        buidThreeText2(
                            "chemical-damage".i18n(),
                            widget.survey.percentDamageFromHerbicide.toString(),
                            "picture-owner".i18n(),
                            widget.survey.imgOwner.toString() == "0" ||
                                    widget.survey.imgOwner.toString().isEmpty
                                ? "no-specified".i18n()
                                : widget.survey.imgOwner.toString(),
                            "photographer".i18n(),
                            widget.survey.imgPhotographer.toString() == "0" ||
                                    widget.survey.imgPhotographer
                                        .toString()
                                        .isEmpty
                                ? "no-specified".i18n()
                                : widget.survey.imgPhotographer.toString(),
                            Icons.camera_alt_sharp),
                        SizedBox(
                          height: sizeHeight(15, context),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(top: sizeHeight(8, context))),
                        _buildSurveyBtn()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : shimmerLoading();
  }
}
