import 'dart:convert';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/controller/variety_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/entities/variety.dart';
import 'package:mun_bot/model/input_validator.dart';
import 'package:mun_bot/providers/field_dropdown_provider.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/survey/dropdown_for_field.dart';
import 'package:mun_bot/screen/survey/dropdown_for_planting.dart';
import 'package:mun_bot/screen/survey/dropdown_for_field.dart';
import 'package:mun_bot/screen/widget/loading.dart';
import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/shake_widget.dart';

import 'package:mun_bot/util/ui/input.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/ui/radio_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:localization/localization.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mun_bot/env.dart';
//date time to time stamp
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../main.dart'; //DateFormat
import 'package:mun_bot/screen/login/login_screen.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../main_screen.dart';

class NewCultivationScreen extends StatefulWidget {
  final int passFieldID;
  final Planting? plantingFromPassPage;
  PlantingProvider plantingProvider;
  NewCultivationScreen(
      this.passFieldID, this.plantingFromPassPage, this.plantingProvider);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewCultivationScreen();
  }
}

class _NewCultivationScreen extends State<NewCultivationScreen> {
  int _currentStep = 0;

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();

  AutovalidateMode autovidateDisable = AutovalidateMode.disabled;
  // bool autovalidate=false;
  //keyform
  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final _formKeyPage3 = GlobalKey<FormState>();
  final _formKeyPage4 = GlobalKey<FormState>();
  final _formKeyPage5 = GlobalKey<FormState>();
  final myController = TextEditingController();
  late Planting planting;
  int intputFieldId = 0;
  int _areaType = 0;
  String? selectedField;
  int _numberfertilized = 1;
  int fertilizedState = 1;
  int _numberEliminate = 1;
  int? _stemSource = 1;
  int lastFieldID = 0;
  String areaSize = "";
  String selectedfieldName = "name-field-label".i18n();
  String selectedfieldCode = "code-field".i18n();
  String selectedfieldLocation = "address".i18n();
  String selectedfieldOwner = "owner".i18n();
  String? selectBesidePlant = "select-beside-plant-label".i18n();
  String? _selectChemical1 = "select-cheimcals-used".i18n();
  String? _selectChemical2 = "select-cheimcals-used".i18n();
  String? _selectChemical3 = "select-cheimcals-used".i18n();
  String? _selectDisManangement = "select-disease-management-method".i18n();
  String? _selectPestManagement = "select-pest-management".i18n();
  String? _selectPreviousPlant = "select-previous-plant".i18n();
  String? _selectSoakingStemChemical = "select-chem-kill-insects".i18n();
  String? _selectNumTillage = "select-number-plow".i18n();
  String? _selectSoilAmendments = "select-soil-amendments".i18n();
  String? _selectWeedingMonth1 = "select-weeding-month".i18n();
  String? _selectWeedingMonth2 = "select-weeding-month".i18n();
  String? _selectWeedingMonth3 = "select-weeding-month".i18n();
  String? _selectMainPlating = "select-main-species".i18n();
  int _selectStemSource = 0;
  String ownerFieldByPassingValue = "";
  String fieldNameByPassingValue = "";
  String locationByPassingValue = "";

  bool _isPassValueFromPage = false;
  var errorText = {"code": null, "name": null, "size": null};
  var _image;
  String? selectedValue;

  List<Field> listFieldOnUser = [];
  var _userNameColor = Colors.black;

  bool isSelectedField = false;
  bool _isLoading = true;
  final picker = ImagePicker();

  String _pathImage = "";

  int pageFieldService = 1;

  int fieldIdFromDropdown = 0;
  // SAVE INPUT FOR CREATE PLANTING
  // === PAGE 1 ===
  String save_plantingCode = "";
  String save_plantingName = "";
  String save_plantingPrimaryVarietyOther = "";

  // Variable for edit data with pop
  String tempPlanting = "";

  //Variety data
  List<String> _items = [];

  List<String> _selectedMainPlanting = [];
  List<int> _varietyId = [];
  List<Variety> varieties = [];

  @override
  void initState() {
    // TODO: implement initState
    ////   print(" width : ${SizeConfig.screenWidth}");
    asyncFunction();
    super.initState();
  }

