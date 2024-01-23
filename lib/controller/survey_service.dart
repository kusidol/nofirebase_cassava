import 'dart:convert';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/surveypointstatus.dart';
import 'package:mun_bot/env.dart';
import 'dart:developer';
import 'package:mun_bot/entities/response.dart' as EntityResponse;

class SurveyService {
  Future<List<Survey>> getSurvey(String token, int page, int value) async {
    List<Survey> survey = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/page/${page}/value/${value}", token);
    if (response.statusCode == 200) {
      survey = ObjectList<Survey>.fromJson(
          jsonDecode(response.data), (body) => Survey.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return survey;
  }

  Future<Survey?> getSurveyByID(String token, int surveyId) async {
    Survey? survey;
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/${surveyId}", token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      survey = Survey.fromJson(res['body']);
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return survey;
  }

  Future<List<Map<String, dynamic>>> getSurveyByPlantingID(
      String token, int plantingid, int page, int value) async {
    List<Map<String, dynamic>> datas = [];
    Service surveyService = new Service();
    var response = await surveyService.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/planting/${plantingid}/page/${page}/value/${value}",
        token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        datas.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return datas;
  }

  List<Map<String, dynamic>> surveyPointList = [];

  Future<List<Map<String, dynamic>>> getSurveyPoint(
      String token, int surveyId) async {
    Service service = Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/${surveyId}/surveypoints",
        token.toString());
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.data);
      if (responseBody['status'] == 200) {
        List<dynamic> surveyPoints = responseBody['body'];
        for (var surveyPoint in surveyPoints) {
          Map<String, dynamic> surveyPointPull = {
            'surveyPointId': surveyPoint['surveyPointId'],
            'pointNo': surveyPoint['pointNo'],
            'status': surveyPoint['status'],
          };
          surveyPointList.add(surveyPointPull);
        }
      }
    }
    return surveyPointList;
  }

  Future<Survey?> createSurvey(int plantingID, String token, var survey) async {
    Survey? newSurvey;
    Service surveysService = new Service();
    var response = await surveysService.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/planting/${plantingID}/survey", token, survey);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        newSurvey = Survey.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return newSurvey;
  }

  Future<Survey?> putSurveyPointStatus(
      int surveyId, String status, int pointNumber) async {
    Survey? SurveyPoint;
    Service surveysService = new Service();
    var response = await surveysService.update(
        "${LOCAL_SERVER_IP_URL}/survey/surveypoint", status, pointNumber);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        SurveyPoint = Survey.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCodeSurveypoint");
    }
    return SurveyPoint;
  }

  Future<int> postSurveyPointStatus(
      int surveyId, int pointNumber, String status, token) async {
    var request = {
      'surveyId': surveyId,
      'pointNumber': pointNumber,
      'status': status
    };
    Service surveysService = new Service();
    var response = await surveysService.update(
        "${LOCAL_SERVER_IP_URL}/survey/surveypoint", token, request);
    //var responseBody = json.decode(response.data);

    if (response.statusCode == 200) {
      //print(">>${response.data}");

      EntityResponse.Response<SurveyPointStatus> surveyPointStatus =
          EntityResponse.Response<SurveyPointStatus>.fromJson(
              jsonDecode(response.data),
              (body) => SurveyPointStatus.fromJson(body));

      return response.statusCode;
    }

    return 400;
  }

  Future<int> updateSurvey(String token, Survey surveying) async {
    Map survey = surveying.toJson();

    Service service = new Service();
    var response = await service.update(
        "${LOCAL_SERVER_IP_URL}/survey/${surveying.surveyID}", token, survey);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCodeUpdate");
    }
    return response.statusCode;
  }

  Future<int> deleteSurvey(String token, Survey survey) async {
    Map surveys = survey.toJson();

    Service service = new Service();

    var response = await service.delete(
        "${LOCAL_SERVER_IP_URL}/survey/${survey.surveyID}", token, surveys);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<List<Map<String, dynamic>>> searchSurveyByKey(
      Map<String, dynamic> data, String token) async {
    List<Map<String, dynamic>> surveys = [];
    int page = 1;
    int value = 1000;
    int date = DateTime.now().millisecondsSinceEpoch;
    Service surveysService = new Service();
    var response = await surveysService.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/survey/searchbykey/page/$page/value/$value/date/$date",
        token,
        data);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        surveys.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return surveys;
  }

  Future<List<Map<String, dynamic>>> search(
      Map<String, dynamic> data, String token) async {
    List<Map<String, dynamic>> surveys = [];
    int page = 1;
    int value = 1000;
    int date = DateTime.now().millisecondsSinceEpoch;
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/survey/search/page/$page/value/$value/date/$date",
        token,
        data);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        surveys.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return surveys;
  }

  Future<List<Map<String, dynamic>>> getSurveysWithPlantingAndLocationAndOwner(
      String token, int page, int value) async {
    List<Map<String, dynamic>> datas = [];
    Service service = new Service();
    int millisecondDate = DateTime.now().millisecondsSinceEpoch;

    //print("${millisecondDate}");
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/index/page/${page}/value/${value}/date/${millisecondDate}",
        token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        datas.add(item);
        print(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return datas;
  }

  Future<List<Survey>> getSurveysByCreateDate(
      int millisecondDate, String token) async {
    List<Survey> surveys = [];
    Service surveysService = new Service();
    var response = await surveysService.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/createdate/${millisecondDate}", token);

    if (response.statusCode == 200) {
      surveys = ObjectList<Survey>.fromJson(
          jsonDecode(response.data), (body) => Survey.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return surveys;
  }

  Future<int> countSurveys(String token) async {
    int count = 0;
    Service service = new Service();
    var response =
        await service.doGet("${LOCAL_SERVER_IP_URL}/survey/count", token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      count = res['body'];
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return count;
  }

  Future<int> countSurveysByPlantingId(String token, int plantingId) async {
    int count = 0;
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/count/plantingid/${plantingId}", token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      count = res['body'];
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return count;
  }
}
