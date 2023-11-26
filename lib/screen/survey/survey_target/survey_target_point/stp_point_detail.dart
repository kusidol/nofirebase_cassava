import 'dart:io';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/rendering.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/controller/tagerpoint_image_service.dart';
import 'package:mun_bot/entities/stp_value.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/surveypoint.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:number_inc_dec/number_inc_dec.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:mun_bot/entities/enemy.dart';

import 'package:image_picker/image_picker.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:provider/provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

final _colorBase = Color(0xFF645CAA);
TextEditingController humidityController = TextEditingController();

class BaseSurveySubPointEnemy extends StatefulWidget {
  Survey survey;
  int surveyPoint;

  BaseSurveySubPointEnemy(this.survey, this.surveyPoint);
  @override
  State<StatefulWidget> createState() => _BaseSurveySubPointEnemy();
  // int? surveyTargetId;
  // void MyCallback(int result) {
  //   surveyTargetId = result;
  // }
}

class _BaseSurveySubPointEnemy extends State<BaseSurveySubPointEnemy> {
  bool isVisible = true;
  double _searchMargin = 55;
  List _loadSurvey = [];
  int _length = Random().nextInt(5);

  String? status;
  List<bool> isCompleteAll = [
    false,
    false,
    false,
    false,
  ];
  List<bool> isComplete = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  int _selectedView = 1;
  List totalList = [];
  List foundList = [];
  List imageList = [];
  void clearParameter() {
    Provider.of<TabPassModel>(context, listen: false).passParameter("");
  }

  @override
  initState() {
    print("${SizeConfig.screenHeight}");
    super.initState();
    clearParameter();
    asyncFunction();
  }

  asyncFunction() async {
    String? token = tokenFromLogin?.token;
    SurveyTargetPoint surveyTargetPoint = SurveyTargetPoint();

    List<SurveyPoint> stpsPest = [];
    List<SurveyPoint> stpsNatural = [];
    List<SurveyPoint> stpsDisease = [];
    print("${widget.survey.surveyID} + "
        " +  ${widget.surveyPoint}");
    stpsDisease = await surveyTargetPoint.surveyPointDiseaseBySurveyId(
        token.toString(), widget.survey.surveyID, widget.surveyPoint);
    stpsNatural = await surveyTargetPoint.surveyPointNaturalBySurveyId(
        token.toString(), widget.survey.surveyID, widget.surveyPoint);
    stpsPest = await surveyTargetPoint.surveyPointPestphaseBySurveyId(
        token.toString(), widget.survey.surveyID, widget.surveyPoint);
    for (int i = 0; i < stpsDisease.length; i++) {
      if (stpsDisease.isNotEmpty) {
        if (stpsDisease[i].value.toDouble() > 0.00) {
          isComplete[stpsDisease[i].itemNumber] = true;
          isCompleteAll[(stpsDisease[i].itemNumber / 5).floor()] = true;
        }
      }
    }
    for (int i = 0; i < stpsNatural.length; i++) {
      if (stpsNatural.isNotEmpty) {
        if (stpsNatural[i].value.toDouble() > 0.00) {
          isComplete[stpsNatural[i].itemNumber] = true;
          isCompleteAll[(stpsNatural[i].itemNumber / 5).floor()] = true;
        }
      }
    }
    for (int i = 0; i < stpsPest.length; i++) {
      if (stpsPest.isNotEmpty) {
        if (stpsPest[i].value.toDouble() > 0.00) {
          isComplete[stpsPest[i].itemNumber] = true;
          isCompleteAll[(stpsPest[i].itemNumber / 5).floor()] = true;
        }
      }
    }

    if (mounted) {
      setState(() {
        findBySurveyIdAndPointNumberAndItemNumberAndApprovedStatus();
      });
    }
  }

  bool isSelected = false;
  double _himidityValue = 100;
  final picker = ImagePicker();
  var _image;
  String _pathImage = "";
  _getImage(ImageSource imageSource) async {
    final _imageFile = await picker.pickImage(
        source: imageSource,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 100);

    if (_imageFile == null) {
      return null;
    }

    setState(
      () {
        _image = _imageFile;
        isSelected = true;

        _pathImage = _image.path;
        GallerySaver.saveImage(_pathImage);
        // print(_pathImage);
      },
    );
  }

