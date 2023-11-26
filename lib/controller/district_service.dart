import 'dart:convert';
import 'dart:developer';

import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/env.dart';

class Data {
  int id;
  String name;

  Data(this.id, this.name);
}

class DistrictService {
  Future<List<Map<String, dynamic>>> getAllDistrictsByProvinceId(
      String token, int provinceId) async {
    Service service = new Service();

    List<Map<String, dynamic>> result = [];

    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/provinces/${provinceId}/districts", token);
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
