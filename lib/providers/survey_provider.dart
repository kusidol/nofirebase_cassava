import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/surveytarget.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class SurveyData {
  int id;
  String plantingName;
  String fieldName;
  String substrict;
  String district;
  String province;
  String title;
  String firstName;
  String lastName;
  bool checkTarget = false;
  String code;
  Survey survey;
  bool isLoading;
  SurveyData(
      this.id,
      this.plantingName,
      this.fieldName,
      this.substrict,
      this.district,
      this.province,
      this.title,
      this.firstName,
      this.lastName,
      this.checkTarget,
      this.code,
      this.survey,
      this.isLoading);
}

class SurveyProvider with ChangeNotifier {
  bool isHavePlanting = false;
  //List<Survey> surveys = [];
  //List<Planting> plantings = [];
  //List<Field> fields = [];
  //List<String> locations = [];
  //List<User> owner = [];
  //List<Map<String, dynamic>> surveyPointList = [];
  //List<SurveyTargetPoint> surveyTargetPointCount = [];
  bool isLoading = false;
  int _value = 20;
  int _page = 1;
  int _date = DateTime.now().millisecondsSinceEpoch;
  int plantingId = -1;
  String plantingName = "";
  bool isSearch = false;
// New Adding

  List<SurveyData> surveyData = [];

  int numberAllSurveys = 0;

  void reset() {
    isLoading = false;

    //if(!isFetch()){
    surveyData.clear();

    //}

    //notifyListeners();
    _date = DateTime.now().millisecondsSinceEpoch;
    //list_lastName = [];
    _page = 1;
  }

  void resetPlantingID() {
    plantingId = -1;
    plantingName = "";
    // surveyData.clear();
    //notifyListeners();
  }
  /*bool _fetch = false ;

  bool isFetch(){
    return _fetch ;
  }*/

  /*setFetch(bool fetch){
    this._fetch = fetch ;
    //notifyListeners();
  }*/

  int count = -1;

  Future<void> fetchData() async {
    SurveyService surveyService = SurveyService();
    PlantingService plantingService = PlantingService();
    SurveyTargetPointService surveyTargetPointService =
        SurveyTargetPointService();
    String? token = tokenFromLogin?.token;
    //if (count == -1)
    count = await plantingService.countPlantings(token.toString());

    //print(count);

    numberAllSurveys = await surveyService.countSurveys(token.toString());

    if (numberAllSurveys == 0 ||
        numberAllSurveys == surveyData.length ||
        (surveyData.length > 0 && surveyData.last.isLoading)) {
      //setFetch(false);

      if (count > 0) {
        isHavePlanting = true;
      }
      isLoading = true;
      notifyListeners();
      return;
    }

    _value = 20;

    isLoading = false;

    notifyListeners();

    _value = numberAllSurveys < _value ? numberAllSurveys : _value;

    int index = ((_page - 1) * _value);

    String none = "";

    Survey sv = Survey(
        0,
        0,
        0,
        none,
        none,
        0,
        0,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        0,
        0,
        0,
        none,
        0,
        none,
        none,
        0,
        0,
        0,
        0,
        none,
        none,
        none);

    int dummySize = surveyData.length + _value < numberAllSurveys
        ? _value
        : numberAllSurveys - surveyData.length;

    //print("Dummy ${dummySize}");
    for (int i = 0; i < dummySize; i++) {
      surveyData.add(SurveyData(0, none, none, none, none, none, none, none,
          none, false, none, sv, true));
    }

    notifyListeners();

    await surveyService
        .getSurveysWithPlantingAndLocationAndOwner(
            token.toString(), _page, _value)
        .then((value) async {
      if (value != null) {
        for (Map<String, dynamic> data in value) {
          bool checkTarget = await surveyTargetPointService
              .checkSurveyTargetBySurveyId(token.toString(), data['surveyId']);

          Survey survey = await surveyService.getSurveyByID(
              token.toString(), data['surveyId']) as Survey;

          if (surveyData.isEmpty) return;

          surveyData[index].id = data['surveyId'];
          surveyData[index].plantingName = data['plantingName'];
          surveyData[index].fieldName = data['fieldName'];
          surveyData[index].substrict = data['substrict'];
          surveyData[index].district = data['district'];
          surveyData[index].province = data['province'];
          surveyData[index].title = data['title'];
          surveyData[index].firstName = data['firstName'];
          surveyData[index].lastName = data['lastName'];
          surveyData[index].checkTarget = checkTarget;
          surveyData[index].code = data['code'];
          surveyData[index].survey = survey;
          surveyData[index].isLoading = false;

          notifyListeners();

          new Future.delayed(const Duration(seconds: 2), () {});

          index++;
        }
        _page = (surveyData.length ~/ _value) + 1;

        // setFetch(false);
      }
    });

    if (count > 0) {
      isHavePlanting = true;
    }

    isLoading = true;

    //print("${index}    ${surveyData.length}");
    notifyListeners();
  }

