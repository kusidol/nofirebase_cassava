import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/providers/planting_dropdown_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/survey/dropdown_for_planting.dart';
import 'package:mun_bot/screen/survey/survey_target/create_survey_target.dart';
import 'package:provider/provider.dart';

import 'package:mun_bot/screen/survey/dropdown_survey.dart';
import 'package:mun_bot/screen/widget/loading.dart';

import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/ui/input.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/ui/radio_item.dart';
import 'package:mun_bot/util/shake_widget.dart';

//Adding by Chanakan
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/model/input_validator.dart';
import 'package:intl/intl.dart';
import '../../main.dart';
import 'dart:developer';

import 'dropdown_resuse.dart';
import '../../util/size_config.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class NewSurveyScreen extends StatefulWidget {
  // final int passFieldID;
  final Survey? surveyFromPassPage;
  SurveyProvider surveyProvider;
  NewSurveyScreen(this.surveyFromPassPage, this.surveyProvider);

  @override
  State<StatefulWidget> createState() => _NewSurveyScreen();
}

final _colorpurple = Color(0xFFA084CA);
final _colorBase = Colors.deepPurple;

class _NewSurveyScreen extends State<NewSurveyScreen> {
  int _currentStep = 0;

  StepperType stepperType = StepperType.horizontal;
  String dateOfSurvey = "";
  String? percentDamageFromHerbicide = "choose-damage".i18n();
  List<String> plantingItem = [];
  bool isSelectfieldID = false;
  // Adding by ChanakanNewSurveyScreen
  String? selectedField = "2";
  int intputFieldId = 0;
  List<Field> listFieldOnUser = [];
  List<Planting> listPlanting = [];
  List<String> fieldItemsForDropdown = [];
  bool _isLoading = true;
  int selectPlanting = -1;
  String selectedfieldName = "name-planting-label".i18n();
  String selectedfieldCode = "id-field-label".i18n();
  String selectedfieldSubdistrict = "sub-district".i18n();
  String selectedfieldOwner = "owner".i18n();
  String? selectBesidePlant = "select-beside-plant".i18n();
  String _selectPlantingDropdrown = "เลือก Field ก่อน";
  String _selectFieldDropDown = "เลือก Field";
  String ownerFieldByPassingValue = "";
  String plantingNameByPassingValue = "";
  String locationByPassingValue = "";
  // String note = "create by Mobile";
  late Survey surveying;
  late int saveFieldId;
  bool _isPassValueFromPage = false;
  int fieldIdFromDropdown = 0;
  var errorText = {"code": null, "name": null, "size": null};

  AutovalidateMode test = AutovalidateMode.disabled;
  //Key FORM
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final _formKeyPage3 = GlobalKey<FormState>();
  final _formKeyPage4 = GlobalKey<FormState>();
  final _formKeyPage5 = GlobalKey<FormState>();

  int pageService = 1;
  // List<String> peopleOfImageExample = ["Name_1", "Name_2", "Name_3"];

  // Variable for edit data with pop
  String tempSurvey = "";

  double _tempValue = 0;
  double _himidityValue = 50;

  String? selectedValue;

