import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mun_bot/controller/farmer_service.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class Dropdown {
  int id;
  String name;

  Dropdown(this.id, this.name);
}

class DropdownFarmer with ChangeNotifier {
  List<Dropdown> items = [];
  int pageService = 1;
  int _value = 5;
  bool scroll = true;

  // SEARCH SETUP
  List<Dropdown> saveItemsBeforeSearch = [];
  int savePageServiceBeforeSeach = 0;

  bool isScroll = false;

  // dropdown search
  bool dropdownSearch = true;

  DropdownFarmer() {
    fetchData();
  }

  String getStringMakeFormat(Map<String, dynamic> text, String keyword) {
    String result = jsonEncode(text[keyword]);
    result = result.replaceAll('"', '');
    return result;
  }

  Future<void> fetchData() async {
    List<Dropdown> fetchData = [];

    FarmerService farmerService = new FarmerService();
    String? token = tokenFromLogin?.token;

    List<Map<String, dynamic>> getFarmerData = await farmerService
        .getAllFarmers(token.toString(), pageService, _value);

    for (int i = 0; i < getFarmerData.length; i++) {
      String title = getStringMakeFormat(getFarmerData[i], "title");
      String firstName = getStringMakeFormat(getFarmerData[i], "firstName");
      String lastName = getStringMakeFormat(getFarmerData[i], "lastName");
      int id = int.parse(jsonEncode(getFarmerData[i]["userId"]));
      fetchData.add(Dropdown(id, "${title} ${firstName} ${lastName}"));
    }

    if (items.length % _value != 0) {
      int x = items.length % _value;
      for (int i = 0; i < x; i++) {
        items.removeLast();
      }
      items = [...items, ...fetchData];
    } else {
      items = [...items, ...fetchData];
    }

    pageService = (items.length ~/ _value) + 1;
    notifyListeners();
  }

  void addItem(String item) {
    items.add(Dropdown(item.length + 1, item));
    notifyListeners();
  }

  List<String> get farmerString {
    List<String> convertToString = [];
    for (int i = 0; i < this.items.length; i++) {
      convertToString.add(items[i].name.toString());
    }
    return convertToString;
  }

  void updateItemsWithSearch(List<Map<String, dynamic>> data) {
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
      String title = getStringMakeFormat(data[i], "title");
      String firstName = getStringMakeFormat(data[i], "firstName");
      String lastName = getStringMakeFormat(data[i], "lastName");
      int id = int.parse(jsonEncode(data[i]["userId"]));
      this.items.add(Dropdown(id, "${title} ${firstName} ${lastName}"));
    }
    this.scroll = false;
    notifyListeners();
  }
}