  Future<void> fetchDataFromPlanting() async {
    SurveyService surveyService = SurveyService();

    PlantingService plantingService = PlantingService();

    SurveyTargetPointService surveyTargetPointService =
        SurveyTargetPointService();

    String? token = tokenFromLogin?.token;

    int count = await plantingService.countPlantings(token.toString());

    numberAllSurveys = await surveyService.countSurveysByPlantingId(
        token.toString(), plantingId);

    if (numberAllSurveys == 0 || numberAllSurveys == surveyData.length) {
      //setFetch(false);
      notifyListeners();
      return;
    }

    _value = 20;

    isLoading = false;

    notifyListeners();

    _value = numberAllSurveys < _value ? numberAllSurveys : _value;

    int index = ((_page - 1) * _value);

    String none = "";

    Survey sv = Survey(
        0,
        0,
        0,
        none,
        none,
        0,
        0,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        0,
        0,
        0,
        none,
        0,
        none,
        none,
        0,
        0,
        0,
        0,
        none,
        none,
        none);

    for (int i = 0; i < _value; i++) {
      surveyData.add(SurveyData(0, none, none, none, none, none, none, none,
          none, false, none, sv, true));
    }

    await surveyService
        .getSurveyByPlantingID(token.toString(), plantingId, _page, _value)
        .then((value) async {
      for (Map<String, dynamic> data in value) {
        bool checkTarget = await surveyTargetPointService
            .checkSurveyTargetBySurveyId(token.toString(), data['surveyId']);

        Survey survey = await surveyService.getSurveyByID(
            token.toString(), data['surveyId']) as Survey;

        if (surveyData.isEmpty) return;

        surveyData[index].id = data['surveyId'];
        surveyData[index].plantingName = data['plantingName'];
        surveyData[index].fieldName = data['fieldName'];
        surveyData[index].substrict = data['substrict'];
        surveyData[index].district = data['district'];
        surveyData[index].province = data['province'];
        surveyData[index].title = data['title'];
        surveyData[index].firstName = data['firstName'];
        surveyData[index].lastName = data['lastName'];
        surveyData[index].checkTarget = checkTarget;
        surveyData[index].code = data['code'];
        surveyData[index].survey = survey;
        surveyData[index].isLoading = false;

        notifyListeners();

        new Future.delayed(const Duration(seconds: 2), () {});

        index++;
      }

      _page = (surveyData.length ~/ _value) + 1;
      //setFetch(false);
    });

    isLoading = true;
    if (count == 0) {
      isHavePlanting = false;
    } else {
      isHavePlanting = true;
    }
    notifyListeners();
  }

