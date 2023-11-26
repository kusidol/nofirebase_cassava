import 'dart:convert';

import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/variety.dart';
import 'package:mun_bot/env.dart';
import 'dart:developer';

class VarietyService {
  Future<List<Variety>> getVarieties(String token) async {
    List<Variety> varieties = [];
    Service service = new Service();
    var response =
        await service.doGet("${LOCAL_SERVER_IP_URL}/variety/", token);

    if (response.statusCode == 200) {
      varieties = ObjectList<Variety>.fromJson(
          jsonDecode(response.data), (body) => Variety.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return varieties;
  }

  Future<List<Variety>> getVarietiesByPlantingId(
      String token, int plantingId) async {
    List<Variety> varieties = [];
    Service service = new Service();
    var response = await service.doGet(
        "${LOCAL_SERVER_IP_URL}/plantingcassavavariety/planting/${plantingId}",
        token);

    if (response.statusCode == 200) {
      varieties = ObjectList<Variety>.fromJson(
          jsonDecode(response.data), (body) => Variety.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return varieties;
  }
}
