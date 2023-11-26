import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:intl/intl.dart'; //date format
import 'package:mun_bot/util/ui/input.dart';
import 'package:mun_bot/util/ui/radio_item.dart';
import '../../../main.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class EditSurveyTarget extends StatefulWidget {
  final Survey surveyFromPassPage;
  const EditSurveyTarget(this.surveyFromPassPage);
  @override
  State<StatefulWidget> createState() => _EditSurveyTarget();
}

class _EditSurveyTarget extends State<EditSurveyTarget> {
  Field? fieldFromParent;
  Planting? plantingFromParent;
  TextEditingController temperatureController = TextEditingController();
  TextEditingController humidityController = TextEditingController();
  double _tempValue = 30; //---
  double _himidityValue = 30; //----
  int _rainContion = 0; //--
  int _sunContion = 0;
  int _dewContion = 0;

  String rain = "0";
  String dew = "0";
  String sun = "0";
  String plantDisease = "0";
  String pest = "0";
  String naturalEnermy = "0";

  var _userNameColor = Colors.black;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    asyncfunction();
  }

  asyncfunction() async {
    FieldService fieldService = FieldService();
    PlantingService plantingService = PlantingService();

    String? token = tokenFromLogin?.token;
    fieldFromParent = await fieldService.getFieldFromSurveyID(
        widget.surveyFromPassPage.surveyID, token.toString());
    plantingFromParent = await plantingService.getPlantingFromSurveyID(
        widget.surveyFromPassPage.surveyID, token.toString());
    temperatureController.text =
        widget.surveyFromPassPage.temperature.toString();
    humidityController.text = widget.surveyFromPassPage.humidity.toString();
    _rainContion =
        RainType.indexWhere((e) => e == widget.surveyFromPassPage.rainType);
    _sunContion = SunlightType.indexWhere(
        (e) => e == widget.surveyFromPassPage.sunlightType);
    _dewContion =
        DewType.indexWhere((e) => e == widget.surveyFromPassPage.dewType);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.085),
        child: getAppBarUI(),
      ),
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
              children: <Widget>[],
            ),
          ),
        ],
      ),
    );
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
                  'planting-more-detail-label'.i18n(),
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
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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

  Widget _editsurveyPage() {
    List<Widget> loadEnvironmentData = [
      Container(
          child: Column(
        children: [
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'name-field-label'.i18n() + " : ${fieldFromParent?.name}",
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'name-planting-label'.i18n() + " : ${plantingFromParent?.name}",
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                plantingFromParent != null
                    ? 'planting-date-label'.i18n() +
                        " : ${DateFormat("dd-MM-yyyy").format(new DateTime.fromMillisecondsSinceEpoch(plantingFromParent!.createDate))}"
                    : "plantingFromParent Is NULL",
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Text(
                'temperature'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: SizeConfig.screenHeight! * 0.08,
                    width: SizeConfig.screenWidth! * 0.2,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          try {
                            widget.surveyFromPassPage.temperature =
                                double.parse(value);
                          } catch (e) {
                            print(
                                "on surveyFromPassPage.temPerature  can't pass string to Double value: ${value}");
                            print(e);
                          }
                        });
                      },
                      controller: temperatureController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '',
                      ),
                    )),
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.015,
                ),
                Text(
                  "C ํ  ",
                  style: TextStyle(
                      color: _userNameColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 16),
                ),
                Container(
                  width: SizeConfig.screenWidth! * 0.53,
                  child: SliderTheme(
                    data: SliderThemeData(
                        thumbColor: Colors.deepPurple,
                        overlayColor: Colors.black,
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.purple.shade50,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10)),
                    child: Slider(
                      min: 0,
                      max: 100,
                      divisions: 100,
                      value: _tempValue,
                      onChanged: (value) {
                        _tempValue = value;
                        setState(() {
                          String t =
                              ((((_tempValue * 1000).ceil() / 1000) * 100)
                                          .ceil() /
                                      100)
                                  .toString();

                          temperatureController.text = t;

                          try {
                            widget.surveyFromPassPage.temperature =
                                double.parse(temperatureController.text);
                          } catch (e) {
                            print(
                                "temperatureController can't parse to double   temperatureController.text = ${temperatureController.text}");
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'humidity'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: SizeConfig.screenHeight! * 0.08,
                    width: SizeConfig.screenWidth! * 0.2,
                    //width: SizeConfig.screenWidth! * 0.1,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          try {
                            widget.surveyFromPassPage.humidity =
                                double.parse(value);
                          } catch (e) {
                            print(
                                "can't parse to double with surveyFromPassPage!.humidity");
                          }
                        });
                      },
                      controller: humidityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '',
                      ),
                    )),
                SizedBox(
                  width: SizeConfig.screenWidth! * 0.015,
                ),
                Text(
                  "%  ",
                  style: TextStyle(
                      color: _userNameColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 18),
                ),
                Container(
                  width: SizeConfig.screenWidth! * 0.53,
                  child: SliderTheme(
                    data: SliderThemeData(
                        thumbColor: Colors.deepPurple,
                        overlayColor: Colors.black,
                        activeTrackColor: Colors.black,
                        inactiveTrackColor: Colors.purple.shade50,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10)),
                    child: Slider(
                      min: 0,
                      max: 100,
                      divisions: 100,
                      value: _himidityValue,
                      onChanged: (value) {
                        _himidityValue = value;
                        setState(() {
                          String t =
                              ((((_himidityValue * 1000).ceil() / 1000) * 100)
                                          .ceil() /
                                      100)
                                  .toString();
                          humidityController.text = t;

                          try {
                            widget.surveyFromPassPage.humidity =
                                double.parse(humidityController.text);
                          } catch (e) {
                            print(
                                "can't parse string to double with surveyFromPassPage!.humidity");
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'rain-type'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          Container(
              child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.018,
              ),
              MyRadioListTile<int>(
                value: 0,
                groupValue: _rainContion,
                leading: _rainContion == 0 ? '/' : 'x',
                title: Text(RainType[0], style: TextStyle(fontSize: 16)),
                onChanged: (value) {
                  setState(() {
                    _rainContion = value!;
                    rain = _rainContion.toString();

                    widget.surveyFromPassPage.rainType = RainType[value - 1];
                  });
                },
              ),
              MyRadioListTile<int>(
                value: 1,
                groupValue: _rainContion,
                leading: _rainContion == 1 ? '/' : 'x',
                title: Text(RainType[1], style: TextStyle(fontSize: 16)),
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    _rainContion = value!;
                    rain = _rainContion.toString();

                    widget.surveyFromPassPage.rainType = RainType[value - 1];
                  });
                },
              ),
              MyRadioListTile<int>(
                value: 2,
                groupValue: _rainContion,
                leading: _rainContion == 2 ? '/' : 'x',
                title: Text(RainType[2], style: TextStyle(fontSize: 16)),
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    _rainContion = value!;
                    rain = _rainContion.toString();

                    widget.surveyFromPassPage.rainType = RainType[value - 1];
                  });
                },
              ),
              MyRadioListTile<int>(
                value: 3,
                groupValue: _rainContion,
                leading: _rainContion == 3 ? '/' : 'x',
                title: Text(RainType[3], style: TextStyle(fontSize: 16)),
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    _rainContion = value!;
                    rain = _rainContion.toString();

                    widget.surveyFromPassPage.rainType = RainType[value - 1];
                  });
                },
              ),
            ],
          )),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'sunlight-type'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          Container(
              child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.018,
              ),
              MyRadioListTile<int>(
                value: 0,
                groupValue: _sunContion,
                leading: _sunContion == 0 ? '/' : 'x',
                title: Text(SunlightType[0], style: TextStyle(fontSize: 16)),
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    _sunContion = value!;
                    sun = _sunContion.toString();

                    widget.surveyFromPassPage.sunlightType =
                        SunlightType[value - 1];
                  });
                },
              ),
              MyRadioListTile<int>(
                value: 1,
                groupValue: _sunContion,
                leading: _sunContion == 1 ? '/' : 'x',
                title: Text(SunlightType[1], style: TextStyle(fontSize: 16)),
                onChanged: (value) {
                  //print(value);
                  setState(() {
                    _sunContion = value!;
                    sun = _sunContion.toString();

                    widget.surveyFromPassPage.sunlightType =
                        SunlightType[value - 1];
                  });
                },
              ),
            ],
          )),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'dew-type'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          Container(
            child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.015,
                  ),
                  MyRadioListTile<int>(
                    value: 0,
                    groupValue: _dewContion,
                    leading: _dewContion == 0 ? '/' : 'x',
                    title: Text(DewType[0], style: TextStyle(fontSize: 16)),
                    onChanged: (value) {
                      //print(value);
                      setState(() {
                        _dewContion = value!;
                        dew = _dewContion.toString();

                        widget.surveyFromPassPage.dewType = DewType[value - 1];
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 1,
                    groupValue: _dewContion,
                    leading: _dewContion == 1 ? '/' : 'x',
                    title: Text(DewType[1], style: TextStyle(fontSize: 16)),
                    onChanged: (value) {
                      //print(value);
                      setState(() {
                        _dewContion = value!;
                        dew = _dewContion.toString();

                        widget.surveyFromPassPage.dewType = DewType[value - 1];
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 2,
                    groupValue: _dewContion,
                    leading: _dewContion == 2 ? '/' : 'x',
                    title: Text(DewType[2], style: TextStyle(fontSize: 16)),
                    onChanged: (value) {
                      //print(value);
                      setState(() {
                        _dewContion = value!;
                        dew = _dewContion.toString();

                        widget.surveyFromPassPage.dewType = DewType[value - 1];
                      });
                    },
                  ),
                ]),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'beside-plant-label'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          AnimTFF(
            (text) => {
              setState(() {
                widget.surveyFromPassPage.besidePlant = text;
              }),
            },
            // validator1: (value) => InputCodeValidator.validateFieldName(
            //     value, planting.name),
            labelText: widget.surveyFromPassPage == null
                ? 'beside-plant-label'.i18n()
                : widget.surveyFromPassPage.besidePlant,
            successText: "",
            inputIcon: Icon(Icons.person),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'primary-weed-label'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          AnimTFF(
            (text) => {
              setState(() {
                widget.surveyFromPassPage.weed = text;
              }),
            },
            // validator1: (value) => InputCodeValidator.validateFieldName(
            //     value, planting.name),
            labelText: widget.surveyFromPassPage == null
                ? 'primary-weed-label'.i18n()
                : widget.surveyFromPassPage.weed,
            successText: "",
            inputIcon: Icon(Icons.person),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'soil-type'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          AnimTFF(
            (text) => {
              setState(() {
                widget.surveyFromPassPage.soilType = text;
              }),
            },
            // validator1: (value) => InputCodeValidator.validateFieldName(
            //     value, planting.name),
            labelText: widget.surveyFromPassPage == null
                ? 'soil-type'.i18n()
                : widget.surveyFromPassPage.soilType,
            successText: "",
            inputIcon: Icon(Icons.person),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'chemical-damage'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          AnimTFF(
            (text) => {
              setState(() {
                widget.surveyFromPassPage.percentDamageFromHerbicide = text;
              }),
            },
            // validator1: (value) => InputCodeValidator.validateFieldName(
            //     value, planting.name),
            labelText: widget.surveyFromPassPage == null
                ? 'chemical-damage'.i18n()
                : widget.surveyFromPassPage.percentDamageFromHerbicide,
            successText: "",
            inputIcon: Icon(Icons.person),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'picture-owner'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          AnimTFF(
            (text) => {
              setState(() {
                widget.surveyFromPassPage.imgOwner = int.parse(text);
              }),
            },
            // validator1: (value) => InputCodeValidator.validateFieldName(
            //     value, planting.name),
            labelText: widget.surveyFromPassPage == null
                ? 'picture-owner'.i18n()
                : widget.surveyFromPassPage.imgOwner.toString(),
            successText: "",
            inputIcon: Icon(Icons.person),
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          Row(
            children: [
              Text(
                'photographer'.i18n(),
                style: TextStyle(
                    color: _userNameColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'OpenSans',
                    fontSize: 18),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight! * 0.015,
          ),
          AnimTFF(
            (text) => {
              setState(() {
                widget.surveyFromPassPage.imgPhotographer = int.parse(text);
              }),
            },
            // validator1: (value) => InputCodeValidator.validateFieldName(
            //     value, planting.name),
            labelText: widget.surveyFromPassPage == null
                ? 'photographer'.i18n()
                : widget.surveyFromPassPage.imgPhotographer.toString(),
            successText: "",
            inputIcon: Icon(Icons.person),
          ),
          const SizedBox(height: 18),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kLightGrey,
            ),
            child: Column(
              children: [
                Text('note-label'.i18n() +
                    " : \n\t\t\t\t\t\t\t\t\t\tข้อมูลใดไม่ได้สำรวจ ให้ใส่ (-)\n\t\t\t\t\t\t\t\t\t\tการสำรวจ - 5 จุด จุดละ 20 ต้น\n\t\t\t\t\t\t\t\t\t\tการสำรวจโรค - ระดับความรุนแรงของโรค ตั้งแต่ระดับ 0-5\n\t\t\t\t\t\t\t\t\t\tการสำรวจศัตรูพืช - % ความเสียหายของศัตรูพืช\n\t\t\t\t\t\t\t\t\t\tการสำรวจศัตรูธรรมชาติ - % ที่สำรวจพบศัตรูธรรมชาติ"),
              ],
            ),
          ),
          const SizedBox(height: 70),
        ],
      )),
    ];

    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: loadEnvironmentData.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              child: loadEnvironmentData[index],
            );
          },
        ));
  }
}
