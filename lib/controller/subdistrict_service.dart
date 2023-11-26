import 'dart:convert';
import 'dart:developer';
import 'package:mun_bot/entities/response.dart' as EntityResponse;
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/subdistrict.dart';
import 'package:mun_bot/env.dart';

class SubdistrictService {
  Future<List<Subdistrict>> getSubdistrict(String token) async {
    List<Subdistrict> subdistrict = [];
    Service subdistrictService = new Service();
    var response = await subdistrictService.doGet(
        "${LOCAL_SERVER_IP_URL}/subistrict/", token);
    if (response.statusCode == 200) {
      subdistrict = ObjectList<Subdistrict>.fromJson(
          jsonDecode(response.data), (body) => Subdistrict.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return subdistrict;
  }

  Future<int?> getSubdistrictByUserId(String token, int userId) async {
    int? id;
    Service subdistrictService = new Service();
    var response = await subdistrictService.doGet(
        "${LOCAL_SERVER_IP_URL}/subistrict/userinfield/${userId}/page/1/value/5",
        token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      Map<String, dynamic> item = res['body'][0];
      String value = jsonEncode(item['subdistrictId']);
      id = int.parse(value);
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return id;
  }

  Future<List<Map<String, dynamic>>> getAllSubdistrictsByDistrictId(
      String token, int districtId) async {
    Service service = new Service();

    List<Map<String, dynamic>> result = [];

    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/districts/${districtId}/subdistricts", token);
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
