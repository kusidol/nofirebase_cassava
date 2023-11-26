import 'dart:convert';
import 'dart:developer';

import 'package:mun_bot/controller/service.dart';

import '../env.dart';

class StaffService {
  Future<List<Map<String, dynamic>>> searchStaffByFirstnameLastName(
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
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/searchstaff/page/${page}/value/${value}",
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

  Future<List<Map<String, dynamic>>> getAllStaffByFieldId(
      String token, int fieldId, int page, int value) async {
    Service service = new Service();

    List<Map<String, dynamic>> result = [];

    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/staff/page/${page}/value/${value}",
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

  Future<int> addStaff(String token, int staffId, int fieldId) async {
    int result = 404;
    Service service = new Service();

    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/add/staff/${staffId}",
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

  Future<int> removeStaff(String token, int staffId, int fieldId) async {
    int result = 404;
    Service service = new Service();

    var response = await service.delete(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldId}/delete/staff/${staffId}",
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
}
