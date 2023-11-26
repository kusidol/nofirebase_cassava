import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class Dropdown {
  int id;
  String name;

  Dropdown(this.id, this.name);
}

class Dropdownfield with ChangeNotifier {
  List<Dropdown> items = [];
  int pageService = 1;
  int _value = 5;

  Field? field;
  User? user;
  String? location;
  //Additional
  List<Dropdown> saveItemsBeforeSearch = [];
  int savePageServiceBeforeSeach = 0;
  bool scroll = true;

  bool isAllItem = false;
  bool isScroll = false;

  // dropdown search
  bool dropdownSearch = true;
  Dropdownfield() {
    fetchData();
  }

  Future<void> fetchData() async {
    FieldService fieldService = new FieldService();
    String? token = tokenFromLogin?.token;
    List<Field> data =
        await fieldService.getFields(token.toString(), pageService, _value);

    int count = await fieldService.countFields(token.toString());

    List<Dropdown> fetchData = [];

    data.forEach((e) {
      fetchData.add(Dropdown(e.fieldID, "${e.name} (${e.code})"));
    });

    if (items.length % _value != 0) {
      // plantings.removeRange((_value*(_page-1))+1, plantings.length);
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
    print("===================Finish==================");
    notifyListeners();
  }

  Future<void> getFieldAndUserAndLocationByfieldId(int id) async {
    String? token = tokenFromLogin?.token;

    FieldService fieldService = new FieldService();
    Field? fieldData =
        await fieldService.getFieldByFieldID(id, token.toString());

    this.field = fieldData;
    int fieldID = field?.fieldID ?? 0;

    String? locationData =
        await fieldService.getLocationByFielID(fieldID, token.toString());
    this.location = locationData;

    UserService userService = UserService();
    User? user = await userService.getUserByFieldID(fieldID, token.toString());

    this.user = user;
    notifyListeners();
  }

  void clearItem() {
    List<Dropdown> temp = [];

    for (int i = 0; i < items.length; i++) {
      if (i == 2) {
        break;
      }
      temp.add(items[i]);
    }

    items = temp;
  }

  void addItem(String item) {
    items.add(Dropdown(item.length + 1, item));
    notifyListeners();
  }

  List<String> get fieldString {
    List<String> convertToString = [];
    for (int i = 0; i < this.items.length; i++) {
      convertToString.add(items[i].name.toString());
    }
    return convertToString;
  }

  void updateItemsWithSearch(List<Field> data) {
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
      this.items.add(Dropdown(data[i].fieldID, data[i].name));
    }
    this.scroll = false;
    notifyListeners();
  }

  bool contain(Dropdown item) {
    return this.items.contains(item);
  }
}