  bool isLoading = false;
  Future<void>
      findBySurveyIdAndPointNumberAndItemNumberAndApprovedStatus() async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPoint surveyTarget = SurveyTargetPoint();
      for (var i = 0; i < 20; i++) {
        final SurveyIdAndPointNumber = await surveyTarget
            .findBySurveyIdAndPointNumberAndItemNumberAndApprovedStatus(
                token.toString(),
                widget.survey.surveyID,
                i,
                widget.surveyPoint);

        if (SurveyIdAndPointNumber != null) {
          foundList.add(SurveyIdAndPointNumber['found']);
          totalList.add(SurveyIdAndPointNumber['total']);
          imageList.add(SurveyIdAndPointNumber['amountOfImage']);
        } else {
          foundList.add(0);
          totalList.add(0);
          imageList.add(0);
        }
      }
      setState(() {
        isLoading = true;

        print("${widget.survey.surveyID}+${widget.surveyPoint}");
      });
    } catch (e) {
      print(e);
    }
  }

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
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
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

  Future<String?> countDiseaseBySurveyId(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      SurveyTargetPoint surveyTarget = SurveyTargetPoint();
      final countDiseases =
          await surveyTarget.countDiseaseBySurveyId(id, token.toString());
      if (countDiseases != null) {
        return countDiseases["count"];
      }
      //  print("countDiseases");
      //  print(countDiseases);
      return "0";
    } catch (e) {
      //  print(e);
    }
  }

  Future<int> getCount() async {
    String? countString = await countDiseaseBySurveyId(widget.survey.surveyID);
    int count = int.parse(countString ?? "0");
    return count;
  }

  Widget allSurveySubPointExpansionTile() {
    return Container(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: sizeHeight(3, context))),
          for (int i = 0; i < 4; i++) surveySubPointExpansionTile(i),
        ],
      ),
    );
  }

  List<Widget> surveyTileList(int point) {
    List<Widget> surveyList = [];

    for (int i = 0; i < 5; i++) {
      surveyList.add(surveyListTile(point, i));
    }
    return surveyList;
  }

  bool expansion = false;
  Widget surveySubPointExpansionTile(int numStart) {
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
                      backgroundColor:
                          HotelAppTheme.buildLightTheme().primaryColor,
                      child: Icon(
                        Icons.grass_sharp,
                        size: sizeHeight(25, context),
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    isCompleteAll[numStart] == true
                        ? AnimatedToggleSwitch<bool>.dual(
                            current: isCompleteAll[numStart],
                            first: false,
                            second: true,
                            dif: sizeWidth(50, context),
                            borderColor: Colors.transparent,
                            borderWidth: sizeWidth(7, context),
                            height: sizeHeight(55, context),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                            onChanged: isCompleteAll[numStart] == true
                                ? (value) async {
                                    // print(status);
                                    setState(() {
                                      if (value) {
                                        status = "Complete";
                                      } else {
                                        status = "Editing";

                                        alertAll(context, widget.surveyPoint,
                                            numStart);
                                      }
                                    });
                                  }
                                : null,
                            colorBuilder: (value) => value == false
                                ? Colors.red
                                : HotelAppTheme.buildLightTheme().primaryColor,
                            iconBuilder: (value) => value == false
                                ? Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                  ),
                            textBuilder: (value) => value == false
                                ? Center(child: Text('ไม่พบโรค'.i18n()))
                                : Center(
                                    child:
                                        Text("found-point-plant-label".i18n())),
                          )
                        : Container(
                            height: sizeHeight(20, context),
                          ),
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
                            " ${numStart * 5 + 1}-" +
                            (numStart * 5 + 5).toString(),
                        style: TextStyle(
                            fontSize: sizeHeight(22, context),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    children: surveyTileList(numStart)),
              ),
            ],
          ),
        ));
  }

  Future<void> resetValue(int point, int number) async {
    print("${point} ${number}");
    setState(() {
      foundList[number] = 0;
    });

    String? token = tokenFromLogin?.token;
    SurveyTargetPoint surveyTargetPoint = SurveyTargetPoint();

    List<STPvalueAndCon> stpDisease = [];
    List<STPvalueAndCon> stpNatural = [];
    List<STPvalueAndCon> stpPest = [];

    List<SurveyTargetPointValue> stpsPest = [];
    List<SurveyTargetPointValue> stpsNatural = [];
    List<SurveyTargetPointValue> stpsDisease = [];

    List<int> imgID = [];

    stpsDisease = await surveyTargetPoint.surveyTargetPointDiseaseBySurveyId(
        token.toString(), widget.survey.surveyID, point, number);
    stpsNatural = await surveyTargetPoint.surveyTargetPointNaturalBySurveyId(
        token.toString(), widget.survey.surveyID, point, number);
    stpsPest = await surveyTargetPoint.surveyTargetPointPestphaseBySurveyId(
        token.toString(), widget.survey.surveyID, point, number);

    stpsDisease.forEach((e) {
      stpDisease.add(STPvalueAndCon(e, TextEditingController(),
          e.surveyTargetPoints.value.toDouble(), point));
      imgID.add(e.surveyTargetPoints.surveyTargetPointId);
    });
    stpsNatural.forEach((e) {
      stpNatural.add(STPvalueAndCon(e, TextEditingController(),
          e.surveyTargetPoints.value.toDouble(), point));
    });
    stpsPest.forEach((e) {
      stpPest.add(STPvalueAndCon(e, TextEditingController(),
          e.surveyTargetPoints.value.toDouble(), point));
    });

    print("imgID = ${imgID}");
    ImageTagetpointService imageService = ImageTagetpointService();
    for (int i = 0; i < imgID.length; i++) {
      List<ImageData> images =
          await imageService.fetchImages(token.toString(), imgID[i]);
      images.forEach((e) async {
        int? status = await imageService.deleteImage(
            imgID[i], e.imageId, token.toString());
        if (status == 200) {
          setState(() {
            imageList[number * 5 + point] = "0";
          });
          print("reset img success");
        } else {
          print("reset img fail");
        }
      });
    }

    List<Map<String, dynamic>> updateDisease = [];
    List<Map<String, dynamic>> updateNatural = [];
    List<Map<String, dynamic>> updatePest = [];

    stpDisease.forEach((e) {
      updateDisease.add(
        {
          "surveyTargetId": e.stp.surveyTargetId,
          "targetOfSurveyName": "string",
          "value": 0
        },
      );
    });
    stpNatural.forEach((e) {
      updateNatural.add(
        {
          "surveyTargetId": e.stp.surveyTargetId,
          "targetOfSurveyName": "string",
          "value": 0
        },
      );
    });

    stpPest.forEach((e) {
      updatePest.add(
        {
          "surveyTargetId": e.stp.surveyTargetId,
          "targetOfSurveyName": "string",
          "value": 0
        },
      );
    });

    try {
      int statusCodeDisease =
          await surveyTargetPoint.updateSurveyTargetPointDisease(
        token.toString(),
        point,
        number,
        updateDisease,
      );

      int statusCodeNatural =
          await surveyTargetPoint.updateSurveyTargetPointNatural(
        token.toString(),
        point,
        number,
        updateNatural,
      );

      int statusCodePest =
          await surveyTargetPoint.updateSurveyTargetPointPestPhase(
        token.toString(),
        point,
        number,
        updatePest,
      );

      if (statusCodePest == 200 &&
          statusCodeNatural == 200 &&
          statusCodePest == 200) {
        print("reset success");
      } else {
        print("reset fail");
      }
    } catch (e) {
      // Handle any exceptions that occur during the async operations.
      print("Error occurred: $e");
    }
  }

  void alertAll(BuildContext context, int surveyPoint, int numStart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('ต้องการที่จะกำหนดค่าเป็นไม่พบสิ่งสำรวจทั้งหมด?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('ไม่'),
            ),
            ElevatedButton(
              onPressed: () {
                for (int i = 0; i <= 4; i++) {
                  resetValue(widget.surveyPoint, (numStart * 5) + i);

                  setState(() {
                    imageList[(numStart * 5) + i] = 0;
                    isComplete[(numStart * 5) + i] = false;
                    isCompleteAll[numStart] = false;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('ใช่'),
            ),
          ],
        );
      },
    );
  }

  void alert(BuildContext context, int surveyPoint, int number, int point) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('ต้องการที่จะกำหนดค่าเป็นไม่พบโรค?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isComplete[number * 5 + point] = true;
                  isCompleteAll[number] = true;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('ไม่'),
            ),
            ElevatedButton(
              onPressed: () {
                resetValue(surveyPoint, number * 5 + point);
                setState(() {
                  setState(() {
                    imageList[number * 5 + point] = 0;
                  });

                  status = "Editing";
                  isComplete[number * 5 + point] = false;
                  bool isCompleteAllCheck = false;
                  int countTrue = 0;
                  for (int i = 0; i <= 4; i++) {
                    if (isComplete[number * 5 + i] == true) {
                      isCompleteAllCheck = true;
                      countTrue++;
                    }
                  }

                  if (isCompleteAllCheck) {
                    isCompleteAll[number] = true;
                  } else {
                    isCompleteAll[number] = false;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text('ใช่'),
            ),
          ],
        );
      },
    );
  }

  Widget surveyListTile(int number, int point) {
    return GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) =>
          //             BaseSurveyScreenEnemy(number, point, widget.survey)));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BaseSurveyScreenEnemy(
                      widget.surveyPoint,
                      number * 5 + point,
                      widget.survey))).then((value) {
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
                                "tree".i18n() + " ${number * 5 + point + 1}",
                                style: TextStyle(
                                    fontSize: sizeHeight(22, context))),
                          ),
                        ],
                      ),
                      Spacer(),
                      isComplete[number * 5 + point] == true
                          ? AnimatedToggleSwitch<bool>.dual(
                              current: isComplete[number * 5 + point],
                              first: false,
                              second: true,
                              dif: sizeWidth(50, context),
                              borderColor: Colors.transparent,
                              borderWidth: sizeWidth(7, context),
                              height: sizeHeight(55, context),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              onChanged: isComplete[number * 5 + point] == true
                                  ? (value) async {
                                      if (value) {
                                        status = "Complete";
                                        setState(() {
                                          isComplete[number * 5 + point] = true;
                                          isCompleteAll[number] = true;
                                        });
                                        findBySurveyIdAndPointNumberAndItemNumberAndApprovedStatus();
                                      } else {
                                        alert(context, widget.surveyPoint,
                                            number, point);
                                      }
                                    }
                                  : null,
                              colorBuilder: (value) => value == false
                                  ? Colors.red
                                  : HotelAppTheme.buildLightTheme()
                                      .primaryColor,
                              iconBuilder: (value) => value == false
                                  ? Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                              textBuilder: (value) => value == false
                                  ? Center(child: Text('ไม่พบโรค'.i18n()))
                                  : Center(
                                      child: Text(
                                          'found-point-plant-label'.i18n())),
                            )
                          : Container(
                              height: sizeHeight(20, context),
                            ),
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
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenHeight! * 0.01,
                        ),
                        child: Text(
                            "พบ ${foundList[number * 5 + point]}/${totalList[number]}",
                            style:
                                TextStyle(fontSize: sizeHeight(18, context))),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: SizeConfig.screenHeight! * 0.025,
                            ),
                            child: Icon(
                              Icons.image,
                              color:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                            ),
                          ),
                          Text(" : ${imageList[number * 5 + point]} รูป",
                              style:
                                  TextStyle(fontSize: sizeHeight(18, context))),
                        ],
                      ),
                      SizedBox(
                        width: sizeWidth(16, context),
                      ),
                      GestureDetector(
                          child: CircleAvatar(
                        backgroundColor:
                            HotelAppTheme.buildLightTheme().primaryColor,
                        child: Icon(
                          Icons.navigate_next,
                          size: sizeHeight(40, context),
                          color: Colors.white,
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

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
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                isLoading
                    ? allSurveySubPointExpansionTile()
                    : SizedBox(
                        height: SizeConfig.screenHeight! * 0.7,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      )
              ],
            ),
          )),
    );
  }
}
