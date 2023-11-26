import 'dart:convert';
import 'dart:developer';

import 'package:mun_bot/controller/service.dart';

import '../env.dart';

class FarmerData {
  int id;
  String name;

  FarmerData(this.id, this.name);
}

class FarmerService {
  Future<List<Map<String, dynamic>>> searchFarmerByFirstnameLastName(
      int fieldId,
      String firstname,
      String lastname,
      String token,
      int page,
      int value) async {
    Map<String, dynamic> jsonData = {
      "firstname": firstname,
      "lastname": lastname,
    };

    List<Map<String, dynamic>> result = [];
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/searchfarmer/page/${page}/value/${value}",
        token,
        jsonData);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        result.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllFarmerByFieldId(
      String token, int fieldId, int page, int value) async {
    Service service = new Service();

    List<Map<String, dynamic>> result = [];

    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/farmer/page/${page}/value/${value}",
        token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        result.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }

  Future<int> addFarmer(String token, int memberId, int fieldId) async {
    int result = 404;
    Service service = new Service();

    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/add/farmer/${memberId}",
        token,
        null);
    if (response.statusCode == 200) {
      result = response.statusCode;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }

  Future<int> removeFarmer(String token, int memberId, int fieldId) async {
    int result = 404;
    Service service = new Service();

    var response = await service.delete(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/delete/farmer/${memberId}",
        token,
        null);
    if (response.statusCode == 200) {
      result = response.statusCode;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }

  Future<int> createFarmer(String token, var farmer) async {
    Service service = new Service();
    String value = jsonEncode(farmer);
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/farmer/farmerorganization", token, value);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<List<Map<String, dynamic>>> getAllFarmers(
      String token, int page, int value) async {
    Service service = new Service();

    List<Map<String, dynamic>> result = [];
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/farmer/organization/page/${page}/value/${value}",
        token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        result.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> searchFarmerByKey(String firstname,
      String lastname, String provinceAddress, String token) async {
    Map<String, dynamic> jsonData = {
      "firstName": firstname,
      "lastName": lastname,
      "provinceAddress": provinceAddress,
    };

    List<Map<String, dynamic>> result = [];

    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/farmer/search", token, jsonData);

    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      for (int i = 0; i < res['body'].length; i++) {
        Map<String, dynamic> item = res['body'][i];
        result.add(item);
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }
}
