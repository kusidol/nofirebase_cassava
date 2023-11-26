import 'package:flutter/cupertino.dart';
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

class SurveyProvider with ChangeNotifier {
  bool isHavePlanting = false;
  List<Survey> surveys = [];
  List<Planting> plantings = [];
  List<Field> fields = [];
  List<String> locations = [];
  List<User> owner = [];
  List<Map<String, dynamic>> surveyPointList = [];
  List<SurveyTargetPoint> surveyTargetPointCount = [];
  bool isLoading = false;
  final int _value = 5;
  int _page = 1;
  int _date = DateTime.now().millisecondsSinceEpoch;
  int plantingId = 0;
  String plantingName = "";
  bool isSearch = false;
// New Adding

  List<String> list_plantingName = [];
  List<String> list_fieldName = [];
  List<String> list_substrict = [];
  List<String> list_district = [];
  List<String> list_province = [];
  List<String> list_title = [];
  List<String> list_firstName = [];
  List<String> list_lastName = [];
  List<bool> list_check_target = [];
  int numberAllSurveys = 0;

  void reset() {
    isLoading = false;
    surveys = [];
    plantings = [];
    surveyTargetPointCount = [];
    surveyPointList = [];
    list_plantingName = [];
    list_fieldName = [];
    list_substrict = [];
    list_district = [];
    list_province = [];
    list_title = [];
    list_firstName = [];
    list_check_target = [];
    _date = DateTime.now().millisecondsSinceEpoch;
    list_lastName = [];
    _page = 1;
  }

  void resetPlantingID() {
    plantingId = 0;
    plantingName = "";
  }

  Future<void> fetchData() async {
    List<Survey> data = [];
    SurveyService surveyService = SurveyService();
    PlantingService plantingService = PlantingService();
    SurveyTargetPoint surveyTargetPointService = SurveyTargetPoint();
    String? token = tokenFromLogin?.token;
    int count = await plantingService.countPlantings(token.toString());
    data = await surveyService.getSurvey(token.toString(), _page, _value);
    numberAllSurveys = await surveyService.countSurveys(token.toString());

    List<Map<String, dynamic>> detail =
        await surveyService.getSurveysWithPlantingAndLocationAndOwner(
            token.toString(), _page, _value);

    for (Map<String, dynamic> data in detail) {
      list_plantingName.add(data['plantingName']);
      list_fieldName.add(data['fieldName']);
      list_substrict.add(data['substrict']);
      list_district.add(data['district']);
      list_province.add(data['province']);
      list_title.add(data['title']);
      list_firstName.add(data['firstName']);
      list_lastName.add(data['lastName']);
      bool checkTarget = await surveyTargetPointService
          .checkSurveyTargetBySurveyId(token.toString(), data['surveyId']);
      list_check_target.add(checkTarget);
    }
    if (surveys.length % _value != 0) {
      int x = surveys.length % _value;
      for (int i = 0; i < x; i++) {
        surveys.removeLast();
      }
      surveys = [...surveys, ...data];
    } else {
      surveys = [...surveys, ...data];
    }

    _page = (surveys.length ~/ _value) + 1;
    List<Survey> data2 = this.surveys;

    for (int i = 0; i < data2.length; i++) {
      String? token = tokenFromLogin?.token;

      PlantingService plantingService = new PlantingService();
      Planting? plantingData = await plantingService.getPlantingFromSurveyID(
          data2[i].surveyID, token.toString());

      if (plantingData != null) {
        plantings.add(plantingData);
      }

      SurveyService surveyPoint = SurveyService();
      List<Map<String, dynamic>> dataPoint = (await surveyPoint.getSurveyPoint(
          token.toString(), data2[i].surveyID));
      // print(dataPoint);
      surveyPointList = dataPoint;
    }

    if (count == 0) {
      isHavePlanting = false;
    } else {
      isHavePlanting = true;
    }
    notifyListeners();
    isLoading = true;
  }