  Future<void> _doSearch(List<Map<String, dynamic>> surveys, index) async {
    String? token = tokenFromLogin?.token;
    SurveyTargetPointService surveyTargetPointService =
        SurveyTargetPointService();

    PlantingService plantingService = PlantingService();
    FieldService fieldService = FieldService();
    UserService userService = UserService();
    SurveyService surveyService = SurveyService();
    numberAllSurveys = surveys.length;

    String none = "";
    Survey sv = Survey(
        0,
        0,
        0,
        none,
        none,
        0,
        0,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        none,
        0,
        0,
        0,
        none,
        0,
        none,
        none,
        0,
        0,
        0,
        0,
        none,
        none,
        none);

    for (int i = 0; i < numberAllSurveys; i++) {
      surveyData.add(SurveyData(0, none, none, none, none, none, none, none,
          none, false, none, sv, true));
    }

    for (Map<String, dynamic> data in surveys) {
      //for (int i = 0; i < surveys.length; i++) {
      //print("==========${surveys[i].date}========");

      bool checkTarget = await surveyTargetPointService
          .checkSurveyTargetBySurveyId(token.toString(), data['surveyId']);
      //Planting planting = await plantingService.getPlantingFromSurveyID(
      //   survey['surveyId'], token.toString()) as Planting;

      Survey s = await surveyService.getSurveyByID(
          token.toString(), data['surveyId']) as Survey;
      //Field field = await fieldService.getFieldByPlantingID(planting.plantingId, token.toString()) as Field;

      //String location = await fieldService.getLocationByFielID(field.fieldID, token.toString()) as String;
      //String subDis = "",district = "", province = "";
      /*if(location != null){
        List<String> parts =  location.split(",");
        subDis =parts[1] ;
        district= parts[0];
        province = parts[2];
      }*/

      //User user = await userService.getUserByFieldID(field.fieldID, token.toString()) as User;
      /*if(user == null){
        user = User(
            -1,
            "undefined",
            "undefined",
            "undefined",
            "undefined",
            "undefined",
            UserStatus.invalid,
            0,
            RequestInfoStatus.No) ;
      }*/
      if (surveyData.isEmpty) return;

      surveyData[index].id = data['surveyId'];
      surveyData[index].plantingName = data['plantingName'];
      surveyData[index].fieldName = data['fieldName'];
      surveyData[index].substrict = data['substrict'];
      surveyData[index].district = data['district'];
      surveyData[index].province = data['province'];
      surveyData[index].title = data['title'];
      surveyData[index].firstName = data['firstName'];
      surveyData[index].lastName = data['lastName'];
      surveyData[index].checkTarget = checkTarget;
      surveyData[index].code = data['code'];
      surveyData[index].survey = s;
      surveyData[index].isLoading = false;

      notifyListeners();

      new Future.delayed(const Duration(seconds: 2), () {
        // deleayed code here
      });
      //surveyData.add(SurveyData(data['surveyId'],data['plantingName'],data['fieldName'],data['substrict'],
      //    data['district'],data['province'],data['title'],data['firstName'],data['lastName'],checkTarget,data['code'],survey,false));

      index++;

      //SurveyData searchData = SurveyData(survey['surveyId'],survey['plantingName'],survey['fieldName'],survey['substrict'],survey['district'],survey['province'],survey['title'],survey['firstName'],survey['lastName'],checkTarget,survey['code'],s,false) ;
      //surveyData.add(surveyData[index]);
    }
    isLoading = true;

    notifyListeners();
  }

  void search(Map<String, dynamic> data) async {
    reset();
    //notifyListeners();
    SurveyService surveyService = SurveyService();
    String? token = tokenFromLogin?.token;

    if (plantingId != -1) {
      data["plantingId"] = plantingId.toString();
    }

    await surveyService.search(data, token.toString()).then((surveys) async {
      if (surveys != null) {
        await _doSearch(surveys, 0);
      }
    });

    isLoading = true;
    numberAllSurveys = surveyData.length;
    notifyListeners();
  }

  void searchByKey(Map<String, dynamic> data) async {
    reset();
    String? token = tokenFromLogin?.token;
    SurveyTargetPointService surveyTargetPointService =
        SurveyTargetPointService();
    SurveyService surveyService = SurveyService();

    if (plantingId != -1) {
      data["plantingId"] = plantingId.toString();
    }

    await surveyService
        .searchSurveyByKey(data, token.toString())
        .then((surveys) async {
      if (surveys != null) {
        await _doSearch(surveys, 0);
      }
    });

    /*List<Survey> data2 = surveys;
    bool checkTarget = false;

    for (int i = 0; i < data2.length; i++) {
      String? token = tokenFromLogin?.token;

      checkTarget = await surveyTargetPointService.checkSurveyTargetBySurveyId(
          token.toString(), data2[i].surveyID);
      list_check_target.add(checkTarget);

      PlantingService plantingService = new PlantingService();
      Planting? plantingData = await plantingService.getPlantingFromSurveyID(
          data2[i].surveyID, token.toString());

      if (plantingData != null) {
        plantings.add(plantingData);
        list_plantingName.add(plantingData.name);
      }

      Planting? planting = plantingData;
      int plantingID = planting?.plantingId ?? 0;

      SurveyService surveyPoint = SurveyService();
      List<Map<String, dynamic>> dataPoint = (await surveyPoint.getSurveyPoint(
          token.toString(), data2[i].surveyID));

      surveyPointList = dataPoint;

      Field? field;
      FieldService fieldService = FieldService();
      field =
          await fieldService.getFieldByPlantingID(plantingID, token.toString());
      if (field != null) {
        fields.add(field);
        list_fieldName.add(field.name);

        int fieldID = field.fieldID;

        String? location =
            await fieldService.getLocationByFielID(fieldID, token.toString());
        if (location != null) {
          locations.add(location);
          List<String> parts =
              location.split(","); // แยกข้อความด้วยเครื่องหมาย ','
          list_district.add(parts[0]);
          list_substrict.add(parts[1]);
          list_province.add(parts[2]);
        } else {
          locations.add("");
          list_district.add("ไม่ระบุ");
          list_substrict.add("ไม่ระบุ");
          list_province.add("ไม่ระบุ");
        }

        UserService userService = UserService();
        User? user =
            await userService.getUserByFieldID(fieldID, token.toString());
        if (user != null) {
          owner.add(user);
          list_title.add(user.title);
          list_firstName.add(user.firstName);
          list_lastName.add(user.lastName);
        } else {
          owner.add(User(
              -1,
              "service null",
              "service null",
              "service null",
              "service null",
              "service null",
              UserStatus.invalid,
              0,
              RequestInfoStatus.No));
          list_title.add("ไม่ระบุ");
          list_firstName.add("ไม่ระบุ");
          list_lastName.add("ไม่ระบุ");
        }
      }
    }
    isLoading = true;
    numberAllSurveys = this.surveys.length;
    notifyListeners();*/
  }

