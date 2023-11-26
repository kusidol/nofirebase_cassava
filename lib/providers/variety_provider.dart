import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/entities/variety.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class VarietyProvider with ChangeNotifier {
  List<Variety> varieties = [];

  void setVariety(List<Variety> data) {
    varieties = data;
    notifyListeners();
  }

  void getVarietuesWithPlantingId(int plantingId) async {
    List<Variety> data = [];
    PlantingService plantingService = PlantingService();
    String? token = tokenFromLogin?.token;
    data = await plantingService.getVarietyWithPlantingId(
        plantingId, token.toString());
    varieties = data;
    notifyListeners();
  }
}