  Future<void> fetchDataFromPlanting() async {
    List<Survey> dataSurvey = [];
    SurveyService surveyService = SurveyService();
    PlantingService plantingService = PlantingService();
    SurveyTargetPoint surveyTargetPointService = SurveyTargetPoint();
    String? token = tokenFromLogin?.token;
    int count = await plantingService.countPlantings(token.toString());
    List<Map<String, dynamic>> detail = await surveyService
        .getSurveyByPlantingID(token.toString(), plantingId, _page, _value);
    numberAllSurveys = await surveyService.countSurveysByPlantingId(
        token.toString(), plantingId);
    for (Map<String, dynamic> data in detail) {
      list_plantingName.add(data['plantingName']);
      list_fieldName.add(data['fieldName']);
      list_substrict.add(data['substrict']);
      list_district.add(data['district']);
      list_province.add(data['province']);
      list_title.add(data['title']);
      list_firstName.add(data['firstName']);
      list_lastName.add(data['lastName']);
      bool checkTarget = await surveyTargetPointService
          .checkSurveyTargetBySurveyId(token.toString(), data['surveyId']);
      list_check_target.add(checkTarget);
      Survey? survey =
          await surveyService.getSurveyByID(token.toString(), data['surveyId']);
      dataSurvey.add(survey!);
    }
    if (surveys.length % _value != 0) {
      int x = surveys.length % _value;
      for (int i = 0; i < x; i++) {
        surveys.removeLast();
      }
      surveys = [...surveys, ...dataSurvey];
    } else {
      surveys = [...surveys, ...dataSurvey];
    }

    _page = (surveys.length ~/ _value) + 1;
    List<Survey> data2 = this.surveys;

    for (int i = 0; i < data2.length; i++) {
      String? token = tokenFromLogin?.token;

      PlantingService plantingService = new PlantingService();
      Planting? plantingData = await plantingService.getPlantingFromSurveyID(
          data2[i].surveyID, token.toString());

      if (plantingData != null) {
        plantings.add(plantingData);
      }

      SurveyService surveyPoint = SurveyService();
      List<Map<String, dynamic>> dataPoint = (await surveyPoint.getSurveyPoint(
          token.toString(), data2[i].surveyID));
      // print(dataPoint);
      surveyPointList = dataPoint;
    }
    isLoading = true;
    if (count == 0) {
      isHavePlanting = false;
    } else {
      isHavePlanting = true;
    }
    notifyListeners();
  }

  void search(Map<String, dynamic> data) async {
    reset();
    String? token = tokenFromLogin?.token;
    SurveyTargetPoint surveyTargetPointService = SurveyTargetPoint();
    SurveyService surveyService = SurveyService();
    surveys = await surveyService.searchSurveyByKey(
        data, 1, 1000, _date, token.toString());
    List<Survey> data2 = this.surveys;
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
    notifyListeners();
  }

  void searchByKey(Map<String, dynamic> data) async {
    reset();
    String? token = tokenFromLogin?.token;
    SurveyTargetPoint surveyTargetPointService = SurveyTargetPoint();
    SurveyService surveyService = SurveyService();
    surveys = await surveyService.search(data, token.toString());
    List<Survey> data2 = surveys;
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
    notifyListeners();
  }

  void addSurvey(Survey data) async {
    String? token = tokenFromLogin?.token;
    bool checkTarget = false;
    SurveyTargetPoint surveyTargetPointService = SurveyTargetPoint();
    SurveyService surveyService = SurveyService();
    checkTarget = await surveyTargetPointService.checkSurveyTargetBySurveyId(
        token.toString(), data.surveyID);
    list_check_target.add(checkTarget);

    PlantingService plantingService = new PlantingService();
    Planting? plantingData = await plantingService.getPlantingFromSurveyID(
        data.surveyID, token.toString());

    if (plantingData != null) {
      plantings.insert(0, plantingData);
      list_plantingName.insert(0, plantingData.name);
    }

    Planting? planting = plantingData;
    int plantingID = planting?.plantingId ?? 0;

    SurveyService surveyPoint = SurveyService();
    List<Map<String, dynamic>> dataPoint =
        (await surveyPoint.getSurveyPoint(token.toString(), data.surveyID));

    surveyPointList = dataPoint;

    Field? field;
    FieldService fieldService = FieldService();
    field =
        await fieldService.getFieldByPlantingID(plantingID, token.toString());

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
    surveys.insert(0, data);

    notifyListeners();
  }

  Future<int> deleteSurvey(Survey survey) async {
    SurveyService surveyervice = SurveyService();
    String? token = tokenFromLogin?.token;
    int statusCode = await surveyervice.deleteSurvey(token.toString(), survey);

    for (int i = 0; i < plantings.length; i++) {
      if (survey.surveyID == surveys[i].surveyID) {
        surveys.removeAt(i);
        break;
      }
    }
    notifyListeners();
    return statusCode;
  }
}
