import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class Dropdown {
  int id;
  String name;

  Dropdown(this.id, this.name);
}

class Dropdownplanting with ChangeNotifier {
  List<Dropdown> items = [];
  int pageService = 1;
  int _value = 5;

  //Additional
  List<Dropdown> saveItemsBeforeSearch = [];
  int savePageServiceBeforeSeach = 0;
  bool scroll = true;
  Field? field;
  Planting? planting;
  User? user;
  String? location;

  bool isAllItem = false;
  bool isScroll = false;

  // dropdown search
  bool dropdownSearch = true;
  Dropdownplanting() {
    fetchData();
  }

  Future<void> getPlantingAndUserByfieldId(int id) async {
    String? token = tokenFromLogin?.token;

    PlantingService plantingService = new PlantingService();
    Planting? plantingData =
        await plantingService.getPlantingByID(id, token.toString());

    this.planting = plantingData;

    FieldService fieldService = new FieldService();
    Field? fieldData =
        await fieldService.getFieldByPlantingID(id, token.toString());

    this.field = fieldData;
    int fieldID = field?.fieldID ?? 0;

    UserService userService = UserService();
    User? user = await userService.getUserByFieldID(fieldID, token.toString());

    this.user = user;

    String? locationData =
        await fieldService.getLocationByFielID(fieldID, token.toString());
    this.location = locationData;
    notifyListeners();
  }

  Future<void> fetchData() async {
    PlantingService plantingService = new PlantingService();
    String? token = tokenFromLogin?.token;

    int count = await plantingService.countPlantings(token.toString());

    List<Planting> data = await plantingService.getPlanting(
        token.toString(), pageService, _value);
    List<Dropdown> fetchData = [];
    data.forEach((e) {
      fetchData.add(Dropdown(e.plantingId, e.name.toString()));
    });

    if (items.length % _value != 0) {
      int x = items.length % _value;
      for (int i = 0; i < x; i++) {
        items.removeLast();
      }
      items = [...items, ...fetchData];
    } else {
      items = [...items, ...fetchData];
    }
    if (items.length == count) {
      isAllItem = true;
    } else {
      isAllItem = false;
    }
    pageService = (items.length ~/ _value) + 1;
    //print("===================Finish==================");
    notifyListeners();
  }

  void addItem(String item) {
    items.add(Dropdown(item.length + 1, item));
    notifyListeners();
  }

  List<String> get plantingString {
    List<String> convertToString = [];
    for (int i = 0; i < this.items.length; i++) {
      convertToString.add(items[i].name.toString());
    }
    return convertToString;
  }

  void updateItemsWithSearch(List<Planting> data) {
    this.isScroll = true;
    List<String> result = [];
    List<Dropdown> temp = this.items;
    this.saveItemsBeforeSearch = this.items;
    this.savePageServiceBeforeSeach = this.pageService;
    if (data.length != 0) {
      this.dropdownSearch = true;
    } else {
      this.dropdownSearch = false;
    }
    this.items = [];
    for (int i = 0; i < data.length; i++) {
      this.items.add(Dropdown(data[i].plantingId, data[i].name));
    }
    this.scroll = false;
    notifyListeners();
  }
}
