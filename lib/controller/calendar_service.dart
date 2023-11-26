import 'dart:convert';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/env.dart';
import 'dart:developer';

class CalendarService {
  Future<List<int>> getNumberEvents(String token, int date) async {
    List<int> events = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/calendar/date/${date}", token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      events = res['body'].cast<int>();
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return events;
  }

  Future<List<Object>> getPlantingsAndSurveys(String token, int date) async {
    List<Object> result = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/calendar/plantingandsurvey/date/${date}",
        token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      result = res['body'].cast<Object>();
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }

  Future<List<Planting>> getPlantingsByCreateDate(
      String token, int date) async {
    List<Planting> planting = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/calendar/planting/createdate/${date}", token);
    if (response.statusCode == 200) {
      planting = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return planting;
  }

  Future<List<Survey>> getSurveysByCreateDate(String token, int date) async {
    List<Survey> survey = [];
    Service service = new Service();
    log("MILLISECOND : ${date}");
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/calendar/survey/createdate/${date}", token);
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
}
