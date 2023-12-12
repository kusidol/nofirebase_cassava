import 'dart:convert';

import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/variety.dart';
import 'package:mun_bot/env.dart';
import 'dart:developer';

class PlantingService {
  Future<List<Planting>> getPlanting(String token, int page, int value) async {
    List<Planting> plants = [];
    Service service = new Service();
    int millisecondDate = DateTime.now().millisecondsSinceEpoch;
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/page/${page}/value/${value}/date/${millisecondDate}",
        token);

    if (response.statusCode == 200) {
      plants = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return plants;
  }

  Future<List<Map<String, dynamic>>> getPlantingByFieldID(
      String token, int fieldid, int page, int value) async {
    List<Map<String, dynamic>> datas = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/field/${fieldid}/page/${page}/value/${value}",
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

  Future<List<Planting>> getPlantingByField(String token) async {
    List<Planting> plants = [];
    Service service = new Service();
    var response =
        await service.doGet("${LOCAL_SERVER_IP_URL}/planting/page/1", token);
    if (response.statusCode == 200) {
      plants = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return plants;
  }

  Future<List<Planting>> getPlantingInfield(int value, String token) async {
    List<Planting> plants = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/$value/planting/page/1/value/20", token);
    if (response.statusCode == 200) {
      plants = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return plants;
  }

  static Future<List<Planting>> getPlantings(String query, String token) async {
    List<Planting> plants = [];
    Service service = new Service();
    var response =
        await service.doGet("${LOCAL_SERVER_IP_URL}/planting/page/1", token);
    if (response.statusCode == 200) {
      final List planting = json.decode(response.body);

      return planting.map((json) => Planting.fromJson(json)).where((plant) {
        final codeLower = plant.code.toLowerCase();
        final nameLower = plant.name.toLowerCase();
        final searchLower = query.toLowerCase();

        return codeLower.contains(searchLower) ||
            nameLower.contains(searchLower);
      }).toList();
    } else {
      print("error with out statusCode");
    }
    return plants;
  }

  Future<List<Planting>> getPlantingsByFieldID(
      int fieldID, int page, int valuePerPage, String token) async {
    List<Planting> plants = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldID}/planting/page/${page}/value/${valuePerPage}",
        token);
    if (response.statusCode == 200) {
      plants = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else {
      print("error with out statusCode");
    }
    return plants;
  }

  Future<Planting?> createPlanting(String token, var planting) async {
    Planting? newPlanting;
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/planting/", token, planting);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      newPlanting = Planting.fromJson(res['body']);
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return newPlanting;
  }

  Future<int> updatePlanting(String token, var planting, int plantingID) async {
    Service service = new Service();

    var response = await service.update(
        "${LOCAL_SERVER_IP_URL}/planting/${plantingID}", token, planting);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<int> deletePlanting(String token, Planting planting) async {
    Map plant = planting.toJson();

    Service service = new Service();

    var response = await service.delete(
        "${LOCAL_SERVER_IP_URL}/planting/${planting.plantingId}", token, plant);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<Planting?> getPlantingFromSurveyID(int surveyID, String token) async {
    Planting? planting;
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/survey/${surveyID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        planting = Planting.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return planting;
  }

  Future<List<Variety>> getVarietyWithPlantingId(
      int varietyId, String token) async {
    List<Variety> variety = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/plantingcassavavariety/planting/${varietyId}",
        token);

    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        variety = ObjectList<Variety>.fromJson(
            jsonDecode(response.data), (body) => Variety.fromJson(body)).list;
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return variety;
  }

  Future<List<Planting>> searchPlantingByKey(
      String address,
      int endDate,
      String fieldName,
      String ownerName,
      String plantingName,
      int startDate,
      String token) async {
    Map<String, dynamic> jsonData = {};
    if (startDate == 0 || endDate == 0) {
      jsonData = {
        "address": address,
        "endDate": 0,
        "fieldName": fieldName,
        "ownerName": ownerName,
        "plantingName": plantingName,
        "startDate": 0,
      };
    } else {
      jsonData = {
        "address": address,
        "endDate": endDate,
        "fieldName": fieldName,
        "ownerName": ownerName,
        "plantingName": plantingName,
        "startDate": startDate,
      };
    }
    List<Planting> plantings = [];
    Service plantingsService = new Service();
    var response = await plantingsService.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/planting/search", token, jsonData);

    if (response.statusCode == 200) {
      plantings = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return plantings;
  }

  Future<List<Map<String, dynamic>>> searchPlantingByKey2(
      Map<String, dynamic> data, String token) async {
    List<Map<String, dynamic>> datas = [];
    Service plantingsService = new Service();
    var response = await plantingsService.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/planting/search", token, data);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        print(item);
        datas.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return datas;
  }

  Future<List<Map<String, dynamic>>> search(
      Map<String, dynamic> data, String token) async {
    List<Map<String, dynamic>> datas = [];
    int page = 1;
    int value = 1000;
    int date = DateTime.now().millisecondsSinceEpoch;
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/planting/searchbykey/page/$page/value/$value/date/$date",
        token,
        data);

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

  Future<Planting?> getPlantingByID(int ID, String token) async {
    Planting? planting;
    Service service = new Service();
    var response =
        await service.doGet("${LOCAL_SERVER_IP_URL}/planting/${ID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        planting = Planting.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return planting;
  }

  Future<List<Map<String, dynamic>>> getPlantingsWithLocationAndOwner(
      String token, int page, int value) async {
    List<Map<String, dynamic>> datas = [];
    Service service = new Service();
    int millisecondDate = DateTime.now().millisecondsSinceEpoch;
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/index/page/${page}/value/${value}/date/${millisecondDate}",
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

  Future<List<Planting>> getPlantingByCreateDate(
      int millisecondDate, String token) async {
    List<Planting> plantings = [];
    Service plantingsService = new Service();
    var response = await plantingsService.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/createdate/${millisecondDate}", token);

    if (response.statusCode == 200) {
      plantings = ObjectList<Planting>.fromJson(
          jsonDecode(response.data), (body) => Planting.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return plantings;
  }

  Future<int> countPlantings(String token) async {
    int count = 0;
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/countplanting", token);
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

  Future<int> countPlantingsByFieldId(String token, int fieldId) async {
    int count = 0;
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/planting/countplanting/fieldid/${fieldId}",
        token);
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