  @override
  void initState() {
    asyncFunction();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  asyncFunction() async {
    if (widget.surveyFromPassPage == null) {
      _isPassValueFromPage = false;
      surveying = Survey(
          0,
          0,
          0,
          "",
          "",
          0.0,
          0.0,
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          "",
          5,
          20,
          0,
          "",
          0,
          "",
          "",
          0,
          DateTime.now().millisecondsSinceEpoch,
          0,
          DateTime.now().millisecondsSinceEpoch,
          "Editing",
          "",
          "");
    } else {
      String? token = tokenFromLogin?.token;

      _isPassValueFromPage = true;
      tempSurvey = jsonEncode(widget.surveyFromPassPage!);
      surveying = widget.surveyFromPassPage!;
      PlantingService plantingService = new PlantingService();
      Planting? plantingData = await plantingService.getPlantingFromSurveyID(
          surveying.surveyID, token.toString());

      plantingNameByPassingValue = plantingData?.name ?? "";
      int plantingID = plantingData?.plantingId ?? 0;

      Field? field;
      FieldService fieldService = FieldService();
      field =
          await fieldService.getFieldByPlantingID(plantingID, token.toString());
      if (field != null) {
        int fieldID = field.fieldID;

        String? location =
            await fieldService.getLocationByFielID(fieldID, token.toString());
        if (location != null) {
          locationByPassingValue = location;
        } else {
          locationByPassingValue = "";
        }

        UserService userService = UserService();
        User? user = await userService.getUserBySurveyID(
            surveying.surveyID, token.toString());
        if (user != null) {
          ownerFieldByPassingValue =
              "${user.title} ${user.firstName} ${user.lastName}";
        } else {
          ownerFieldByPassingValue = "UNKNOWN USER";
        }
      }
      percentDamageFromHerbicide =
          surveying.percentDamageFromHerbicide.toString();

      surveyDateController.text = DateFormat("dd-MM-yyyy")
          .format(DateTime.fromMillisecondsSinceEpoch(surveying.date));
      temperatureController.text = surveying.temperature.toString();
      humidityController.text = surveying.humidity.toString();
      // growDistance = _plantPeriodvalue.toString();
      _tempValue = surveying.temperature;
      _himidityValue = surveying.humidity;
      _rainContion = (RainType.indexOf(surveying.rainType) + 1);
      _sunContion = SunlightType.indexOf(surveying.sunlightType) + 1;
      _dewContion = DewType.indexOf(surveying.dewType) + 1;
      _plantDisease =
          SurveyPatternDisease.indexOf(surveying.surveyPatternDisease) + 1;
      _pest = SurveyPatternPest.indexOf(surveying.surveyPatternPest) + 1;
      _naturalEnemy = SurveyPatternNaturalEnemy.indexOf(
              surveying.surveyPatternNaturalEnemy) +
          1;
    }
    FieldService fieldService = new FieldService();
    String? token = tokenFromLogin?.token;
    List<Field> data =
        await fieldService.getFields(token.toString(), pageService, 2);

    List<String> test = [];
    data.forEach((e) {
      test.add(e.fieldID.toString());
    });
    if (mounted) {
      setState(() {
        //fieldName=temp.toList();
        fieldItemsForDropdown = test;
        listFieldOnUser = data;
        _isLoading = false;
      });
    }
  }

  Future<void> fetchNextPage() async {
    // fieldItemsForDropdown.addAll(fieldItemsForDropdown);
    pageService++;
    FieldService fieldService = new FieldService();
    String? token = tokenFromLogin?.token;
    List<Field> data =
        await fieldService.getFields(token.toString(), pageService, 2);
    List<String> test = [];
    data.forEach((e) {
      test.add(e.fieldID.toString());
    });
    setState(() {
      fieldItemsForDropdown.addAll(test);
    });
  }

  //update drown down
  updatePlantingItem(int fieldID, int page, int valuePerPage) async {
    PlantingService plantingService = new PlantingService();
    String? token = tokenFromLogin?.token;
    listPlanting = await plantingService.getPlantingsByFieldID(
        fieldID, page, valuePerPage, token.toString());

    List<String> test = [];
    plantingItem = [];

    listPlanting.forEach((e) {
      test.add(e.plantingId.toString());
    });

    if (mounted) {
      setState(() {
        plantingItem = test;
      });
    }
  }

  createSurvryByPlantingID() async {
    SurveyService surveyService = new SurveyService();
    String? token = tokenFromLogin?.token;
    if (_isPassValueFromPage == false) {
      CustomLoading.dismissLoading();
      CustomLoading.showLoading();

      var toServicePayload = {
        "date": surveying.date,
        "temperature": surveying.temperature,
        "humidity": surveying.humidity,
        "rainType": surveying.rainType,
        "sunlightType": surveying.sunlightType,
        "dewType": surveying.dewType,
        "soilType": surveying.soilType,
        "percentDamageFromHerbicide": surveying.percentDamageFromHerbicide,
        "surveyPatternDisease": "ระดับ 0-5",
        "surveyPatternPest": "เปอร์เซ็นต์",
        "surveyPatternNaturalEnemy": "เปอร์เซ็นต์",
        "note": surveying.note,
        "createDate": DateTime.now().millisecondsSinceEpoch,
        "lastUpdateDate": DateTime.now().millisecondsSinceEpoch,
        "status": surveying.status
      };

      if (surveying.besidePlant != "" || surveying.besidePlant.isNotEmpty) {
        toServicePayload["besidePlant"] = surveying.besidePlant;
      }
      if (surveying.weed != "" || surveying.weed.isNotEmpty) {
        toServicePayload["weed"] = surveying.weed;
      }
      if (surveying.imgOwnerOther != "" || surveying.imgOwnerOther.isNotEmpty) {
        toServicePayload["imgOwnerOther"] = surveying.imgOwnerOther;
      }
      if (surveying.imgPhotographerOther != "" ||
          surveying.imgPhotographerOther.isNotEmpty) {
        toServicePayload["imgPhotographerOther"] =
            surveying.imgPhotographerOther;
      }

      Survey? newSurvey = await surveyService.createSurvey(
          selectPlanting, token.toString(), toServicePayload);
      CustomLoading.dismissLoading();

      if (newSurvey != null) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              maintainState: false,
              builder: (context) => new BaseSurveyDetailInfo(newSurvey, true)),
        );
        widget.surveyProvider.addSurvey(newSurvey);
        widget.surveyProvider.notifyListeners();
        CustomLoading.showSuccess();
      } else {
        CustomLoading.showError(
            context, 'Something went wrong. Please try again later.');
      }
    } else {
      CustomLoading.dismissLoading();
      CustomLoading.showLoading();

      int statusCode =
          await surveyService.updateSurvey(token.toString(), surveying);
      CustomLoading.dismissLoading();
      if (statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
              maintainState: false,
              builder: (context) => new BaseSurveyDetailInfo(surveying, false)),
        );
        CustomLoading.showSuccess();
      } else {
        CustomLoading.showError(
            context, 'Something went wrong. Please try again later.');
      }
    }
  }

  resetValueEditNotFinish() {
    if (_isPassValueFromPage) {
      Map<String, dynamic> copy = jsonDecode(tempSurvey);
      Survey saveSurvey = Survey.fromJson(copy);
      surveying.besidePlant = saveSurvey.besidePlant;
      surveying.createDate = saveSurvey.createDate;
      surveying.date = saveSurvey.date;
      surveying.dewType = saveSurvey.dewType;
      surveying.humidity = saveSurvey.humidity;
      surveying.lastUpdateBy = saveSurvey.lastUpdateBy;
      surveying.lastUpdateDate = saveSurvey.lastUpdateDate;
      surveying.note = saveSurvey.note;
      surveying.percentDamageFromHerbicide =
          saveSurvey.percentDamageFromHerbicide;
      surveying.plantingID = saveSurvey.plantingID;
      surveying.rainType = saveSurvey.rainType;
      surveying.soilType = saveSurvey.soilType;
      surveying.sunlightType = saveSurvey.sunlightType;
      surveying.temperature = saveSurvey.temperature;
      surveying.weed = saveSurvey.weed;
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

  bool isFinal() {
    if (_currentStep == 3) {
      return true;
    }
    return false;
  }

  continued() {
    if (_currentStep < 4) {
      if (_currentStep == 0) {
        if (_formKeyPage1.currentState!.validate()) {
          setState(() => _currentStep += 1);
        } else {
          //print("in valid");
        }
      } else if (_currentStep == 1) {
        if (_formKeyPage2.currentState!.validate()) {
          setState(() => _currentStep += 1);
        } else {
          //print("in valid");
        }
      } else if (_currentStep == 2) {
        if (_formKeyPage3.currentState!.validate()) {
          setState(() => _currentStep += 1);
        } else {
          //print("in valid");
        }
      } else if (_currentStep == 3) {
        if (_formKeyPage4.currentState!.validate()) {
          //print("object");
          createSurvryByPlantingID();
        } else {
          //print("in valid");
        }
      } else {
        setState(() {
          _currentStep += 1;
        });
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    } else {
      resetValueEditNotFinish();
      Navigator.of(context).pop();
    }
  }

  TextEditingController surveyDateController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();
  TextEditingController humidityController = TextEditingController();

  var _userNameColor = Colors.black;
  var _dateTimeText = " Survey Date";
  int _plantPeriodvalue = 0;
  int _plantSelected = 0;
  int _cassavaAge = 0;

  int _rainContion = 0;
  int _sunContion = 0;
  int _dewContion = 0;

// เพิ่มเติม
  int _plantDisease = 0;
  int _pest = 0;
  int _naturalEnemy = 0;
//

  final _shakeKeyDateTextField = GlobalKey<ShakeWidgetState>();

  void _surveyTFToggle(e) {
    setState(() {
      //_rqVisible = !_rqVisible;
      _dateTimeText = "Survey Date";
      _userNameColor = Colors.black;
    });
  }

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  Widget _buildSurveyPoint() {
    String storyImage = 'assets/images/cassava_field.jpg';
    String userImage = 'assets/images/unknown_user.png';
    String userName = 'Aatik Tasneem';

    var ran = Random();

    int length = ran.nextInt(10);

    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: length,
        itemBuilder: (context, index) {
          return Container(
            width: SizeConfig.screenWidth! * 0.275,
            height: SizeConfig.screenHeight! * 0.225,
            child: GestureDetector(
              child: AspectRatio(
                aspectRatio: 1.6 / 2,
                child: Container(
                  margin: EdgeInsets.only(right: sizeWidth(10, context)),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(sizeHeight(15, context)),
                    image: DecorationImage(
                        image: AssetImage(storyImage), fit: BoxFit.cover),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(sizeWidth(10, context)),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(sizeHeight(15, context)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            colors: [
                              Colors.black.withOpacity(.9),
                              Colors.black.withOpacity(.1),
                            ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: sizeWidth(40, context),
                          height: sizeHeight(40, context),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white,
                                  width: sizeWidth(2, context)),
                              image: DecorationImage(
                                  image: AssetImage(userImage),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnviromentFactor() {
    List<Widget> loadEnvironmentData = [
      Text(
        "rain-type".i18n() + " *",
        style: TextStyle(
            color: _userNameColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            fontSize: sizeHeight(20, context)),
      ),
      Container(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FormField<int>(
            validator: (value) =>
                InputCodeValidator.validateMyRadioListTile(value, _rainContion),
            builder: (FormFieldState<int> state) {
              return Column(
                children: [
                  MyRadioListTile<int>(
                    value: 1,
                    groupValue: _rainContion,
                    leading: _rainContion == 1 ? '/' : 'x',
                    title: Text('${RainType[0]}',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      setState(() {
                        _rainContion = value!;
                        surveying.rainType = _rainContion.toString();
                        if (value != null) {
                          state.didChange(value);
                          _rainContion = value;
                          if (_rainContion != 0) {
                            surveying.rainType = RainType[_rainContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 2,
                    groupValue: _rainContion,
                    leading: _rainContion == 2 ? '/' : 'x',
                    title: Text('${RainType[1]}',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      setState(() {
                        _rainContion = value!;
                        surveying.rainType = _rainContion.toString();
                        if (value != null) {
                          state.didChange(value);
                          _rainContion = value;
                          if (_rainContion != 0) {
                            surveying.rainType = RainType[_rainContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 3,
                    groupValue: _rainContion,
                    leading: _rainContion == 3 ? '/' : 'x',
                    title: Text('${RainType[2]}',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(() {
                        _rainContion = value!;
                        surveying.rainType = _rainContion.toString();
                        if (value != null) {
                          state.didChange(value);
                          _rainContion = value;
                          if (_rainContion != 0) {
                            surveying.rainType = RainType[_rainContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 4,
                    groupValue: _rainContion,
                    leading: _rainContion == 4 ? '/' : 'x',
                    title: Text('${RainType[3]}',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(
                        () {
                          _rainContion = value!;
                          surveying.rainType = _rainContion.toString();
                          if (value != null) {
                            state.didChange(value);
                            _rainContion = value;
                            if (_rainContion != 0) {
                              surveying.rainType = RainType[_rainContion - 1];
                            }
                          }
                        },
                      );
                    },
                  ),
                  if (state.hasError && _rainContion == 0)
                    Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              );
            },
          )
        ],
      )),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.025,
      ),
      Text(
        "sunlight-type".i18n() + " *",
        style: TextStyle(
            color: _userNameColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            fontSize: sizeHeight(20, context)),
      ),
      Container(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FormField<int>(
            validator: (value) =>
                InputCodeValidator.validateMyRadioListTile(value, _sunContion),
            builder: (FormFieldState<int> state) {
              return Column(
                children: [
                  MyRadioListTile<int>(
                    value: 1,
                    groupValue: _sunContion,
                    leading: _sunContion == 1 ? '/' : 'x',
                    title: Text('แดดจัด',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(() {
                        _sunContion = value!;
                        surveying.sunlightType = _sunContion.toString();
                        if (value != null) {
                          _sunContion = value;
                          state.didChange(value);
                          if (_sunContion != 0) {
                            surveying.sunlightType =
                                SunlightType[_sunContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 2,
                    groupValue: _sunContion,
                    leading: _sunContion == 2 ? '/' : 'x',
                    title: Text('แดดน้อยฟ้าครึ้ม',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(
                        () {
                          _sunContion = value!;
                          surveying.sunlightType = _sunContion.toString();
                          if (value != null) {
                            state.didChange(value);
                            _sunContion = value;
                            if (_sunContion != 0) {
                              surveying.sunlightType =
                                  SunlightType[_sunContion - 1];
                            }
                          }
                        },
                      );
                    },
                  ),
                  if (state.hasError && _sunContion == 0)
                    Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              );
            },
          )
        ],
      )),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.025,
      ),
      Text(
        "dew-type".i18n() + " *",
        style: TextStyle(
            color: _userNameColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            fontSize: sizeHeight(20, context)),
      ),
      Container(
          child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FormField<int>(
            validator: (value) =>
                InputCodeValidator.validateMyRadioListTile(value, _dewContion),
            builder: (FormFieldState<int> state) {
              return Column(
                children: [
                  MyRadioListTile<int>(
                    value: 1,
                    groupValue: _dewContion,
                    leading: _dewContion == 1 ? '/' : 'x',
                    title: Text('น้ำค้างแรง',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(() {
                        _dewContion = value!;
                        surveying.dewType = _dewContion.toString();
                        if (value != null) {
                          state.didChange(value);
                          _dewContion = value;
                          if (_dewContion != 0) {
                            surveying.dewType = DewType[_dewContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 2,
                    groupValue: _dewContion,
                    leading: _dewContion == 2 ? '/' : 'x',
                    title: Text('น้ำค้างเล็กน้อย',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(() {
                        _dewContion = value!;
                        surveying.dewType = _dewContion.toString();
                        if (value != null) {
                          state.didChange(value);
                          _dewContion = value;
                          if (_dewContion != 0) {
                            surveying.dewType = DewType[_dewContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  MyRadioListTile<int>(
                    value: 3,
                    groupValue: _dewContion,
                    leading: _dewContion == 3 ? '/' : 'x',
                    title: Text('ไม่มีน้ำค้าง',
                        style: TextStyle(fontSize: sizeHeight(20, context))),
                    onChanged: (value) {
                      ////print(value);
                      setState(() {
                        _dewContion = value!;
                        surveying.dewType = _dewContion.toString();
                        if (value != null) {
                          state.didChange(value);
                          _dewContion = value;
                          if (_dewContion != 0) {
                            surveying.dewType = DewType[_dewContion - 1];
                          }
                        }
                      });
                    },
                  ),
                  if (state.hasError && _dewContion == 0)
                    Text(
                      state.errorText!,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              );
            },
          ),
        ],
      ))
    ];

    return Container(
        height: SizeConfig.screenHeight! * 0.6,
        child: Form(
            key: _formKeyPage3,
            autovalidateMode: test,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: loadEnvironmentData.length,
              itemBuilder: (context, index) {
                return Container(
                  child: loadEnvironmentData[index],
                );
              },
            )));
  }

  Widget _buildMultiSearchBar() {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizeHeight(12, context)),
        ),
        child: Column(
          children: [
            MultiSearchView(
              right: sizeWidth(80, context),
              onDeleteAlternative: (value) {},
              onSearchComplete: (value) {},
              onSelectItem: (value) {},
              onItemDeleted: (value) {},
              onSearchCleared: (value) {},
            )
          ],
        ),
      ),
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 0, //spread radius
              blurRadius: 50, // blur radius
              offset: Offset(2, 2))
        ],
      ),
    );
  }

  Text buildtext(String textinput) {
    return Text(
      textinput,
      style: TextStyle(
        fontSize: SizeConfig.screenHeight! * 0.02304469273743016732955432102619,
      ),
    );
  }

  Widget buildTitle(String text1, String text2) {
    return Container(
        child: Row(
      children: [
        Text(
          text1,
          style: TextStyle(
            fontSize:
                SizeConfig.screenHeight! * 0.02304469273743016732955432102619,
          ),
        ),
        Text(
          text2,
          style: TextStyle(
            color: theme_color2,
            fontWeight: FontWeight.bold,
            fontSize:
                SizeConfig.screenHeight! * 0.02304469273743016732955432102619,
          ),
        )
      ],
    ));
  }

  Widget _buildSelectedSurvey(Dropdownplanting dropdownplanting) {
    //if (isSelectfieldID) selectPlanting = listPlanting[0].plantingId;
    List<String> dropdownForShow = dropdownplanting.plantingString;
    dropdownForShow.add("other".i18n());
    return Column(
      children: [
        Form(
          key: _formKeyPage1,
          autovalidateMode: test,
          child: Column(
            children: [
              Container(
                  child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "planting-label".i18n() + " *",
                  style: TextStyle(
                      color: _userNameColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: sizeHeight(20, context)),
                ),
              )),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              Container(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: theme_color4,
                      width: sizeWidth(2, context),
                    ),
                  ),
                  child: _isPassValueFromPage
                      ? Column(
                          children: [
                            Container(
                              child: Text(
                                "selected-planting-label".i18n() +
                                    plantingNameByPassingValue,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: sizeHeight(18, context)),
                              ),
                            ),
                            Container(
                              child: ExpansionTile(
                                subtitle: Text(
                                    selectedfieldOwner +
                                        ", " +
                                        selectedfieldName +
                                        ", " +
                                        selectedfieldSubdistrict,
                                    style: TextStyle(
                                        fontSize: sizeHeight(14, context),
                                        color: Colors.grey.withOpacity(0.8))),
                                title: buildTitle(
                                    "data-cultivation-label".i18n(),
                                    " ${plantingNameByPassingValue}"),
                                children: [
                                  ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Text(
                                        selectedfieldOwner +
                                            " : ${ownerFieldByPassingValue}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: sizeHeight(18, context)),
                                      )),
                                  ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Text(
                                        selectedfieldName +
                                            " : ${plantingNameByPassingValue}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: sizeHeight(18, context)),
                                      )),
                                  ListTile(
                                      visualDensity: VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Text(
                                        selectedfieldSubdistrict +
                                            " :  ${locationByPassingValue}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: sizeHeight(18, context)),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        )
                      : DropdownButtonFormField<String>(
                          validator: (value) =>
                              InputCodeValidator.validateDropdownProvider(
                                  value),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: sizeHeight(20, context),
                            ),
                            hintText: "select-planting-label".i18n(),
                            hintStyle: TextStyle(
                              fontSize: sizeHeight(20, context),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: sizeHeight(10, context),
                              horizontal: sizeWidth(12, context),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          value: selectedValue,
                          onChanged: (value) {
                            if (value == "other".i18n()) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Provider(
                                    create: (context) => dropdownplanting,
                                    builder: (context, child) =>
                                        DropdownForPlanting(
                                      (value) {
                                        bool duplicate = false;
                                        List<String> temp =
                                            dropdownplanting.plantingString;
                                        for (int i = 0; i < temp.length; i++) {
                                          if (value['nameField'] == temp[i]) {
                                            duplicate = true;
                                            break;
                                          }
                                        }
                                        if (!duplicate) {
                                          dropdownplanting
                                              .addItem(value['nameField']);
                                        }
                                        setState(() {
                                          selectedValue = value['nameField'];
                                          selectedField =
                                              value['id'].toString();
                                          selectPlanting = value['id'];
                                          isSelectfieldID = true;
                                          // updatePlantingItem(
                                          //     value['id'], 1, 20);
                                          _selectPlantingDropdrown =
                                              "select-planting-label".i18n() +
                                                  ": " +
                                                  "${selectedValue}";
                                          fieldIdFromDropdown = value['id'];

                                          dropdownplanting
                                              .getPlantingAndUserByfieldId(
                                                  fieldIdFromDropdown);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              int id = 0;
                              for (int i = 0;
                                  i < dropdownplanting.items.length;
                                  i++) {
                                if (dropdownplanting.items[i].name == value) {
                                  id = dropdownplanting.items[i].id;
                                  selectPlanting = id;
                                  break;
                                }
                              }
                              setState(() {
                                selectedValue = value.toString();
                                isSelectfieldID = true;
                                // updatePlantingItem(id, 1, 20);
                                _selectPlantingDropdrown =
                                    "select-planting-label".i18n() +
                                        ": ${selectedValue}";
                                fieldIdFromDropdown = id;
                                selectedField = id.toString();

                                dropdownplanting.getPlantingAndUserByfieldId(
                                    fieldIdFromDropdown);
                              });
                            }
                          },
                          // Hide the default underline
                          // underline: Container(),
                          // set the color of the dropdown menu
                          dropdownColor: Colors.white,
                          icon: Icon(
                            Icons.arrow_downward,
                            color: Colors.black,
                            size: sizeHeight(25, context),
                          ),
                          isExpanded: true,

                          // The list of options
                          items: dropdownForShow
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            'plantings-label'.i18n() + " ",
                                            style: TextStyle(
                                              fontSize: sizeHeight(18, context),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              e,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                              style: TextStyle(
                                                  fontSize:
                                                      sizeHeight(18, context),
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),

                          // Customize the selected item
                          selectedItemBuilder: (BuildContext context) =>
                              dropdownForShow
                                  .map((e) => Positioned(
                                        top: -sizeHeight(5, context),
                                        child: Center(
                                          child: Text(
                                            "select-planting-label".i18n() +
                                                " : ${e}",
                                            style: TextStyle(
                                              fontSize: sizeHeight(18, context),
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                        ),
                ),
              ),
              isSelectfieldID
                  ? Column(
                      children: [
                        Container(
                          child: ExpansionTile(
                            subtitle: Text(
                                selectedfieldOwner +
                                    ", " +
                                    selectedfieldName +
                                    ", " +
                                    selectedfieldSubdistrict,
                                style: TextStyle(
                                    fontSize: sizeHeight(14, context),
                                    color: Colors.grey.withOpacity(0.8))),
                            title: buildTitle("data-cultivation-label".i18n(),
                                " ${dropdownplanting.planting?.name}"),
                            children: [
                              ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    selectedfieldOwner +
                                        " :  ${dropdownplanting.user?.title} ${dropdownplanting.user?.firstName} ${dropdownplanting.user?.lastName}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sizeHeight(18, context)),
                                  )),
                              ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    selectedfieldName +
                                        " : ${dropdownplanting.planting?.name}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sizeHeight(18, context)),
                                  )),
                              ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    selectedfieldSubdistrict +
                                        " : ${dropdownplanting.location}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sizeHeight(18, context)),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              _buildSurveyDate(),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "beside-plant-label".i18n(),
                  style: TextStyle(
                      color: _userNameColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: sizeHeight(20, context)),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              AnimTFF(
                (text) => {
                  setState(() {
                    errorText['code'] = null;
                    surveying.besidePlant = text;
                  }),
                },
                errorText: errorText['code'],
                labelText: surveying.besidePlant == ""
                    ? 'insert-beside-plant'.i18n()
                    : surveying.besidePlant,
                successText: "",
                inputIcon: Icon(Icons.park),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectPlant() {
    List<Widget> loadPlantData = [
      Container(
        child: Text(
          "temperature".i18n() + " *",
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.02,
      ),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: SizeConfig.screenHeight! * 0.1,
                width: SizeConfig.screenWidth! * 0.2,
                child: TextFormField(
                  validator: (value) => InputCodeValidator.validateBoxNumber(
                      value, surveying.temperature.toString()),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value.isNotEmpty) {
                        // Check if the input starts with '-' but has more than just the '-'
                        if (value == '-' || value == '-.') {
                          // Handle the case where only a '-' is entered, or '-.' (not a valid number)
                          // You can display an error message or take other actions as needed.
                        } else {
                          try {
                            double temperatureValue = double.parse(value);
                            surveying.temperature = temperatureValue;
                          } catch (e) {
                            // Handle the parsing error, e.g., display an error message
                            //print("Parsing error: $e");
                          }
                        }
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  controller: temperatureController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '',
                  ),
                )),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.02,
            ),
            Text(
              "C ํ  ",
              style: TextStyle(
                  color: _userNameColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(16, context)),
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.53,
              child: SliderTheme(
                data: SliderThemeData(
                    thumbColor: theme_color4,
                    overlayColor: theme_color2,
                    activeTrackColor: theme_color2,
                    inactiveTrackColor: Colors.greenAccent.shade100,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
                child: Slider(
                  min: -100,
                  max: 100,
                  divisions: 100,
                  value: _tempValue,
                  onChanged: (value) {
                    _tempValue = value;
                    setState(() {
                      String t =
                          ((((_tempValue * 1000).ceil() / 1000) * 100).ceil() /
                                  100)
                              .toString();

                      temperatureController.text = t;
                      surveying.temperature =
                          double.parse(temperatureController.text);
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // SizedBox(
      //   height: SizeConfig.screenHeight! * 0.02,
      // ),
      Container(
        child: Text(
          "humidity".i18n() + " *",
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.025,
      ),
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                height: SizeConfig.screenHeight! * 0.1,
                width: SizeConfig.screenWidth! * 0.2,
                //width: SizeConfig.screenWidth! * 0.1,
                child: TextFormField(
                  validator: (value) => InputCodeValidator.validateNumber(
                      value, surveying.humidity.toString()),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value.isNotEmpty) {
                        // Check if the input starts with '-' but has more than just the '-'
                        if (value == '-' || value == '-.') {
                          // Handle the case where only a '-' is entered, or '-.' (not a valid number)
                          // You can display an error message or take other actions as needed.
                        } else {
                          try {
                            double humidityValue = double.parse(value);
                            surveying.humidity = humidityValue;
                          } catch (e) {
                            // Handle the parsing error, e.g., display an error message
                            //print("Parsing error: $e");
                          }
                        }
                      }
                    });
                  },
                  keyboardType: TextInputType.number,
                  controller: humidityController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '',
                  ),
                )),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.02,
            ),
            Text(
              "%  ",
              style: TextStyle(
                  color: _userNameColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(18, context)),
            ),
            Container(
              width: SizeConfig.screenWidth! * 0.53,
              child: SliderTheme(
                data: SliderThemeData(
                    thumbColor: theme_color4,
                    overlayColor: theme_color2,
                    activeTrackColor: theme_color2,
                    inactiveTrackColor: Colors.greenAccent.shade100,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
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

                      double humidityValue =
                          double.parse(humidityController.text);
                      if (humidityValue != null && humidityValue >= 0) {
                        surveying.humidity = humidityValue;
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      // SizedBox(height: SizeConfig.screenHeight! * 0.02),
      Container(
        child: Text(
          "primary-weed-label".i18n(),
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),

      SizedBox(height: SizeConfig.screenHeight! * 0.02),
      AnimTFF(
          (text) => {
                setState(() {
                  surveying.weed = text;
                }),
              },
          inputIcon: Icon(Icons.grass_rounded),
          labelText:
              surveying.weed == "" ? 'insert-weed'.i18n() : surveying.weed,
          successText: ""),
      // SizedBox(height: SizeConfig.screenHeight! * 0.02),
      // Container(
      //   child: Text(
      //     "วัชพืชหลักที่พบ",
      //     style: TextStyle(
      //         color: _userNameColor,
      //         fontWeight: FontWeight.bold,
      //         fontFamily: 'OpenSans',
      //         fontSize: 20),
      //   ),
      // ),
      // SizedBox(height: SizeConfig.screenHeight! * 0.02),
      // // Container(
      // //   child: TextField(
      // //     onChanged: (value) {
      // //       setState(() {
      // //         soidType = value;
      // //       });
      // //     },
      // //   ),
      // // ),
      // AnimTFF(
      //     (text) => {
      //           setState(() {
      //             // plantNear = text;
      //           }),
      //         },
      //     inputIcon: Icon(Icons.person),
      //     labelText: "Test",
      //     successText: ""),
      SizedBox(height: SizeConfig.screenHeight! * 0.02),
      Container(
        child: Text(
          "soil-type".i18n(),
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      SizedBox(height: SizeConfig.screenHeight! * 0.02),
      AnimTFF(
          (text) => {
                setState(() {
                  // plantNear = text;
                  surveying.soilType = text;
                }),
              },
          inputIcon: Icon(Icons.landscape_rounded),
          labelText: surveying.soilType == ""
              ? 'insert-soil-type'.i18n()
              : surveying.soilType,
          successText: ""),
    ];

    return Container(
        height: SizeConfig.screenHeight! * 0.6,
        child: Form(
          key: _formKeyPage2,
          autovalidateMode: test,
          child: ListView.builder(
              itemCount: loadPlantData.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: loadPlantData[index],
                );
              }),
        ));
  }

  Widget _buildPlantPeriod() {
    List<Widget> loadData = [
      Container(
        child: Text(
          "growth-stage".i18n(),
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      SizedBox(
        height: sizeHeight(20, context),
      ),
      Container(
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            MyRadioListTile<int>(
              value: 1,
              groupValue: _plantPeriodvalue,
              leading: _plantPeriodvalue == 1 ? '/' : 'x',
              title: Text('อายุพืช',
                  style: TextStyle(fontSize: sizeHeight(20, context))),
              onChanged: (value) {
                ////print(value);
                setState(() => _plantPeriodvalue = value!);
              },
            ),
            SizedBox(
              width: SizeConfig.screenWidth! * 0.05,
            ),
            Container(
              height: SizeConfig.screenHeight! * 0.05,
              width: SizeConfig.screenWidth! * 0.2,
              child: _plantPeriodvalue == 1
                  ? TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '',
                      ),
                    )
                  : Container(),
            )
          ],
        ),
      ),
      MyRadioListTile<int>(
        value: 2,
        groupValue: _plantPeriodvalue,
        leading: _plantPeriodvalue == 2 ? '/' : 'x',
        title: Text('ระหว่างเก็บเกี่ยว',
            style: TextStyle(fontSize: sizeHeight(20, context))),
        onChanged: (value) {
          ////print(value);
          setState(() => _plantPeriodvalue = value!);
        },
      ),
      MyRadioListTile<int>(
        value: 3,
        groupValue: _plantPeriodvalue,
        leading: _plantPeriodvalue == 3 ? '/' : 'x',
        title: Text('no-plants-in-field'.i18n(),
            style: TextStyle(fontSize: sizeHeight(20, context))),
        onChanged: (value) {
          ////print(value);
          setState(() => _plantPeriodvalue = value!);
        },
      ),
    ];

    return Container(
        height: SizeConfig.screenHeight! * 0.2,
        child: ListView.builder(
            itemCount: loadData.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: loadData[index],
              );
            }));
  }

  Widget _buildSurveyDate() {
    TextFormField _dateTextField = TextFormField(
      validator: (value) => InputCodeValidator.validateDate(value),
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());

        // date = (await showDatePicker(
        //     context: context,
        //     initialDate: DateTime.now(),
        //     firstDate: DateTime(1900),
        //     lastDate: DateTime(2100)))!;
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));
        if (newDate == null) return;
        setState(() {
          date = newDate;
        });
        surveyDateController.text = date.toIso8601String();

        dateOfSurvey = surveyDateController.text;
        surveying.date = date.millisecondsSinceEpoch;
        surveyDateController.text = DateFormat("dd-MM-yyyy").format(newDate);
      },
      controller: surveyDateController,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: Colors.deepPurple,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: _userNameColor,
        ),
        hintText: 'Pick Survey Date',
        hintStyle: kHintTextStyle,
      ),
    );

    return Container(
      child: ShakeWidget(
        key: _shakeKeyDateTextField,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "date-survey-label".i18n() + " *",
              style: TextStyle(
                  color: _userNameColor,
                  fontWeight: FontWeight.bold,
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: sizeHeight(20, context)),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: sizeHeight(60, context),
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

// TESTING
  Widget _buildSelectSurvay() {
    List<Widget> loadTestData = [
      Container(
        child: Text(
          "Disease".i18n() + " *",
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      Container(
        child: Column(
          children: [
            FormField<int>(
              validator: (value) => InputCodeValidator.validateMyRadioListTile(
                  value, _plantDisease),
              builder: (FormFieldState<int> state) {
                return Column(
                  children: [
                    MyRadioListTile<int>(
                      value: 1,
                      groupValue: _plantDisease,
                      leading: _plantDisease == 1 ? '/' : 'x',
                      title: Text('${SurveyPatternDisease[0]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        setState(() {
                          _plantDisease = value!;
                          surveying.surveyPatternDisease =
                              _plantDisease.toString();
                          if (value != null) {
                            state.didChange(value);
                            _plantDisease = value;
                            if (_plantDisease != 0) {
                              surveying.surveyPatternDisease =
                                  SurveyPatternDisease[_plantDisease - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 2,
                      groupValue: _plantDisease,
                      leading: _plantDisease == 2 ? '/' : 'x',
                      title: Text('${SurveyPatternDisease[1]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _plantDisease = value!;
                          surveying.surveyPatternDisease =
                              _plantDisease.toString();
                          if (value != null) {
                            state.didChange(value);
                            _plantDisease = value;
                            if (_plantDisease != 0) {
                              surveying.surveyPatternDisease =
                                  SurveyPatternDisease[_plantDisease - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 3,
                      groupValue: _plantDisease,
                      leading: _plantDisease == 3 ? '/' : 'x',
                      title: Text('${SurveyPatternDisease[2]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _plantDisease = value!;
                          surveying.surveyPatternDisease =
                              _plantDisease.toString();
                          if (value != null) {
                            state.didChange(value);
                            _plantDisease = value;
                            if (_plantDisease != 0) {
                              surveying.surveyPatternDisease =
                                  SurveyPatternDisease[_plantDisease - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 4,
                      groupValue: _plantDisease,
                      leading: _plantDisease == 4 ? '/' : 'x',
                      title: Text('${SurveyPatternDisease[3]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _plantDisease = value!;
                          surveying.surveyPatternDisease =
                              _plantDisease.toString();
                          if (value != null) {
                            state.didChange(value);
                            _plantDisease = value;
                            if (_plantDisease != 0) {
                              surveying.surveyPatternDisease =
                                  SurveyPatternDisease[_plantDisease - 1];
                            }
                          }
                        });
                      },
                    ),
                    if (state.hasError && _plantDisease == 0)
                      Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      SizedBox(
        height: sizeHeight(20, context),
      ),
      Container(
        child: Text(
          "PestPhase".i18n() + " *",
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      Container(
        child: Column(
          children: [
            FormField<int>(
              validator: (value) =>
                  InputCodeValidator.validateMyRadioListTile(value, _pest),
              builder: (FormFieldState<int> state) {
                return Column(
                  children: [
                    MyRadioListTile<int>(
                      value: 1,
                      groupValue: _pest,
                      leading: _pest == 1 ? '/' : 'x',
                      title: Text('${SurveyPatternPest[0]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _pest = value!;
                          surveying.surveyPatternPest = _pest.toString();
                          if (value != null) {
                            state.didChange(value);
                            _pest = value;
                            if (_pest != 0) {
                              surveying.surveyPatternPest =
                                  SurveyPatternPest[_pest - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 2,
                      groupValue: _pest,
                      leading: _pest == 2 ? '/' : 'x',
                      title: Text('${SurveyPatternPest[1]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _pest = value!;
                          surveying.surveyPatternPest = _pest.toString();
                          if (value != null) {
                            state.didChange(value);
                            _pest = value;
                            if (_pest != 0) {
                              surveying.surveyPatternPest =
                                  SurveyPatternPest[_pest - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 3,
                      groupValue: _pest,
                      leading: _pest == 3 ? '/' : 'x',
                      title: Text('${SurveyPatternPest[2]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _pest = value!;
                          surveying.surveyPatternPest = _pest.toString();
                          if (value != null) {
                            state.didChange(value);
                            _pest = value;
                            if (_pest != 0) {
                              surveying.surveyPatternPest =
                                  SurveyPatternPest[_pest - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 4,
                      groupValue: _pest,
                      leading: _pest == 4 ? '/' : 'x',
                      title: Text('${SurveyPatternPest[3]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _pest = value!;
                          surveying.surveyPatternPest = _pest.toString();
                          if (value != null) {
                            state.didChange(value);
                            _pest = value;
                            if (_pest != 0) {
                              surveying.surveyPatternPest =
                                  SurveyPatternPest[_pest - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 5,
                      groupValue: _pest,
                      leading: _pest == 5 ? '/' : 'x',
                      title: Text('${SurveyPatternPest[4]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _pest = value!;
                          surveying.surveyPatternPest = _pest.toString();
                          if (value != null) {
                            state.didChange(value);
                            _pest = value;
                            if (_pest != 0) {
                              surveying.surveyPatternPest =
                                  SurveyPatternPest[_pest - 1];
                            }
                          }
                        });
                      },
                    ),
                    if (state.hasError && _pest == 0)
                      Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            )
          ],
        ),
      ),
      SizedBox(
        height: sizeHeight(20, context),
      ),
      Container(
        child: Text(
          "NaturalEnermies".i18n() + " *",
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      Container(
        child: Column(
          children: [
            FormField<int>(
              validator: (value) => InputCodeValidator.validateMyRadioListTile(
                  value, _naturalEnemy),
              builder: (FormFieldState<int> state) {
                return Column(
                  children: [
                    MyRadioListTile<int>(
                      value: 1,
                      groupValue: _naturalEnemy,
                      leading: _naturalEnemy == 1 ? '/' : 'x',
                      title: Text('${SurveyPatternNaturalEnemy[0]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _naturalEnemy = value!;
                          surveying.surveyPatternNaturalEnemy =
                              _naturalEnemy.toString();
                          if (value != null) {
                            state.didChange(value);
                            _naturalEnemy = value;
                            if (_naturalEnemy != 0) {
                              surveying.surveyPatternNaturalEnemy =
                                  SurveyPatternNaturalEnemy[_naturalEnemy - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 2,
                      groupValue: _naturalEnemy,
                      leading: _naturalEnemy == 2 ? '/' : 'x',
                      title: Text('${SurveyPatternNaturalEnemy[1]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _naturalEnemy = value!;
                          surveying.surveyPatternNaturalEnemy =
                              _naturalEnemy.toString();
                          if (value != null) {
                            state.didChange(value);
                            _naturalEnemy = value;
                            if (_naturalEnemy != 0) {
                              surveying.surveyPatternNaturalEnemy =
                                  SurveyPatternNaturalEnemy[_naturalEnemy - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 3,
                      groupValue: _naturalEnemy,
                      leading: _naturalEnemy == 3 ? '/' : 'x',
                      title: Text('${SurveyPatternNaturalEnemy[2]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _naturalEnemy = value!;
                          surveying.surveyPatternNaturalEnemy =
                              _naturalEnemy.toString();
                          if (value != null) {
                            state.didChange(value);
                            _naturalEnemy = value;
                            if (_naturalEnemy != 0) {
                              surveying.surveyPatternNaturalEnemy =
                                  SurveyPatternNaturalEnemy[_naturalEnemy - 1];
                            }
                          }
                        });
                      },
                    ),
                    MyRadioListTile<int>(
                      value: 4,
                      groupValue: _naturalEnemy,
                      leading: _naturalEnemy == 4 ? '/' : 'x',
                      title: Text('${SurveyPatternNaturalEnemy[3]}',
                          style: TextStyle(fontSize: sizeHeight(20, context))),
                      onChanged: (value) {
                        ////print(value);
                        setState(() {
                          _naturalEnemy = value!;
                          surveying.surveyPatternNaturalEnemy =
                              _naturalEnemy.toString();
                          if (value != null) {
                            state.didChange(value);
                            _naturalEnemy = value;
                            if (_naturalEnemy != 0) {
                              surveying.surveyPatternNaturalEnemy =
                                  SurveyPatternNaturalEnemy[_naturalEnemy - 1];
                            }
                          }
                        });
                      },
                    ),
                    if (state.hasError && _naturalEnemy == 0)
                      Text(
                        state.errorText!,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      )
    ];
    return Container(
      height: SizeConfig.screenHeight! * 0.6,
      child: Form(
        key: _formKeyPage5,
        autovalidateMode: test,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: loadTestData.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: loadTestData[index],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectImage() {
    List<Widget> loadTestData = [
      Container(
        child: Text(
          "herbicide-damage".i18n() + " *",
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.025,
      ),
      DropdownSearch<String>(
        mode: Mode.DIALOG,
        showSelectedItems: true,
        items: percentDamage,
        dropdownSearchDecoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeHeight(20, context)),
            borderSide: const BorderSide(
              color: theme_color,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(sizeHeight(20, context)),
            borderSide: BorderSide(
              color: theme_color,
              width: sizeWidth(1, context),
            ),
          ),
        ),
        popupItemDisabled: isItemDisabled,
        onChanged: (value) {
          setState(() {
            surveying.percentDamageFromHerbicide = value.toString();
          });
        },
        selectedItem: surveying.percentDamageFromHerbicide == ""
            ? percentDamageFromHerbicide
            : surveying.percentDamageFromHerbicide,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          cursorColor: Colors.blue,
          autofillHints: [AutofillHints.name],
          decoration: InputDecoration(
            hintText: 'search'.i18n(),
          ),
        ),
        validator: (value) =>
            InputCodeValidator.validateDropDown(value, "choose-damage".i18n()),
      ),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.025,
      ),
      Container(
        child: Text(
          "note-label".i18n(),
          style: TextStyle(
              color: _userNameColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
              fontSize: sizeHeight(20, context)),
        ),
      ),
      SizedBox(
        height: SizeConfig.screenHeight! * 0.02,
      ),
      AnimTFF(
          (text) => {
                setState(() {
                  surveying.note = text;
                }),
              },
          inputIcon: Icon(Icons.event_note_rounded),
          labelText:
              surveying.note == "" ? "note-label".i18n() : surveying.note,
          successText: ""),
    ];
    return Container(
        height: SizeConfig.screenHeight! * 0.6,
        child: Form(
            key: _formKeyPage4,
            autovalidateMode: test,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: loadTestData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: loadTestData[index],
                  );
                })));
  }

//
  @override
  Widget build(BuildContext context) {
    //       var dropdownplanting = Provider.of<Dropdownplanting>(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Dropdownplanting>(
              create: (BuildContext context) {
            return Dropdownplanting();
          }),
        ],
        child: Consumer<Dropdownplanting>(
            builder: (context, dropdownplanting, child) {
          var providerType = Provider.of<Dropdownplanting>(context);
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(SizeConfig.screenHeight! * 0.085),
              child: getAppBarUI(),
            ),
            //height: SizeConfig.screenHeight,

            body: _isLoading == true
                ? CircularProgressIndicator()
                : Container(
                    padding: EdgeInsets.all(SizeConfig.screenHeight! * 0.015),
                    child: Container(
                      height: SizeConfig.screenHeight,
                      child: Theme(
                          data: ThemeData(
                            canvasColor: Color.fromARGB(255, 255, 255, 255),
                            // canvasColor: Colors.brown,
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary: theme_color4,
                                  background: Colors.red,
                                  secondary: Colors.green,
                                ),
                          ),
                          child: Stepper(
                            physics: ScrollPhysics(),
                            type: stepperType,
                            currentStep: _currentStep,
                            onStepTapped: (step) => tapped(step),
                            onStepContinue: continued,
                            onStepCancel: cancel,
                            controlsBuilder: (context,
                                {onStepCancel, onStepContinue}) {
                              return Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                    width: sizeWidth(25, context),
                                    height: sizeHeight(35, context),
                                    child: ElevatedButton(
                                      child: Text(
                                        'previous-label'.i18n(),
                                        style: TextStyle(
                                            fontSize: sizeHeight(16, context)),
                                      ),
                                      onPressed: cancel,
                                    ),
                                  )),
                                  SizedBox(
                                    width: sizeWidth(20, context),
                                  ),
                                  Expanded(
                                      child: Container(
                                    width: sizeWidth(25, context),
                                    height: sizeHeight(35, context),
                                    child: ElevatedButton(
                                      child: isFinal()
                                          ? _isPassValueFromPage
                                              ? Text(
                                                  'confirm-edit-label'.i18n(),
                                                  style: TextStyle(
                                                      fontSize: sizeHeight(
                                                          16, context)),
                                                )
                                              : Text(
                                                  'create-new-cultivation-label'
                                                      .i18n(),
                                                  style: TextStyle(
                                                      fontSize: sizeHeight(
                                                          16, context)),
                                                )
                                          : Text(
                                              'next-label'.i18n(),
                                              style: TextStyle(
                                                  fontSize:
                                                      sizeHeight(16, context)),
                                            ),
                                      onPressed: continued,
                                    ),
                                  )),
                                ],
                              );
                            },
                            steps: [
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 0;
                                    });
                                  },
                                ),
                                content: Column(
                                  children: <Widget>[
                                    _buildSelectedSurvey(dropdownplanting),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025)
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 0
                                    ? StepState.complete
                                    : StepState.disabled,
                              ),
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 1;
                                    });
                                  },
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 1
                                    ? StepState.complete
                                    : StepState.disabled,
                                content: Column(
                                  children: <Widget>[
                                    _buildSelectPlant(),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025)
                                  ],
                                ),
                              ),
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 2;
                                    });
                                  },
                                ),
                                content: Column(
                                  children: <Widget>[
                                    _buildEnviromentFactor(),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025)
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 2
                                    ? StepState.complete
                                    : StepState.disabled,
                              ),
                              Step(
                                title: GestureDetector(
                                  child: new Text(''),
                                  onTap: () {
                                    setState(() {
                                      _currentStep = 3;
                                    });
                                  },
                                ),
                                content: Column(
                                  children: <Widget>[
                                    _buildSelectImage(),
                                    SizedBox(
                                        height:
                                            SizeConfig.screenHeight! * 0.025)
                                  ],
                                ),
                                isActive: _currentStep >= 0,
                                state: _currentStep >= 3
                                    ? StepState.complete
                                    : StepState.disabled,
                              ),
                            ],
                          )),
                    ),
                  ),
          );
        }));
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
            top: MediaQuery.of(context).padding.top,
            left: sizeWidth(8, context),
            right: sizeWidth(8, context)),
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
                    Radius.circular(sizeHeight(32, context)),
                  ),
                  onTap: () {
                    resetValueEditNotFinish();
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
                child: Text(
                  _isPassValueFromPage
                      ? "updateSurvey-label".i18n()
                      : "createSurvey-label".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
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
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
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
                        Radius.circular(sizeHeight(32, context)),
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
}