  asyncFunction() async {
    String? token = tokenFromLogin?.token;
    VarietyService varietyService = VarietyService();
    varieties = await varietyService.getVarieties(token.toString());
    for (int i = 0; i < varieties.length; i++) {
      _items.add(varieties[i].name);
    }
    if (widget.plantingFromPassPage == null) {
      _isPassValueFromPage = false;
      planting = Planting(
          0, // 0 default
          "",
          "",
          0,
          "",
          "",
          "",
          "",
          "",
          "",
          0,
          0,
          "",
          "",
          0,
          0,
          "",
          "",
          "",
          "",
          "",
          0,
          "",
          0,
          "",
          0,
          "",
          "",
          "",
          0,
          0,
          "",
          0,
          0,
          "",
          0,
          0,
          "",
          "",
          1671180044000,
          1,
          1671180044000,
          -1,
          -1,
          -1);
    } else {
      Field? field;
      String? token = tokenFromLogin?.token;

      _isPassValueFromPage = true;
      tempPlanting = jsonEncode(widget.plantingFromPassPage!);
      planting = widget.plantingFromPassPage!;

      List<Variety> tempVariety = await varietyService.getVarietiesByPlantingId(
          token.toString(), planting.plantingId);
      _selectedMainPlanting = [];
      for (int i = 0; i < tempVariety.length; i++) {
        _selectedMainPlanting.add(tempVariety[i].name);
      }
      FieldService fieldService = FieldService();
      field = await fieldService.getFieldByPlantingID(
          planting.plantingId, token.toString());

      if (field != null) {
        fieldNameByPassingValue = field.name;
        int fieldID = field.fieldID;

        String? location =
            await fieldService.getLocationByFielID(fieldID, token.toString());
        if (location != null) {
          locationByPassingValue = location;
        } else {
          locationByPassingValue = "";
        }

        UserService userService = UserService();
        User? user =
            await userService.getUserByFieldID(fieldID, token.toString());
        if (user != null) {
          ownerFieldByPassingValue =
              "${user.title} ${user.firstName} ${user.lastName}";
        } else {
          ownerFieldByPassingValue = "UNKNOWN";
        }
      }

      _selectStemSource = stemSourceName.indexOf(planting.stemSource) + 1;
      cultivattionMajorDateController.text = DateFormat("dd-MM-yyyy").format(
          DateTime.fromMillisecondsSinceEpoch(
              planting.primaryPlantPlantingDate));

      majorHavestDateController.text = DateFormat("dd-MM-yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      planting.primaryPlantHarvestDate)) ==
              "01-01-1970"
          ? "pick-date".i18n()
          : majorHavestDateController.text = DateFormat("dd-MM-yyyy").format(
              DateTime.fromMillisecondsSinceEpoch(
                  planting.primaryPlantHarvestDate));

      cultivattionMinorDateController.text = DateFormat("dd-MM-yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      planting.secondaryPlantPlantingDate)) ==
              "01-01-1970"
          ? "pick-date".i18n()
          : cultivattionMinorDateController.text = DateFormat("dd-MM-yyyy")
              .format(DateTime.fromMillisecondsSinceEpoch(
                  planting.secondaryPlantPlantingDate));
      minorHavestDateController.text = DateFormat("dd-MM-yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      planting.secondaryPlantHarvestDate)) ==
              "01-01-1970"
          ? "pick-date".i18n()
          : minorHavestDateController.text = DateFormat("dd-MM-yyyy").format(
              DateTime.fromMillisecondsSinceEpoch(
                  planting.secondaryPlantHarvestDate));

      _conDateFertilizer1.text = DateFormat("dd-MM-yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      planting.fertilizerDate1)) ==
              "01-01-1970"
          ? "pick-date".i18n()
          : _conDateFertilizer1.text = DateFormat("dd-MM-yyyy").format(
              DateTime.fromMillisecondsSinceEpoch(planting.fertilizerDate1));
      _conDateFertilizer2.text = DateFormat("dd-MM-yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      planting.fertilizerDate2)) ==
              "01-01-1970"
          ? "pick-date".i18n()
          : _conDateFertilizer2.text = DateFormat("dd-MM-yyyy").format(
              DateTime.fromMillisecondsSinceEpoch(planting.fertilizerDate2));
      _conDateFertilizer3.text = DateFormat("dd-MM-yyyy").format(
                  DateTime.fromMillisecondsSinceEpoch(
                      planting.fertilizerDate3)) ==
              "01-01-1970"
          ? "pick-date".i18n()
          : _conDateFertilizer3.text = DateFormat("dd-MM-yyyy").format(
              DateTime.fromMillisecondsSinceEpoch(planting.fertilizerDate3));

      if (planting.weedingMonth1.toString() == "0") {
        _selectWeedingMonth1 = "select-weeding-month".i18n();
      } else {
        _selectWeedingMonth1 = planting.weedingMonth1.toString();
      }
      if (planting.weedingMonth2.toString() == "0") {
        _selectWeedingMonth2 = "select-weeding-month".i18n();
      } else {
        _selectWeedingMonth2 = planting.weedingMonth2.toString();
      }
      if (planting.weedingMonth3.toString() == "0") {
        _selectWeedingMonth3 = "select-weeding-month".i18n();
      } else {
        _selectWeedingMonth3 = planting.weedingMonth3.toString();
      }

      // New Dropdown
      if (planting.herbicideByWeedingChemical1 == -1) {
        if (planting.weedingChemicalOther1 == "") {
          _selectChemical1 = "select-cheimcals-used".i18n();
        } else {
          _selectChemical1 = "อื่นๆ";
        }
      } else {
        _selectChemical1 =
            weedingChemicalName[planting.herbicideByWeedingChemical1 - 1]
                .toString();
      }

      if (planting.herbicideByWeedingChemical2 == -1) {
        if (planting.weedingChemicalOther2 == "") {
          _selectChemical2 = "select-cheimcals-used".i18n();
        } else {
          _selectChemical2 = "อื่นๆ";
        }
      } else {
        _selectChemical2 =
            weedingChemicalName[planting.herbicideByWeedingChemical2 - 1]
                .toString();
      }

      if (planting.herbicideByWeedingChemical3 == -1) {
        if (planting.weedingChemicalOther3 == "") {
          _selectChemical3 = "select-cheimcals-used".i18n();
        } else {
          _selectChemical3 = "อื่นๆ";
        }
      } else {
        _selectChemical3 =
            weedingChemicalName[planting.herbicideByWeedingChemical3 - 1]
                .toString();
      }

      _selectPreviousPlant = planting.previousPlant;
      selectBesidePlant = planting.besidePlant;
      _selectNumTillage = planting.numTillage;
      _selectSoilAmendments = planting.soilAmendments;
      _selectSoakingStemChemical = planting.soakingStemChemical;
      if (planting.diseaseManagement != "") {
        _selectDisManangement = planting.diseaseManagement;
      } else {
        _selectDisManangement = "select-disease-management-method".i18n();
      }
      if (planting.pestManagement != "") {
        _selectPestManagement = planting.pestManagement;
      } else {
        _selectPestManagement = "select-pest-management".i18n();
      }
      ////   print("testtest ------ : ${_selectStemSource}");
    }

    FieldService fieldService = new FieldService();
    List<Field> data =
        await fieldService.getFields(token.toString(), pageFieldService, 2);
    List<String> temp = [];
    if (mounted)
      setState(() {
        //fieldName=temp.toList();
        listFieldOnUser = data;
        _isLoading = false;
      });
  }

  void _scrollDown(ScrollController _controller) {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
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

  resetValueEditNotFinish() {
    if (_isPassValueFromPage) {
      Map<String, dynamic> copy = jsonDecode(tempPlanting);
      Planting savePlanting = Planting.fromJson(copy);
      planting.besidePlant = savePlanting.besidePlant;
      planting.besidePlantOther = savePlanting.besidePlantOther;
      planting.code = savePlanting.code;
      planting.createDate = savePlanting.createDate;
      planting.diseaseManagement = savePlanting.diseaseManagement;
      planting.fertilizerDate1 = savePlanting.fertilizerDate1;
      planting.fertilizerDate2 = savePlanting.fertilizerDate2;
      planting.fertilizerDate3 = savePlanting.fertilizerDate3;
      planting.fertilizerFormular1 = savePlanting.fertilizerFormular1;
      planting.fertilizerFormular2 = savePlanting.fertilizerFormular2;
      planting.fertilizerFormular3 = savePlanting.fertilizerFormular3;
      planting.herbicideByWeedingChemical1 =
          savePlanting.herbicideByWeedingChemical1;
      planting.herbicideByWeedingChemical2 =
          savePlanting.herbicideByWeedingChemical2;
      planting.herbicideByWeedingChemical3 =
          savePlanting.herbicideByWeedingChemical3;
      planting.lastUpdateBy = savePlanting.lastUpdateBy;
      planting.lastUpdateDate = savePlanting.lastUpdateDate;
      planting.name = savePlanting.name;
      planting.note = savePlanting.note;
      planting.numTillage = savePlanting.numTillage;
      planting.pestManagement = savePlanting.pestManagement;
      planting.plantingId = savePlanting.plantingId;
      planting.previousPlant = savePlanting.previousPlant;
      planting.previousPlantOther = savePlanting.previousPlantOther;
      planting.primaryPlantHarvestDate = savePlanting.primaryPlantHarvestDate;
      planting.primaryPlantPlantingDate = savePlanting.primaryPlantPlantingDate;
      planting.primaryPlantType = savePlanting.primaryPlantType;
      planting.primaryVarietyOther = savePlanting.primaryVarietyOther;
      planting.secondaryPlantHarvestDate =
          savePlanting.secondaryPlantHarvestDate;
      planting.secondaryPlantPlantingDate =
          savePlanting.secondaryPlantPlantingDate;
      planting.secondaryPlantType = savePlanting.secondaryPlantType;
      planting.secondaryPlantVariety = savePlanting.secondaryPlantVariety;
      planting.size = savePlanting.size;
      planting.soakingStemChemical = savePlanting.soakingStemChemical;
      planting.soilAmendments = savePlanting.soilAmendments;
      planting.soilAmendmentsOther = savePlanting.soilAmendmentsOther;
      planting.stemSource = savePlanting.stemSource;
      planting.weedingChemical1 = savePlanting.weedingChemical1;
      planting.weedingChemical2 = savePlanting.weedingChemical2;
      planting.weedingChemical3 = savePlanting.weedingChemical3;
      planting.weedingChemicalOther1 = savePlanting.weedingChemicalOther1;
      planting.weedingChemicalOther2 = savePlanting.weedingChemicalOther2;
      planting.weedingChemicalOther3 = savePlanting.weedingChemicalOther3;
      planting.weedingMonth1 = savePlanting.weedingMonth1;
      planting.weedingMonth2 = savePlanting.weedingMonth2;
      planting.weedingMonth3 = savePlanting.weedingMonth3;
    }
  }

  StepperType stepperType = StepperType.horizontal;

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep == 5) {
      Navigator.of(context).pop();
    } else if (_currentStep == 0) {
      if (_formKeyPage1.currentState!.validate()) {
        save_plantingCode = planting.code;
        save_plantingName = planting.name;
        setState(() => _currentStep += 1);
      } else {
        //   //   print("in valid");
      }
    } else if (_currentStep == 1) {
      if (_formKeyPage2.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        //   print("in valid");
      }
    } else if (_currentStep == 2) {
      if (_formKeyPage3.currentState!.validate()) {
        save_plantingPrimaryVarietyOther = planting.primaryVarietyOther;
        setState(() => _currentStep += 1);
      } else {
        //   print("in valid");
      }
    } else if (_currentStep == 4) {
      if (_formKeyPage5.currentState!.validate()) {
        setState(() => _currentStep += 1);
      } else {
        //   print("in valid");
      }
    } else {
      setState(() => _currentStep += 1);
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

  bool isItemDisabled(String s) {
    //return s.startsWith('I');

    if (s.startsWith('I')) {
      return true;
    } else {
      return false;
    }
  }

  bool isFinal() {
    if (_currentStep == 5) return true;

    return false;
  }

  submitFunction() async {
    for (int i = 0; i < _selectedMainPlanting.length; i++) {
      for (int y = 0; y < varieties.length; y++) {
        if (_selectedMainPlanting[i] == varieties[y].name) {
          _varietyId.add(varieties[y].varietyId);
        }
      }
    }
    if (_isPassValueFromPage) {
      //update

      planting.lastUpdateBy = 1;
      planting.createDate = planting.createDate;
      planting.lastUpdateDate = DateTime.now().millisecondsSinceEpoch;

      CustomLoading.dismissLoading();
      CustomLoading.showLoading();

      PlantingService plantingService = PlantingService();

      String? token = tokenFromLogin?.token.toString();

      Map<String, dynamic> postData = {
        "code": planting.code,
        "name": planting.name,
        "size": planting.size,
        "previousPlant": planting.previousPlant,
        "besidePlant": planting.besidePlant,
        "primaryVarietyOther": planting.primaryVarietyOther,
        "primaryPlantPlantingDate": planting.primaryPlantPlantingDate,
        "stemSource": planting.stemSource,
        "soakingStemChemical": planting.soakingStemChemical,
        "numTillage": planting.numTillage,
        "soilAmendments": planting.soilAmendments,
        "createDate": planting.createDate,
        "note": planting.note,
        "plantingcassavavarieties": _varietyId,
      };

      if (planting.previousPlant == "อื่นๆ") {
        postData["previousPlantOther"] = planting.previousPlantOther;
      }
      if (planting.besidePlant == "อื่นๆ") {
        postData["besidePlantOther"] = planting.besidePlantOther;
      }
      if (planting.primaryPlantHarvestDate != 0) {
        postData["primaryPlantHarvestDate"] = planting.primaryPlantHarvestDate;
      }
      if (planting.secondaryPlantType != "" ||
          planting.secondaryPlantType.isNotEmpty) {
        postData["secondaryPlantType"] = planting.secondaryPlantType;
      }
      if (planting.secondaryPlantVariety != "" ||
          planting.secondaryPlantVariety.isNotEmpty) {
        postData["secondaryPlantVariety"] = planting.secondaryPlantVariety;
      }
      if (planting.secondaryPlantPlantingDate != 0) {
        postData["secondaryPlantPlantingDate"] =
            planting.secondaryPlantPlantingDate;
      }
      if (planting.secondaryPlantHarvestDate != 0) {
        postData["secondaryPlantHarvestDate"] =
            planting.secondaryPlantHarvestDate;
      }
      if (planting.soilAmendments == "อื่นๆ") {
        postData["soilAmendmentsOther"] = planting.soilAmendmentsOther;
      }
      if (planting.diseaseManagement != "" ||
          planting.diseaseManagement.isNotEmpty) {
        postData["diseaseManagement"] = planting.diseaseManagement;
      }
      if (planting.pestManagement != "" || planting.pestManagement.isNotEmpty) {
        postData["pestManagement"] = planting.pestManagement;
      }
      if (planting.fertilizerDate1 != 0) {
        postData["fertilizerDate1"] = planting.fertilizerDate1;
      }
      if (planting.fertilizerFormular1 != "" ||
          planting.fertilizerFormular1.isNotEmpty) {
        postData["fertilizerFormular1"] = planting.fertilizerFormular1;
      }
      if (planting.fertilizerDate2 != 0) {
        postData["fertilizerDate2"] = planting.fertilizerDate2;
      }
      if (planting.fertilizerFormular2 != "" ||
          planting.fertilizerFormular2.isNotEmpty) {
        postData["fertilizerFormular2"] = planting.fertilizerFormular2;
      }
      if (planting.fertilizerDate3 != 0) {
        postData["fertilizerDate3"] = planting.fertilizerDate3;
      }
      if (planting.fertilizerFormular3 != "" ||
          planting.fertilizerFormular3.isNotEmpty) {
        postData["fertilizerFormular3"] = planting.fertilizerFormular3;
      }
      if (planting.weedingMonth1 != 0) {
        postData["weedingMonth1"] = planting.weedingMonth1;
      }
      if (planting.herbicideByWeedingChemical1 != -1) {
        if (planting.herbicideByWeedingChemical1 == 8) {
          postData["herbicideByWeedingChemical1"] =
              planting.herbicideByWeedingChemical1 + 1;
          postData["weedingChemicalOther1"] = planting.weedingChemicalOther1;
        } else {
          postData["herbicideByWeedingChemical1"] =
              planting.herbicideByWeedingChemical1;
          postData["weedingChemicalOther1"] = "";
        }
      }
      if (planting.weedingMonth2 != 0) {
        postData["weedingMonth2"] = planting.weedingMonth2;
      }
      if (planting.herbicideByWeedingChemical2 != -1) {
        if (planting.herbicideByWeedingChemical2 == 8) {
          postData["herbicideByWeedingChemical2"] =
              planting.herbicideByWeedingChemical2 + 1;
          postData["weedingChemicalOther2"] = planting.weedingChemicalOther2;
        } else {
          postData["herbicideByWeedingChemical2"] =
              planting.herbicideByWeedingChemical2;
          postData["weedingChemicalOther2"] = "";
        }
      }
      if (planting.weedingMonth3 != 0) {
        postData["weedingMonth3"] = planting.weedingMonth3;
      }
      if (planting.herbicideByWeedingChemical3 != -1) {
        if (planting.herbicideByWeedingChemical3 == 8) {
          postData["herbicideByWeedingChemical3"] =
              planting.herbicideByWeedingChemical3 + 1;
          postData["weedingChemicalOther3"] = planting.weedingChemicalOther3;
        } else {
          postData["herbicideByWeedingChemical3"] =
              planting.herbicideByWeedingChemical3;
          postData["weedingChemicalOther3"] = "";
        }
      }
      var json_postData = jsonEncode(postData);
      log(json_postData);
      int statuscode = await plantingService.updatePlanting(
          token.toString(), json_postData, planting.plantingId);
      CustomLoading.dismissLoading();
      if (statuscode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        CustomLoading.showSuccess();
      } else {
        CustomLoading.showError(
            context, 'Something went wrong. Please try again later.');
      }
    } else {
      //create
      planting.lastUpdateBy = 1;
      planting.createDate = DateTime.now().millisecondsSinceEpoch;
      planting.lastUpdateDate = DateTime.now().millisecondsSinceEpoch;

      CustomLoading.dismissLoading();
      CustomLoading.showLoading();
      PlantingService plantingService = PlantingService();

      int test;
      try {
        test = int.parse(selectedField.toString());
      } catch (e) {
        test = widget.passFieldID;
        //   print("never select field set to default 0");
      }

      String? token = tokenFromLogin?.token.toString();
      Map<String, dynamic> postData = {
        "field": test,
        "code": planting.code,
        "name": planting.name,
        "size": planting.size,
        "previousPlant": planting.previousPlant,
        "besidePlant": planting.besidePlant,
        "primaryVarietyOther": planting.primaryVarietyOther,
        "primaryPlantPlantingDate": planting.primaryPlantPlantingDate,
        "stemSource": planting.stemSource,
        "soakingStemChemical": planting.soakingStemChemical,
        "numTillage": planting.numTillage,
        "soilAmendments": planting.soilAmendments,
        "createDate": planting.createDate,
        "note": planting.note,
        "plantingcassavavarieties": _varietyId,
      };
      if (planting.previousPlant == "อื่นๆ") {
        postData["previousPlantOther"] = planting.previousPlantOther;
      }
      if (planting.besidePlant == "อื่นๆ") {
        postData["besidePlantOther"] = planting.besidePlantOther;
      }
      if (planting.primaryPlantHarvestDate != 0) {
        postData["primaryPlantHarvestDate"] = planting.primaryPlantHarvestDate;
      }
      if (planting.secondaryPlantType != "" ||
          planting.secondaryPlantType.isNotEmpty) {
        postData["secondaryPlantType"] = planting.secondaryPlantType;
      }
      if (planting.secondaryPlantVariety != "" ||
          planting.secondaryPlantVariety.isNotEmpty) {
        postData["secondaryPlantVariety"] = planting.secondaryPlantVariety;
      }
      if (planting.secondaryPlantPlantingDate != 0) {
        postData["secondaryPlantPlantingDate"] =
            planting.secondaryPlantPlantingDate;
      }
      if (planting.secondaryPlantHarvestDate != 0) {
        postData["secondaryPlantHarvestDate"] =
            planting.secondaryPlantHarvestDate;
      }
      if (planting.soilAmendments == "อื่นๆ") {
        postData["soilAmendmentsOther"] = planting.soilAmendmentsOther;
      }
      if (planting.diseaseManagement != "" ||
          planting.diseaseManagement.isNotEmpty) {
        postData["diseaseManagement"] = planting.diseaseManagement;
      }
      if (planting.pestManagement != "" || planting.pestManagement.isNotEmpty) {
        postData["pestManagement"] = planting.pestManagement;
      }
      if (planting.fertilizerDate1 != 0) {
        postData["fertilizerDate1"] = planting.fertilizerDate1;
      }
      if (planting.fertilizerFormular1 != "" ||
          planting.fertilizerFormular1.isNotEmpty) {
        postData["fertilizerFormular1"] = planting.fertilizerFormular1;
      }
      if (planting.fertilizerDate2 != 0) {
        postData["fertilizerDate2"] = planting.fertilizerDate2;
      }
      if (planting.fertilizerFormular2 != "" ||
          planting.fertilizerFormular2.isNotEmpty) {
        postData["fertilizerFormular2"] = planting.fertilizerFormular2;
      }
      if (planting.fertilizerDate3 != 0) {
        postData["fertilizerDate3"] = planting.fertilizerDate3;
      }
      if (planting.fertilizerFormular3 != "" ||
          planting.fertilizerFormular3.isNotEmpty) {
        postData["fertilizerFormular3"] = planting.fertilizerFormular3;
      }
      if (planting.weedingMonth1 != 0) {
        postData["weedingMonth1"] = planting.weedingMonth1;
      }
      if (planting.herbicideByWeedingChemical1 != -1) {
        if (planting.herbicideByWeedingChemical1 == 8) {
          postData["herbicideByWeedingChemical1"] =
              planting.herbicideByWeedingChemical1 + 1;
          postData["weedingChemicalOther1"] = planting.weedingChemicalOther1;
        } else {
          postData["herbicideByWeedingChemical1"] =
              planting.herbicideByWeedingChemical1 + 1;
        }
      }
      if (planting.weedingMonth2 != 0) {
        postData["weedingMonth2"] = planting.weedingMonth2;
      }
      if (planting.herbicideByWeedingChemical2 != -1) {
        if (planting.herbicideByWeedingChemical2 == 8) {
          postData["herbicideByWeedingChemical2"] =
              planting.herbicideByWeedingChemical2 + 1;
          postData["weedingChemicalOther2"] = planting.weedingChemicalOther2;
        } else {
          postData["herbicideByWeedingChemical2"] =
              planting.herbicideByWeedingChemical2 + 1;
        }
      }
      if (planting.weedingMonth3 != 0) {
        postData["weedingMonth3"] = planting.weedingMonth3;
      }
      if (planting.herbicideByWeedingChemical3 != -1) {
        if (planting.herbicideByWeedingChemical3 == 8) {
          postData["herbicideByWeedingChemical3"] =
              planting.herbicideByWeedingChemical3 + 1;
          postData["weedingChemicalOther3"] = planting.weedingChemicalOther3;
        } else {
          postData["herbicideByWeedingChemical3"] =
              planting.herbicideByWeedingChemical3 + 1;
        }
      }
      var json_postData = jsonEncode(postData);
      print("postData Json : ${json_postData}");

      Planting? newPlanting =
          await plantingService.createPlanting(token.toString(), json_postData);
      CustomLoading.dismissLoading();
      if (newPlanting != null) {
        CustomLoading.showSuccess();

        widget.plantingProvider.addPlanting(newPlanting);
        // widget.plantingProvider.notifyListeners();
        Navigator.of(context).pop();
      } else {
        CustomLoading.showError(
            context, 'Something went wrong. Please try again later.');
      }
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Widget _buildCultivationInfo() {
    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("env-cultivation-label".i18n(),
                style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold)),
          ),
          // SizedBox(height: sizeHeight(23.5,context)),
          Form(
            key: _formKeyPage2,
            autovalidateMode: autovidateDisable,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                Container(
                  alignment: Alignment.topLeft,
                  // VALIDATE
                  child: Text(
                    "area-label".i18n() + "*",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                AnimTFF(
                  (text) => {
                    setState(() {
                      RegExp regex =
                          new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
                      if (regex.hasMatch(text.toString())) {
                        if (text.isEmpty) {
                          text = "0.0";
                        }
                        planting.size = double.parse(text);
                      }
                    }),
                  },
                  isOnlyNumber: true,
                  validator1: (value) => InputCodeValidator.validateNumber(
                      value, planting.size.toString()),
                  labelText:
                      planting.size == 0.00 ? "0.00" : planting.size.toString(),
                  successText: "",
                  inputIcon: Icon(Icons.landscape_sharp),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "previous-plant-label".i18n() + "*",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                // VALIDATE
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: previousPlantName,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "พืชที่ปลูกก่อนหน้า",
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      _selectPreviousPlant = value;
                      planting.previousPlant = value.toString();
                      //   print(planting.previousPlant);
                    });
                  },
                  selectedItem: planting.previousPlant == ""
                      ? _selectPreviousPlant
                      : planting.previousPlant,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                  validator: (value) => InputCodeValidator.validateDropDown(
                      value, "select-previous-plant".i18n()),
                ),
                _selectPreviousPlant == "อื่นๆ"
                    ? Column(
                        children: [
                          SizedBox(
                              height: SizeConfig.screenHeight! * 0.02194644482),
                          AnimTFF(
                            (text) => {
                              setState(() {
                                text = text.trim();
                                planting.previousPlantOther = text;
                              }),
                            },
                            validator1: (value) =>
                                InputCodeValidator.validateNotSpecialCharacter(
                                    value,
                                    planting.previousPlantOther.toString()),
                            labelText: planting.previousPlantOther == ""
                                ? 'insert-other-previous-plant'.i18n()
                                : planting.previousPlantOther,
                            successText: "",
                            inputIcon: Icon(Icons.eco_sharp),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "beside-plant-label".i18n() + "*",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                // VALIDATE
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: besidePlantName,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "beside-plant-label".i18n(),
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      selectBesidePlant = value;
                      planting.besidePlant = value.toString();
                    });
                  },
                  selectedItem: planting.besidePlant == ""
                      ? selectBesidePlant
                      : planting.besidePlant,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                  validator: (value) => InputCodeValidator.validateDropDown(
                      value, "select-beside-plant-label".i18n()),
                ),
                selectBesidePlant == "อื่นๆ"
                    ? Column(
                        children: [
                          SizedBox(
                              height: SizeConfig.screenHeight! * 0.02194644482),
                          AnimTFF(
                            (text) => {
                              setState(() {
                                text = text.trim();
                                planting.besidePlantOther = text;
                              }),
                            },
                            validator1: (value) =>
                                InputCodeValidator.validateNotSpecialCharacter(
                                    value,
                                    planting.besidePlantOther.toString()),
                            labelText: planting.besidePlantOther == ""
                                ? 'insert-other-beside-plant'.i18n()
                                : planting.besidePlantOther,
                            successText: "",
                            inputIcon: Icon(Icons.eco_sharp),
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          )
        ],
      ),
    );
  }

  TextEditingController cultivattionMinorDateController =
      TextEditingController();
  TextEditingController cultivattionMajorDateController =
      TextEditingController();
  final _shakeKeyMajorDateTextField = GlobalKey<ShakeWidgetState>();
  final _shakeKeyMinorDateTextField = GlobalKey<ShakeWidgetState>();

  TextEditingController majorHavestDateController = TextEditingController();
  TextEditingController minorHavestDateController = TextEditingController();
  final _shakeKeyMajorHavestTextField = GlobalKey<ShakeWidgetState>();
  final _shakeKeyMinorHavestTextField = GlobalKey<ShakeWidgetState>();

  TextEditingController _conDateFertilizer1 = TextEditingController();
  TextEditingController _conDateFertilizer2 = TextEditingController();
  TextEditingController _conDateFertilizer3 = TextEditingController();
  final _keyDateFertilizer1 = GlobalKey<ShakeWidgetState>();
  final _keyDateFertilizer2 = GlobalKey<ShakeWidgetState>();
  final _keyDateFertilizer3 = GlobalKey<ShakeWidgetState>();

  TextEditingController _conDateEliminate1 = TextEditingController();
  TextEditingController _conDateEliminate2 = TextEditingController();
  TextEditingController _conDateEliminate3 = TextEditingController();
  final _keyDateEliminate1 = GlobalKey<ShakeWidgetState>();
  final _keyDateEliminate2 = GlobalKey<ShakeWidgetState>();
  final _keyDateEliminate3 = GlobalKey<ShakeWidgetState>();

  void _surveyTFToggle(e) {
    setState(() {
      //_rqVisible = !_rqVisible;
      //_dateTimeText = "Survey Date" ;
      //_userNameColor = Colors.black ;
    });
  }

  Widget _buildMajorCultivationDate(String textHint) {
    TextFormField _dateTextField = TextFormField(
      validator: (value) => InputCodeValidator.validateDate(value),
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100));

        if (date != null) {
          planting.primaryPlantPlantingDate = date.millisecondsSinceEpoch;

          cultivattionMajorDateController.text =
              DateFormat("dd-MM-yyyy").format(date);
        }
      },
      controller: cultivattionMajorDateController,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _shakeKeyMajorDateTextField,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // VALIDATE
            Text(
              "planting-date-label".i18n() + "*",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMajorHavestDate(String textHint) {
    TextField _dateTextField = TextField(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));
        if (date != null) {
          planting.primaryPlantHarvestDate = date.millisecondsSinceEpoch;

          majorHavestDateController.text =
              DateFormat("dd-MM-yyyy").format(date);
        }
      },
      controller: majorHavestDateController,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white38,
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
        suffixIcon: GestureDetector(
          onTap: () {
            majorHavestDateController.text = "";
            planting.primaryPlantHarvestDate = 0;
          },
          child: Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _shakeKeyMajorHavestTextField,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "havest-date-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinorCultivationDate(String textHint) {
    TextField _dateTextField = TextField(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));

        if (date != null) {
          planting.secondaryPlantPlantingDate = date.millisecondsSinceEpoch;

          cultivattionMinorDateController.text =
              DateFormat("dd-MM-yyyy").format(date);
        }
      },
      controller: cultivattionMinorDateController,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
        suffixIcon: GestureDetector(
          onTap: () {
            cultivattionMinorDateController.text = "";
            planting.secondaryPlantPlantingDate = 0;
          },
          child: Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _shakeKeyMinorHavestTextField,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "planting-date-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMinorHavestDate(String textHint) {
    TextField _dateTextField = TextField(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));
        if (date != null) {
          planting.secondaryPlantHarvestDate = date.millisecondsSinceEpoch;

          minorHavestDateController.text =
              DateFormat("dd-MM-yyyy").format(date);
        }
      },
      controller: minorHavestDateController,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            minorHavestDateController.text = "";
            planting.secondaryPlantHarvestDate = 0;
          },
          child: Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _shakeKeyMinorDateTextField,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "havest-date-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryPlant() {
    return Container(
        height: SizeConfig.screenHeight! * 0.57,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: Text("primary-plant-label".i18n(),
                  style: TextStyle(
                      fontSize: sizeHeight(20, context),
                      fontWeight: FontWeight.bold)),
            ),
            Form(
              key: _formKeyPage3,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(sizeHeight(10, context)),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "primary-plant-type-label".i18n(),
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: sizeHeight(20, context)),
                          ),
                        ),
                        SizedBox(
                            height: SizeConfig.screenHeight! * 0.02194644482),
                        // AnimTFF(
                        //   (text) => {
                        //     setState(() {
                        //       planting.primaryPlantType = text;
                        //     }),
                        //   },
                        //   // validator1: (value) =>
                        //   //     InputCodeValidator.validatePlantVariety(
                        //   //         value, planting.besidePlantOther),
                        //   labelText: planting.primaryPlantType == ""
                        //       ? "มันสำปะหลัง"
                        //       : planting.primaryPlantType,
                        //   successText: "",
                        //   readyOnly: true,
                        //   inputIcon: Icon(Icons.grass_sharp),
                        // ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "มันสำปะหลัง",
                            style: TextStyle(
                                color: theme_color,
                                fontFamily: 'OpenSans',
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                            height: SizeConfig.screenHeight! * 0.02194644482),
                        Container(
                          alignment: Alignment.topLeft,
                          // VALIDATE
                          child: Text(
                            "primary-plant-variety-label".i18n() + "*",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                                fontSize: sizeHeight(20, context)),
                          ),
                        ),
                        SizedBox(
                            height: SizeConfig.screenHeight! * 0.02194644482),
                        // Container(
                        //   child: DropdownSearch<String>(
                        //     mode: Mode.DIALOG,
                        //     showSelectedItems: true,
                        //     items: weedingMonthName,
                        //     dropdownSearchDecoration: InputDecoration(
                        //       focusedBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                        //         borderSide: const BorderSide(
                        //           color: theme_color,
                        //         ),
                        //       ),
                        //       enabledBorder: OutlineInputBorder(
                        //         borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                        //         borderSide: const BorderSide(
                        //           color: theme_color4,
                        //           width: sizeWidth(2, context),
                        //         ),
                        //       ),
                        //       hintText: "เลือกชนิดพันธุ์หลัก",
                        //     ),
                        //     popupItemDisabled: isItemDisabled,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         _selectMainPlating = value;
                        //         planting.primaryVarietyOther = value.toString();
                        //         // planting.weedingChemical1 = int.parse(value.toString());
                        //       });
                        //     },
                        //     selectedItem: _selectMainPlating,
                        //     showSearchBox: true,
                        //     searchFieldProps: const TextFieldProps(
                        //       cursorColor: Colors.blue,
                        //       autofillHints: [AutofillHints.name],
                        //       decoration: InputDecoration(
                        //         hintText: 'ค้นหา',
                        //       ),
                        //     ),
                        //     validator: (value) {
                        //       if (value == null || value == "เลือกชนิดพันธุ์หลัก") {
                        //         return 'เลือกชนิดพันธุ์หลัก';
                        //       }
                        //     },
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.all(sizeHeight(16, context)),
                          child: MultiSelectDialogField<String>(
                            selectedItemsTextStyle:
                                TextStyle(color: Colors.white),
                            selectedColor: theme_color2,
                            items: _items.map((String value) {
                              return MultiSelectItem(value, value);
                            }).toList(),
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (List<String> selected) {
                              setState(() {
                                _selectedMainPlanting = selected;
                                //   print("Selected : ${_selectedMainPlanting}");
                              });
                            },
                            initialValue: _selectedMainPlanting,
                            validator: (value) =>
                                InputCodeValidator.validateMultiSelect(value),
                          ),
                        ),

                        SizedBox(
                            height: SizeConfig.screenHeight! * 0.02194644482),
                        _buildMajorCultivationDate("pick-date".i18n()),
                        SizedBox(
                            height: SizeConfig.screenHeight! * 0.02194644482),
                        _buildMajorHavestDate("pick-date".i18n()),
                      ],
                    ),
                  ),
                  //),
                  SizedBox(height: sizeHeight(23.5, context)),
                ],
              ),
            )
          ],
        ));
  }

  void itemSelectionChanged(String? s) {
    //   print(s);
  }

  Widget _buildfertilized() {
    return Container(
        height: SizeConfig.screenHeight! * 0.57,
        child: ListView(
          // controller: _controller1,
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            _dateFertilizer1("pick-date".i18n()),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "filling-soil-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Form(
              // key: _formKeyPage4,
              child: Column(
                children: [
                  AnimTFF(
                    (text) => {
                      setState(() {
                        text = text.trim();
                        planting.fertilizerFormular1 = text;
                      }),
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateFertilizerFormular(
                            value, planting.fertilizerFormular1),
                    labelText: planting.fertilizerFormular1 == ""
                        ? "insert-fertilizer-used".i18n()
                        : planting.fertilizerFormular1,
                    successText: "",
                    inputIcon: Icon(Icons.landscape_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  _dateFertilizer2("pick-date".i18n()),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "filling-soil-label".i18n(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        text = text.trim();
                        planting.fertilizerFormular2 = text;
                      }),
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateFertilizerFormular(
                            value, planting.fertilizerFormular2),
                    labelText: planting.fertilizerFormular2 == ""
                        ? "insert-fertilizer-used".i18n()
                        : planting.fertilizerFormular2,
                    successText: "",
                    inputIcon: Icon(Icons.landscape_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  _dateFertilizer3("pick-date".i18n()),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "filling-soil-label".i18n(),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: sizeHeight(20, context)),
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                  AnimTFF(
                    (text) => {
                      setState(() {
                        text = text.trim();
                        planting.fertilizerFormular3 = text;
                      }),
                    },
                    validator1: (value) =>
                        InputCodeValidator.validateFertilizerFormular(
                            value, planting.fertilizerFormular3),
                    labelText: planting.fertilizerFormular3 == ""
                        ? "insert-fertilizer-used".i18n()
                        : planting.fertilizerFormular3,
                    successText: "",
                    inputIcon: Icon(Icons.landscape_sharp),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                ],
              ),
            ),
            Container(
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: Text("weeding-label".i18n(),
                  style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "month-of-weeding-1-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              child: DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSelectedItems: true,
                items: weedingMonthName,
                dropdownSearchDecoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                    borderSide: const BorderSide(
                      color: theme_color,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                    borderSide: BorderSide(
                      color: theme_color4,
                      width: sizeWidth(2, context),
                    ),
                  ),
                  hintText: "select-weeding-month".i18n(),
                ),
                popupItemDisabled: isItemDisabled,
                onChanged: (value) {
                  setState(() {
                    _selectWeedingMonth1 = value;
                    if (value == "ไม่เลือก") {
                      value = "0";
                    }
                    planting.weedingMonth1 = int.parse(value.toString());
                    // planting.weedingChemical1 = int.parse(value.toString());
                  });
                },
                selectedItem: _selectWeedingMonth1,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Colors.blue,
                  autofillHints: [AutofillHints.name],
                  decoration: InputDecoration(
                    hintText: 'search'.i18n(),
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return "select-weeding-month".i18n();
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "chemicals-used-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            DropdownSearch<String>(
              mode: Mode.DIALOG,
              showSelectedItems: true,
              items: weedingChemicalName,
              dropdownSearchDecoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                  borderSide: const BorderSide(
                    color: theme_color,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                  borderSide: BorderSide(
                    color: theme_color4,
                    width: sizeWidth(2, context),
                  ),
                ),
                hintText: "เลือกสารเคมี",
              ),
              popupItemDisabled: isItemDisabled,
              onChanged: (value) {
                setState(() {
                  _selectChemical1 = value;
                  //   print(_selectChemical1);
                  planting.herbicideByWeedingChemical1 = returnIndexFromList(
                      weedingChemicalName, value.toString());
                  if (planting.herbicideByWeedingChemical1 == 9) {
                    planting.herbicideByWeedingChemical1 = -1;
                  }
                  if (_isPassValueFromPage) {
                    planting.herbicideByWeedingChemical1 =
                        planting.herbicideByWeedingChemical1 + 1;
                  }
                });
              },
              selectedItem: _selectChemical1,
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                cursorColor: Colors.blue,
                autofillHints: [AutofillHints.name],
                decoration: InputDecoration(
                  hintText: 'search'.i18n(),
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'เลือกสารเคมี';
                }
              },
            ),
            _selectChemical1 == "อื่นๆ"
                ? Column(
                    children: [
                      SizedBox(
                          height: SizeConfig.screenHeight! * 0.02194644482),
                      AnimTFF(
                        (text) => {
                          setState(() {
                            text = text.trim();
                            planting.weedingChemicalOther1 = text;
                          }),
                        },
                        // validator1: (value) =>
                        //     InputCodeValidator.validateFertilizerFormular(
                        //         value, planting.fertilizerFormular2),
                        labelText: planting.weedingChemicalOther1 == ""
                            ? "insert-chemical-used".i18n()
                            : planting.weedingChemicalOther1,
                        successText: "",
                        inputIcon: Icon(Icons.science_outlined),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "month-of-weeding-2-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              child: DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSelectedItems: true,
                items: weedingMonthName,
                dropdownSearchDecoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                    borderSide: const BorderSide(
                      color: theme_color,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                    borderSide: BorderSide(
                      color: theme_color4,
                      width: sizeWidth(2, context),
                    ),
                  ),
                  hintText: "select-weeding-month".i18n(),
                ),
                popupItemDisabled: isItemDisabled,
                onChanged: (value) {
                  setState(() {
                    _selectWeedingMonth2 = value;
                    if (value == "ไม่เลือก") {
                      value = "0";
                    }
                    planting.weedingMonth2 = int.parse(value.toString());
                    // planting.weedingChemical1 = int.parse(value.toString());
                  });
                },
                selectedItem: _selectWeedingMonth2,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Colors.blue,
                  autofillHints: [AutofillHints.name],
                  decoration: InputDecoration(
                    hintText: 'search'.i18n(),
                  ),
                ),
                validator: (value) {
                  if (value == null) {
                    return "select-weeding-month".i18n();
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "chemicals-used-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            DropdownSearch<String>(
              mode: Mode.DIALOG,
              showSelectedItems: true,
              items: weedingChemicalName,
              dropdownSearchDecoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                  borderSide: const BorderSide(
                    color: theme_color,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                  borderSide: BorderSide(
                    color: theme_color4,
                    width: sizeWidth(2, context),
                  ),
                ),
                hintText: "เลือกสารเคมี",
              ),
              popupItemDisabled: isItemDisabled,
              onChanged: (value) {
                setState(() {
                  _selectChemical2 = value;

                  planting.herbicideByWeedingChemical2 = returnIndexFromList(
                      weedingChemicalName, value.toString());
                  if (planting.herbicideByWeedingChemical2 == 9) {
                    planting.herbicideByWeedingChemical2 = -1;
                  }
                  if (_isPassValueFromPage) {
                    planting.herbicideByWeedingChemical2 =
                        planting.herbicideByWeedingChemical2 + 1;
                  }
                });
              },
              selectedItem: _selectChemical2,
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                cursorColor: Colors.blue,
                autofillHints: [AutofillHints.name],
                decoration: InputDecoration(
                  hintText: 'search'.i18n(),
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'เลือกสารเคมี';
                }
              },
            ),
            _selectChemical2 == "อื่นๆ"
                ? Column(
                    children: [
                      SizedBox(
                          height: SizeConfig.screenHeight! * 0.02194644482),
                      AnimTFF(
                        (text) => {
                          setState(() {
                            text = text.trim();
                            planting.weedingChemicalOther2 = text;
                          }),
                        },
                        // validator1: (value) =>
                        //     InputCodeValidator.validateFertilizerFormular(
                        //         value, planting.fertilizerFormular2),
                        labelText: planting.weedingChemicalOther2 == ""
                            ? "insert-chemical-used".i18n()
                            : planting.weedingChemicalOther2,
                        successText: "",
                        inputIcon: Icon(Icons.science_outlined),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "month-of-weeding-3-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              child: DropdownSearch<String>(
                mode: Mode.DIALOG,
                showSelectedItems: true,
                items: weedingMonthName,
                dropdownSearchDecoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                    borderSide: const BorderSide(
                      color: theme_color,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                    borderSide: BorderSide(
                      color: theme_color4,
                      width: sizeWidth(2, context),
                    ),
                  ),
                  hintText: "select-weeding-month".i18n(),
                ),
                popupItemDisabled: isItemDisabled,
                onChanged: (value) {
                  setState(() {
                    _selectWeedingMonth3 = value;
                    if (value == "ไม่เลือก") {
                      value = "0";
                    }
                    planting.weedingMonth3 = int.parse(value.toString());
                    // planting.weedingChemical1 = int.parse(value.toString());
                  });
                },
                selectedItem: _selectWeedingMonth3,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Colors.blue,
                  autofillHints: [AutofillHints.name],
                  decoration: InputDecoration(hintText: 'search'.i18n()),
                ),
                validator: (value) {
                  if (value == null) {
                    return "select-weeding-month".i18n();
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "chemicals-used-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            DropdownSearch<String>(
              mode: Mode.DIALOG,
              showSelectedItems: true,
              items: weedingChemicalName,
              dropdownSearchDecoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                  borderSide: const BorderSide(
                    color: theme_color,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(sizeWidth(20, context)),
                  borderSide: BorderSide(
                    color: theme_color4,
                    width: sizeWidth(2, context),
                  ),
                ),
                hintText: "เลือกสารเคมี",
              ),
              popupItemDisabled: isItemDisabled,
              onChanged: (value) {
                setState(() {
                  _selectChemical3 = value;

                  planting.herbicideByWeedingChemical3 = returnIndexFromList(
                      weedingChemicalName, value.toString());
                  if (planting.herbicideByWeedingChemical3 == 9) {
                    planting.herbicideByWeedingChemical3 = -1;
                  }
                  if (_isPassValueFromPage) {
                    planting.herbicideByWeedingChemical3 =
                        planting.herbicideByWeedingChemical3 + 1;
                  }
                });
              },
              selectedItem: _selectChemical3,
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                cursorColor: Colors.blue,
                autofillHints: [AutofillHints.name],
                decoration: InputDecoration(
                  hintText: 'search'.i18n(),
                ),
              ),
              validator: (value) {
                if (value == null) {
                  return 'เลือกสารเคมี';
                }
              },
            ),
            _selectChemical3 == "อื่นๆ"
                ? Column(
                    children: [
                      SizedBox(
                          height: SizeConfig.screenHeight! * 0.02194644482),
                      AnimTFF(
                        (text) => {
                          setState(() {
                            text = text.trim();
                            planting.weedingChemicalOther3 = text;
                          }),
                        },
                        // validator1: (value) =>
                        //     InputCodeValidator.validateFertilizerFormular(
                        //         value, planting.fertilizerFormular2),
                        labelText: planting.weedingChemicalOther3 == ""
                            ? "insert-chemical-used".i18n()
                            : planting.weedingChemicalOther3,
                        successText: "",
                        inputIcon: Icon(Icons.science_outlined),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                "note-label".i18n(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: sizeHeight(20, context)),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            AnimTFF(
              (text) => {
                setState(() {
                  text = text.trim();
                  planting.note = text;
                }),
              },
              labelText:
                  planting.note == "" ? "note-label".i18n() : planting.note,
              successText: "",
              inputIcon: Icon(Icons.event_note_sharp),
            ),
          ],
        ));
  }

  late final DateTime dateStore;
  Widget _dateFertilizer1(String textHint) {
    TextField _dateTextField = TextField(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));
        if (date != null) {
          planting.fertilizerDate1 = date.millisecondsSinceEpoch;
          _conDateFertilizer1.text = DateFormat("dd-MM-yyyy").format(date);
          dateStore = date;
        }
      },
      controller: _conDateFertilizer1,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
        suffixIcon: GestureDetector(
          onTap: () {
            _conDateFertilizer1.text = "";
            planting.fertilizerDate1 = 0;
          },
          child: Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _keyDateFertilizer1,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: SizeConfig.screenWidth,
              alignment: Alignment.center,
              child: Text("filling-label".i18n(),
                  style: TextStyle(
                      fontSize: sizeHeight(20, context),
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
            Text(
              "filling-temp-1-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateFertilizer2(String textHint) {
    TextField _dateTextField = TextField(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));
        if (date != null) {
          planting.fertilizerDate2 = date.millisecondsSinceEpoch;

          _conDateFertilizer2.text = DateFormat("dd-MM-yyyy").format(date);
        }
      },
      controller: _conDateFertilizer2,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
        suffixIcon: GestureDetector(
          onTap: () {
            _conDateFertilizer2.text = "";
            planting.fertilizerDate2 = 0;
          },
          child: Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _keyDateFertilizer2,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "filling-temp-2-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateFertilizer3(String textHint) {
    TextField _dateTextField = TextField(
      onTap: () async {
        FocusScope.of(context).requestFocus(new FocusNode());

        DateTime? date = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100)));
        if (date != null) {
          planting.fertilizerDate3 = date.millisecondsSinceEpoch;

          _conDateFertilizer3.text = DateFormat("dd-MM-yyyy").format(date);
        }
      },
      controller: _conDateFertilizer3,
      onChanged: (e) => _surveyTFToggle(e),
      keyboardType: TextInputType.datetime,
      style: TextStyle(
          color: theme_color4,
          fontFamily: 'OpenSans',
          fontSize: sizeHeight(16, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.black,
        ),
        hintText: textHint,
        hintStyle: kHintTextStyle,
        suffixIcon: GestureDetector(
          onTap: () {
            _conDateFertilizer3.text = "";
            planting.fertilizerDate3 = 0;
          },
          child: Icon(
            Icons.clear_rounded,
            color: Colors.black,
          ),
        ),
      ),
    );
    return Container(
      child: ShakeWidget(
        key: _keyDateFertilizer3,
        shakeCount: 3,
        shakeOffset: 10,
        shakeDuration: Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "filling-temp-3-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.01463096321),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: SizeConfig.screenHeight! * 0.08778577928,
              child: _dateTextField,
            ),
          ],
        ),
      ),
    );
  }

  int returnIndexFromList(List<String> input, String value) {
    for (int i = 0; i < input.length; i++) {
      if (value == input[i]) {
        return i;
      }
    }
    //   print("value select not found ");
    return 0;
  }

  Widget _buildSecondaryPlant() {
    return Container(
      height: SizeConfig.screenHeight! * 0.55,
      child: ListView(
        // controller: _controller1,
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("secondary-plant-label".i18n(),
                style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "secondary-plant-type-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          AnimTFF(
            (text) => {
              setState(() {
                text = text.trim();
                planting.secondaryPlantType = text;
              }),
            },
            validator1: (value) =>
                InputCodeValidator.validatePlantSecondaryType(
                    value, planting.secondaryPlantType),
            labelText: planting.secondaryPlantType == ""
                ? "insert-secondary-plant".i18n()
                : planting.secondaryPlantType,
            successText: "",
            inputIcon: Icon(Icons.eco_sharp),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              "secondary-plant-variety-label".i18n(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                  fontSize: sizeHeight(20, context)),
            ),
          ),
          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          AnimTFF(
            (text) => {
              setState(() {
                text = text.trim();
                planting.secondaryPlantVariety = text;
              }),
            },
            validator1: (value) => InputCodeValidator.validatePlantVariety(
                value, planting.secondaryPlantType),
            labelText: planting.secondaryPlantVariety == ""
                ? "insert-secondary-species".i18n()
                : planting.secondaryPlantVariety,
            successText: "",
            inputIcon: Icon(Icons.eco_sharp),
          ),

          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          _buildMinorCultivationDate("pick-date".i18n()),
          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          _buildMinorHavestDate("pick-date".i18n()),
          SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
          // _buildSurveyDate(),
        ],
      ),
    );
  }

  Widget _buildSelectedField(Dropdownfield dropdownfield) {
    List<String> dropdownForShow = dropdownfield.fieldString;
    dropdownForShow.add("other".i18n());

    return Column(
      children: [
        Form(
          key: _formKeyPage1,
          autovalidateMode: autovidateDisable,
          child: Column(
            children: [
              Container(
                child: dropdownfield.items.length == 0
                    ? Container(
                        child: Text("No Data"),
                      )
                    : Container(
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
                                      "selected-field".i18n() +
                                          " ${fieldNameByPassingValue}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: sizeHeight(14, context)),
                                    ),
                                  ),
                                  Container(
                                    child: ExpansionTile(
                                      subtitle: Text(
                                          selectedfieldOwner +
                                              ", " +
                                              selectedfieldName +
                                              ", " +
                                              selectedfieldLocation,
                                          style: TextStyle(
                                              fontSize: sizeHeight(14, context),
                                              color: Colors.grey
                                                  .withOpacity(0.8))),
                                      title: buildTitle(
                                          "field-more-detail-label".i18n(),
                                          " ${fieldNameByPassingValue}"),
                                      children: [
                                        ListTile(
                                            visualDensity: VisualDensity(
                                                horizontal: 0, vertical: -4),
                                            title: Text(
                                              selectedfieldOwner +
                                                  " : ${ownerFieldByPassingValue}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      sizeHeight(18, context)),
                                            )),
                                        ListTile(
                                            visualDensity: VisualDensity(
                                                horizontal: 0, vertical: -4),
                                            title: Text(
                                              selectedfieldName +
                                                  " : ${fieldNameByPassingValue}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      sizeHeight(18, context)),
                                            )),
                                        ListTile(
                                            visualDensity: VisualDensity(
                                                horizontal: 0, vertical: -4),
                                            title: Text(
                                              selectedfieldLocation +
                                                  " :  ${locationByPassingValue}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      sizeHeight(18, context)),
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
                                  hintText: 'please-select-field'.i18n(),
                                  hintStyle: TextStyle(
                                    fontSize: sizeHeight(20, context),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: sizeHeight(10, context),
                                    horizontal: sizeWidth(12, context),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                ),
                                value: selectedValue,
                                onChanged: (value) {
                                  if (value == "other".i18n()) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Provider(
                                          create: (context) => dropdownfield,
                                          builder: (context, child) =>
                                              DropdownForField(
                                            (value) {
                                              //   print(value);
                                              bool duplicate = false;
                                              List<String> temp =
                                                  dropdownfield.fieldString;
                                              for (int i = 0;
                                                  i < temp.length;
                                                  i++) {
                                                if (value['nameField'] ==
                                                    temp[i]) {
                                                  duplicate = true;
                                                  break;
                                                }
                                              }
                                              if (!duplicate) {
                                                dropdownfield.addItem(
                                                    value['nameField']);
                                              }
                                              setState(() {
                                                selectedValue =
                                                    value['nameField'];
                                                selectedField =
                                                    value['id'].toString();
                                                isSelectedField = true;
                                                fieldIdFromDropdown =
                                                    value['id'];
                                                //   print("fieldIdFromDropdown : ${fieldIdFromDropdown}");
                                                dropdownfield
                                                    .getFieldAndUserAndLocationByfieldId(
                                                        fieldIdFromDropdown);
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    //   print(value);
                                    int id = 0;
                                    for (int i = 0;
                                        i < dropdownfield.items.length;
                                        i++) {
                                      if (dropdownfield.items[i].name ==
                                          value) {
                                        id = dropdownfield.items[i].id;
                                        break;
                                      }
                                    }
                                    setState(() {
                                      selectedValue = value.toString();
                                      isSelectedField = true;
                                      fieldIdFromDropdown = id;
                                      selectedField = id.toString();
                                      //   print("fieldIdFromDropdown : ${fieldIdFromDropdown}");
                                      dropdownfield
                                          .getFieldAndUserAndLocationByfieldId(
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
                                                  'name-field-label'.i18n() +
                                                      " ",
                                                  style: TextStyle(
                                                    fontSize:
                                                        sizeHeight(18, context),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    e,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.fade,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: sizeHeight(
                                                            18, context),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.italic),
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
                                                  'selected-field'.i18n() +
                                                      " : ${e}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        sizeHeight(18, context),
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
              isSelectedField
                  ? Column(
                      children: [
                        Container(
                          child: ExpansionTile(
                            subtitle: Text(
                                selectedfieldOwner +
                                    ", " +
                                    selectedfieldName +
                                    ", " +
                                    selectedfieldLocation,
                                style: TextStyle(
                                    fontSize: sizeHeight(14, context),
                                    color: Colors.grey.withOpacity(0.8))),
                            title: buildTitle("field-more-detail-label".i18n(),
                                " ${dropdownfield.field?.name}"),
                            children: [
                              ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    selectedfieldOwner +
                                        " : ${dropdownfield.user?.title} ${dropdownfield.user?.firstName} ${dropdownfield.user?.lastName}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sizeHeight(18, context)),
                                  )),
                              ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    selectedfieldName +
                                        " : ${dropdownfield.field?.name}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: sizeHeight(18, context)),
                                  )),
                              ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                  title: Text(
                                    selectedfieldLocation +
                                        " :  ${dropdownfield.location}",
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
              SizedBox(height: sizeHeight(23.5, context)),
              Container(
                alignment: Alignment.topLeft,
                // VALIDATE
                child: Text(
                  "code-planting-label".i18n() + "*",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: sizeHeight(20, context)),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
              AnimTFF(
                (text) => {
                  setState(() {
                    errorText['code'] = null;
                    //   print("resset");
                    text = text.trim();
                    planting.code = text;
                  }),
                  if (text.isEmpty || (text == null) || (text == ""))
                    {planting.code = save_plantingCode}
                },
                errorText: errorText['code'],
                validator1: (value) =>
                    InputCodeValidator.validateNotSpecialCharacter(
                        value, planting.code),
                labelText: planting.code == ""
                    ? "insert-planting-code".i18n()
                    : planting.code,
                successText: "",
                inputIcon: Icon(Icons.code_sharp),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
              Container(
                alignment: Alignment.topLeft,
                // VALIDATE
                child: Text(
                  "name-planting-label".i18n() + "*",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'OpenSans',
                      fontSize: sizeHeight(20, context)),
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
              AnimTFF(
                (text) => {
                  setState(() {
                    text = text.trim();
                    planting.name = text;
                  }),
                  if (text.isEmpty || (text == null) || (text == ""))
                    {planting.name = save_plantingName}
                },
                validator1: (value) =>
                    InputCodeValidator.validateNotSpecialCharacter(
                        value, planting.name),
                labelText: planting.name == ""
                    ? "insert-planting-name".i18n()
                    : planting.name,
                successText: "",
                inputIcon: Icon(Icons.eco_sharp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailPlant() {
    return Container(
      height: SizeConfig.screenHeight! * 0.57,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: SizeConfig.screenWidth,
            alignment: Alignment.center,
            child: Text("detail-cultivation-label".i18n(),
                style: TextStyle(
                    fontSize: sizeHeight(20, context),
                    fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: sizeHeight(23.5, context)),
          Form(
            key: _formKeyPage5,
            autovalidateMode: autovidateDisable,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "stem-source-label".i18n() + "*",
                    style: TextStyle(
                        color: _userNameColor,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                Container(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FormField<int>(
                        validator: (value) =>
                            InputCodeValidator.validateMyRadioListTile(
                                value, _selectStemSource),
                        builder: (FormFieldState<int> state) {
                          return Column(
                            children: [
                              MyRadioListTile<int>(
                                value: 1,
                                groupValue: _selectStemSource,
                                leading: _selectStemSource == 1 ? '/' : 'x',
                                title: Text('${stemSourceName[0]}',
                                    style: TextStyle(
                                        fontSize: sizeHeight(20, context))),
                                onChanged: (value) {
                                  //   print("MyRadioListTile : ${value}");
                                  setState(() => {
                                        if (value != null)
                                          {
                                            _selectStemSource = value,
                                            state.didChange(value),
                                            if (_selectStemSource != 0)
                                              {
                                                planting.stemSource =
                                                    stemSourceName[
                                                        _selectStemSource - 1]
                                              }
                                          }
                                      });
                                },
                              ),
                              MyRadioListTile<int>(
                                value: 2,
                                groupValue: _selectStemSource,
                                leading: _selectStemSource == 2 ? '/' : 'x',
                                title: Text('${stemSourceName[1]}',
                                    style: TextStyle(
                                        fontSize: sizeHeight(20, context))),
                                onChanged: (value) {
                                  //   print("MyRadioListTile : ${value}");
                                  setState(() => {
                                        if (value != null)
                                          {
                                            _selectStemSource = value,
                                            state.didChange(value),
                                            if (_selectStemSource != 0)
                                              {
                                                planting.stemSource =
                                                    stemSourceName[
                                                        _selectStemSource - 1]
                                              }
                                          }
                                      });
                                },
                              ),
                              if (state.hasError && _selectStemSource == 0)
                                Text(
                                  state.errorText!,
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          );
                        },
                        // validator: (value) {
                        //   //   print("Check value : ");
                        //   //   print(value);
                        //   if (value == null) {
                        //     return 'กรุณาเลือกข้อมูลที่ต้องการ';
                        //   }
                        //   return null;
                        // },
                        onSaved: (value) {
                          setState(
                            () {
                              _selectStemSource = value!;
                              if (_selectStemSource != 0) {
                                planting.stemSource =
                                    stemSourceName[_selectStemSource - 1];
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "soaking-stem-chemical-label".i18n() + "*",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: soakingStemChemicalName,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color4,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "สารเคมีกำจัดแมลง",
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      _selectSoakingStemChemical = value;
                      planting.soakingStemChemical = value.toString();
                    });
                  },
                  selectedItem: planting.soakingStemChemical == ""
                      ? _selectSoakingStemChemical
                      : planting.soakingStemChemical,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                  validator: (value) => InputCodeValidator.validateDropDown(
                      value, "select-chem-kill-insects".i18n()),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),

                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "number-tillage-label".i18n() + "*",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: numTillageName,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color4,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "number-tillage-label".i18n(),
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      _selectNumTillage = value;
                      planting.numTillage = value.toString();
                    });
                  },
                  selectedItem: planting.numTillage == ""
                      ? _selectNumTillage
                      : planting.numTillage,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                  validator: (value) => InputCodeValidator.validateDropDown(
                      value, "select-number-plow".i18n()),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "soil-amendments-label".i18n() + "*",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: soilAmendmentsName,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color4,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "number-tillage-label".i18n(),
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      _selectSoilAmendments = value;
                      planting.soilAmendments = value.toString();
                    });
                  },
                  selectedItem: planting.soilAmendments == ""
                      ? _selectSoilAmendments
                      : planting.soilAmendments,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                  validator: (value) => InputCodeValidator.validateDropDown(
                      value, "select-soil-amendments".i18n()),
                ),
                _selectSoilAmendments == "อื่นๆ"
                    ? Column(
                        children: [
                          SizedBox(
                              height: SizeConfig.screenHeight! * 0.02194644482),
                          AnimTFF(
                            (text) => {
                              setState(() {
                                text = text.trim();
                                planting.soilAmendmentsOther = text;
                              }),
                            },
                            validator1: (value) =>
                                InputCodeValidator.validateNotSpecialCharacter(
                                    value,
                                    planting.soilAmendmentsOther.toString()),
                            labelText: planting.soilAmendmentsOther == ""
                                ? 'insert-other-soil-amendments'.i18n()
                                : planting.soilAmendmentsOther,
                            successText: "",
                            inputIcon: Icon(Icons.landscape_sharp),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                // กำจัดแมลง
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "disease-management-label".i18n(),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: diseaseManagement,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color4,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "วิธีการจัดการโรค",
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      _selectDisManangement = value;
                      if (value == "ไม่เลือก") {
                        value = "";
                      }

                      planting.diseaseManagement = value.toString();
                    });
                  },
                  selectedItem: _selectDisManangement,

                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'เลือกวิธีการจัดการโรค';
                  //   }
                  // },
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "pest-management-label".i18n(),
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        fontSize: sizeHeight(20, context)),
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02194644482),
                DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSelectedItems: true,
                  items: pestManagementName,
                  dropdownSearchDecoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: const BorderSide(
                        color: theme_color,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(sizeWidth(20, context)),
                      borderSide: BorderSide(
                        color: theme_color4,
                        width: sizeWidth(2, context),
                      ),
                    ),
                    hintText: "วิธีการจัดการแมลง",
                  ),
                  popupItemDisabled: isItemDisabled,
                  onChanged: (value) {
                    setState(() {
                      _selectPestManagement = value;
                      if (value == "ไม่เลือก") {
                        value = "";
                      }
                      planting.pestManagement = value.toString();
                    });
                  },
                  selectedItem: _selectPestManagement,
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    cursorColor: Colors.blue,
                    autofillHints: [AutofillHints.name],
                    decoration: InputDecoration(
                      hintText: 'search'.i18n(),
                    ),
                  ),
                ),

                SizedBox(height: sizeHeight(23.5, context)),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Dropdownfield>(create: (BuildContext context) {
            return Dropdownfield();
          }),
        ],
        child:
            Consumer<Dropdownfield>(builder: (context, dropdownfield, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(sizeHeight(67, context)),
              child: getAppBarUI(),
            ),
            body: _isLoading
                ? Container()
                : Container(
                    padding: EdgeInsets.all(sizeHeight(12, context)),
                    child: Container(
                      height: SizeConfig.screenHeight,
                      child: Theme(
                          data: ThemeData(
                            canvasColor: Color.fromARGB(255, 255, 255, 255),
                            colorScheme: Theme.of(context).colorScheme.copyWith(
                                  primary: theme_color4,
                                  background: Colors.red,
                                  secondary: Colors.green,
                                ),
                          ),
                          child: Container(
                            width: sizeWidth(SizeConfig.screenWidth!, context),
                            height:
                                sizeHeight(SizeConfig.screenHeight!, context),
                            child: SizedBox(
                              width: sizeWidth(100, context),
                              height: sizeHeight(100, context),
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
                                                fontSize:
                                                    sizeHeight(16, context)),
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
                                                      'confirm-edit-label'
                                                          .i18n(),
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
                                                      fontSize: sizeHeight(
                                                          16, context)),
                                                ),
                                          onPressed: isFinal()
                                              ? submitFunction
                                              : continued,
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
                                        _buildSelectedField(dropdownfield),
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.025),
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
                                    content: Column(
                                      children: <Widget>[
                                        _buildCultivationInfo(),
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.025),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 1
                                        ? StepState.complete
                                        : StepState.disabled,
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
                                        _buildPrimaryPlant(),
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.025),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 2
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: GestureDetector(
                                      child: Text(""),
                                      onTap: () {
                                        setState(() {
                                          _currentStep = 3;
                                        });
                                      },
                                    ),
                                    content: Column(
                                      children: <Widget>[
                                        _buildSecondaryPlant(),
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.025),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 3
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: GestureDetector(
                                      child: Text(""),
                                      onTap: () {
                                        setState(() {
                                          _currentStep = 4;
                                        });
                                      },
                                    ),
                                    content: Column(
                                      children: <Widget>[
                                        _buildDetailPlant(),
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.025),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 4
                                        ? StepState.complete
                                        : StepState.disabled,
                                  ),
                                  Step(
                                    title: GestureDetector(
                                      child: Text(""),
                                      onTap: () {
                                        setState(() {
                                          _currentStep = 5;
                                        });
                                      },
                                    ),
                                    content: Column(
                                      children: <Widget>[
                                        //_buildCultivationInfo(),
                                        //_buildSurveyDate(),
                                        _buildfertilized(),
                                        SizedBox(
                                            height: SizeConfig.screenHeight! *
                                                0.025),
                                        //_buildPlantPeriod(),
                                      ],
                                    ),
                                    isActive: _currentStep >= 0,
                                    state: _currentStep >= 5
                                        ? StepState.complete
                                        : StepState.disabled,
                                  )
                                ],
                              ),
                            ),
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
              blurRadius: sizeWidth(8, context)),
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
                    Radius.circular(sizeWidth(32.0, context)),
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
                  _isLoading
                      ? ""
                      : _isPassValueFromPage
                          ? "update-planting-label".i18n()
                          : "create-planting-label".i18n(),
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
}
