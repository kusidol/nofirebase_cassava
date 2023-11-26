import 'dart:convert';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/target_of_survey/disease.dart';
import 'package:mun_bot/entities/target_of_survey/natural_enermy.dart';
import 'package:mun_bot/entities/target_of_survey/pest_phase_survey.dart';
import 'package:mun_bot/entities/target_of_survey/target.dart';
import 'package:mun_bot/env.dart';

class TargetOfSurveyService {
  Future<List<Target>> getAllDisease(String token) async {
    List<Target> diseasaes = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/targetofsurvey/getalldisease", token);
    if (response.statusCode == 200) {
      diseasaes = ObjectList<Target>.fromJson(
          jsonDecode(response.data), (body) => Target.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return diseasaes;
  }

  Future<List<Target>> getAllNaturalEnermy(String token) async {
    List<Target> naturalEnermy = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/targetofsurvey/getallnaturalenemy", token);
    if (response.statusCode == 200) {
      naturalEnermy = ObjectList<Target>.fromJson(
          jsonDecode(response.data), (body) => Target.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return naturalEnermy;
  }

  Future<List<Target>> getAllPestPhaseSurvey(String token) async {
    List<Target> pestPhaseSurveys = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/targetofsurvey/getallpestphasesurvey", token);
    if (response.statusCode == 200) {
      pestPhaseSurveys = ObjectList<Target>.fromJson(
          jsonDecode(response.data), (body) => Target.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return pestPhaseSurveys;
  }

  Future<List<Disease>> getAllDiseaseBySurveyID(
      String token, int surveyID) async {
    List<Disease> diseasaes = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/${surveyID}/diseases", token);
    if (response.statusCode == 200) {
      diseasaes = ObjectList<Disease>.fromJson(
          jsonDecode(response.data), (body) => Disease.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return diseasaes;
  }

  Future<List<NaturalEnermy>> getAllNaturalEnermyBySurveyID(
      String token, int surveyID) async {
    List<NaturalEnermy> naturalEnermy = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/${surveyID}/naturalenemies", token);
    if (response.statusCode == 200) {
      try {
        naturalEnermy = ObjectList<NaturalEnermy>.fromJson(
            jsonDecode(response.data),
            (body) => NaturalEnermy.fromJson(body)).list;
      } catch (e) {
        print(e);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return naturalEnermy;
  }

  Future<List<PestPhaseSurvey>> getAllPestPhaseSurveyBySurveyID(
      String token, int surveyID) async {
    List<PestPhaseSurvey> pestPhaseSurveys = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/${surveyID}/pestphasesurveys", token);
    if (response.statusCode == 200) {
      pestPhaseSurveys = ObjectList<PestPhaseSurvey>.fromJson(
          jsonDecode(response.data),
          (body) => PestPhaseSurvey.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return pestPhaseSurveys;
  }

  //service ต้องแก้ภายหลัง แยกเป็น 3 เรื่อง
  Future<int> createTargetBySurveyID(
      int surveyID, String token, var targetSurvey) async {
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/surveytarget/create/survey/${surveyID}",
        token,
        targetSurvey);

    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<int> updateTargetBySurveyID(
      int surveyID, String token, var targetSurvey) async {
    Service service = new Service();
    var response = await service.update(
        "${LOCAL_SERVER_IP_URL}/surveytarget/update/survey/${surveyID}",
        token,
        targetSurvey);

    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }
}