  void addSurvey(Survey data) async {
    String? token = tokenFromLogin?.token;
    //bool checkTarget = false;
    SurveyTargetPointService surveyTargetPointService =
        SurveyTargetPointService();
    SurveyService surveyService = SurveyService();
    bool checkTarget = await surveyTargetPointService
        .checkSurveyTargetBySurveyId(token.toString(), data.surveyID);
    //list_check_target.add(checkTarget);

    PlantingService plantingService = new PlantingService();
    Planting? plantingData = await plantingService.getPlantingFromSurveyID(
        data.surveyID, token.toString());

    /*if (plantingData != null) {
      plantings.insert(0, plantingData);
      list_plantingName.insert(0, plantingData.name);
    }*/

    //Field? field;
    FieldService fieldService = FieldService();
    Field field = await fieldService.getFieldByPlantingID(
        plantingData!.plantingId, token.toString()) as Field;

    String location = await fieldService.getLocationByFielID(
        field.fieldID, token.toString()) as String;

    List<String> parts = location.split(",");
    UserService userService = UserService();
    User user = await userService.getUserByFieldID(
        field.fieldID, token.toString()) as User;

    if (user == null) {
      user = User(-1, "undefined", "undefined", "undefined", "undefined",
          "undefined", UserStatus.invalid, 0, RequestInfoStatus.No);
    }

    SurveyData newSurveyData = SurveyData(
        data.surveyID,
        plantingData.name,
        field.name,
        parts[1],
        parts[0],
        parts[2],
        user.title,
        user.firstName,
        user.lastName,
        checkTarget,
        plantingData.code,
        data,
        false);

    surveyData.insert(0, newSurveyData);

    /*Planting? planting = plantingData;
    int plantingID = planting?.plantingId ?? 0;



    SurveyService surveyPoint = SurveyService();
    List<Map<String, dynamic>> dataPoint =
        (await surveyPoint.getSurveyPoint(token.toString(), data.surveyID));

    //surveyPointList = dataPoint;



    if (field != null) {
      fields.insert(0, field);
      list_fieldName.insert(0, field.name);
      int fieldID = field.fieldID;

      String? location =
          await fieldService.getLocationByFielID(fieldID, token.toString());
      if (location != null) {
        locations.insert(0, location);
        List<String> parts =
            location.split(","); // แยกข้อความด้วยเครื่องหมาย ','
        list_district.insert(0, parts[0]);
        list_substrict.insert(0, parts[1]);
        list_province.insert(0, parts[2]);
      } else {
        locations.insert(0, "");
        list_district.insert(0, "ไม่ระบุ");
        list_substrict.insert(0, "ไม่ระบุ");
        list_province.insert(0, "ไม่ระบุ");
      }
      UserService userService = UserService();
      User? user =
          await userService.getUserByFieldID(fieldID, token.toString());
      if (user != null) {
        owner.insert(0, user);
        list_title.insert(0, user.title);
        list_firstName.insert(0, user.firstName);
        list_lastName.insert(0, user.lastName);
      } else {
        owner.insert(
            0,
            User(
                -1,
                "service null",
                "service null",
                "service null",
                "service null",
                "service null",
                UserStatus.invalid,
                0,
                RequestInfoStatus.No));
        list_title.insert(0, "ไม่ระบุ");
        list_firstName.insert(0, "ไม่ระบุ");
        list_lastName.insert(0, "ไม่ระบุ");
      }
    }

    // Add the survey to the surveys list
    surveys.insert(0, data);*/

    notifyListeners();
  }

  Future<bool> deleteSurvey(Survey survey) async {
    SurveyService surveyervice = SurveyService();
    String? token = tokenFromLogin?.token;
    int statusCode = await surveyervice.deleteSurvey(token.toString(), survey);

    if (statusCode == 200) {
      for (int i = 0; i < surveyData.length; i++) {
        if (survey.surveyID == surveyData[i].id) {
          surveyData.removeAt(i);
          notifyListeners();
          return true;
        }
      }
    }
    return false;
  }
}
