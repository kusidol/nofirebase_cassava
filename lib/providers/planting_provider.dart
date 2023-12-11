import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class PlantingData {
  int plantingId;
  String plantingName;
  String fieldName;
  String substrict;
  String district;
  String province;
  String title;
  String firstName;
  String lastName;
  Planting planting;
  PlantingData(
      this.plantingId,
      this.plantingName,
      this.fieldName,
      this.substrict,
      this.district,
      this.province,
      this.title,
      this.firstName,
      this.lastName,
      this.planting);
}

class PlantingProvider with ChangeNotifier {
  bool isHaveField = false;
  // List<Planting> plantings = [];
  // List<User> owners = [];
  // List<Field> fields = [];
  // List<String> locations = [];

  int numberAllPlantings = 0;

  // New Adding
  List<PlantingData> plantingData = [];
  // List<String> list_fieldName = [];
  // List<String> list_substrict = [];
  // List<String> list_district = [];
  // List<String> list_province = [];
  // List<String> list_title = [];
  // List<String> list_firstName = [];
  // List<String> list_lastName = [];
  final int _value = 5;
  int _page = 1;
  bool isLoading = false;

  int fieldID = 0;
  String fieldName = "";

  void reset() {
    isLoading = false;
    // plantings = [];
    // owners = [];
    // fields = [];
    // locations = [];

    // list_fieldName = [];
    // list_substrict = [];
    // list_district = [];
    // list_province = [];
    // list_title = [];
    // list_firstName = [];
    // list_lastName = [];
    plantingData.clear();
    _page = 1;
  }

  void resetFieldID() {
    fieldID = 0;
    fieldName = "";
  }

  Future<void> fetchData() async {
    // List<Planting> data = [];
    PlantingService plantingService = PlantingService();
    String? token = tokenFromLogin?.token;
    numberAllPlantings = await plantingService.countPlantings(token.toString());
    FieldService fieldService = FieldService();
    int count = await fieldService.countFields(token.toString());
    // data = await plantingService.getPlanting(token.toString(), _page, _value);
    // print("page : ${_page}");
    await plantingService
        .getPlantingsWithLocationAndOwner(token.toString(), _page, _value)
        .then((value) async {
      if (value != null) {
        if (numberAllPlantings == plantingData.length) return;

        for (Map<String, dynamic> data in value) {
          Planting? planting = await plantingService.getPlantingByID(
              data['plantingId'], token.toString());
          if (planting != null) {
            plantingData.add(PlantingData(
                data['plantingId'],
                data['plantingName'],
                data['fieldName'],
                data['substrict'],
                data['district'],
                data['province'],
                data['title'],
                data['firstName'],
                data['lastName'],
                planting));
          }
        }

        _page = (plantingData.length ~/ _value) + 1;
      }
    });
    // for (Map<String, dynamic> data in detail) {
    //   list_fieldName.add(data['fieldName']);
    //   list_substrict.add(data['substrict']);
    //   list_district.add(data['district']);
    //   list_province.add(data['province']);
    //   list_title.add(data['title']);
    //   list_firstName.add(data['firstName']);
    //   list_lastName.add(data['lastName']);
    // }
    // if (plantings.length % _value != 0) {
    //   // plantings.removeRange((_value*(_page-1))+1, plantings.length);
    //   int x = plantings.length % _value;
    //   for (int i = 0; i < x; i++) {
    //     plantings.removeLast();
    //   }
    //   plantings = [...plantings, ...data];
    // } else {
    //   plantings = [...plantings, ...data];
    // }

    // _page = (plantings.length ~/ _value) + 1;

    // List<Planting> plant = this.plantings;

    isLoading = true;
    if (count > 0) {
      isHaveField = true;
    }
    notifyListeners();
  }

  Future<void> fetchDataFromField() async {
    // print("LOADING PLANTING PROVIDER");
    // List<Planting> dataPlanting = [];
    PlantingService plantingService = PlantingService();
    String? token = tokenFromLogin?.token;
    // print("page : ${_page}");
    List<Map<String, dynamic>> detail = await plantingService
        .getPlantingByFieldID(token.toString(), fieldID, _page, _value);
    numberAllPlantings = await plantingService.countPlantingsByFieldId(
        token.toString(), fieldID);
    for (Map<String, dynamic> data in detail) {
      // list_fieldName.add(data['fieldName']);
      // list_substrict.add(data['substrict']);
      // list_district.add(data['district']);
      // list_province.add(data['province']);
      // list_title.add(data['title']);
      // list_firstName.add(data['firstName']);
      // list_lastName.add(data['lastName']);
      // Planting? plant = await plantingService.getPlantingByID(
      //     data['plantingId'], token.toString());
      // dataPlanting.add(plant!);
      Planting planting = await plantingService.getPlantingByID(
          data['plantingId'], token.toString()) as Planting;

      plantingData.add(PlantingData(
          data['plantingId'],
          data['plantingName'],
          data['fieldName'],
          data['substrict'],
          data['district'],
          data['province'],
          data['title'],
          data['firstName'],
          data['lastName'],
          planting));
    }
    // if (plantings.length % _value != 0) {
    //   // plantings.removeRange((_value*(_page-1))+1, plantings.length);
    //   int x = plantings.length % _value;
    //   for (int i = 0; i < x; i++) {
    //     plantings.removeLast();
    //   }
    //   plantings = [...plantings, ...dataPlanting];
    // } else {
    //   plantings = [...plantings, ...dataPlanting];
    // }

    _page = (plantingData.length ~/ _value) + 1;

    // List<Planting> plant = this.plantings;
    notifyListeners();
    isLoading = true;
  }

  // List<Planting> getPlantings() {
  //   return plantings;
  // }

  // void resetPlanting(List<Planting> data) {
  //   plantings = data;
  //   notifyListeners();
  // }

  void addPlanting(Planting data) async {
    // String jsonCultivation = jsonEncode(data);
    // log("Debug : create Cultivation : ${jsonCultivation}");

    //reset();
    // plantings.insert(0, data);

    String? token = tokenFromLogin?.token;

    Field? field;
    FieldService fieldService = FieldService();
    field = await fieldService.getFieldByPlantingID(
        data.plantingId, token.toString());

    if (field != null) {
      String fieldName = '';
      String district = 'ไม่ระบุ';
      String substrict = 'ไม่ระบุ';
      String province = 'ไม่ระบุ';
      String title = 'ไม่ระบุ';
      String firstName = 'ไม่ระบุ';
      String lastName = 'ไม่ระบุ';
      // fields.insert(0, field);
      firstName = fieldName;
      // list_fieldName.insert(0, field.name);
      int fieldID = field.fieldID;

      String? location =
          await fieldService.getLocationByFielID(fieldID, token.toString());
      if (location != null) {
        // locations.insert(0, location);
        List<String> parts =
            location.split(","); // แยกข้อความด้วยเครื่องหมาย ','

        district = parts[0];
        substrict = parts[1];
        province = parts[2];
        // list_district.insert(0, parts[0]);
        // list_substrict.insert(0, parts[1]);
        // list_province.insert(0, parts[2]);
      }
      // else {
      //   locations.insert(0, "");
      //   list_district.insert(0, "ไม่ระบุ");
      //   list_substrict.insert(0, "ไม่ระบุ");
      //   list_province.insert(0, "ไม่ระบุ");
      // }

      UserService userService = UserService();
      User? user =
          await userService.getUserByFieldID(fieldID, token.toString());
      if (user != null) {
        // owners.insert(0, user);
        title = user.title;
        fieldName = user.firstName;
        lastName = user.lastName;
        // list_title.insert(0, user.title);
        // list_firstName.insert(0, user.firstName);
        // list_lastName.insert(0, user.lastName);
      }
      // else {
      // owners.insert(
      //     0,
      //     User(
      //         -1,
      //         "service null",
      //         "service null",
      //         "service null",
      //         "service null",
      //         "service null",
      //         UserStatus.invalid,
      //         0,
      //         RequestInfoStatus.No));
      //   list_title.insert(0, "ไม่ระบุ");
      //   list_firstName.insert(0, "ไม่ระบุ");
      //   list_lastName.insert(0, "ไม่ระบุ");
      // }

      PlantingData newPlantingData = PlantingData(
          data.plantingId,
          data.name,
          fieldName,
          substrict,
          district,
          province,
          title,
          firstName,
          lastName,
          data);

      plantingData.insert(0, newPlantingData);
    }

    notifyListeners();
  }

  // void addPlantingToLast(Planting data) {
  //   plantings.add(data);
  //   notifyListeners();
  // }

  Future<int> deletePlanting(Planting planting) async {
    PlantingService plantingService = PlantingService();
    String? token = tokenFromLogin?.token;
    int statusCode =
        await plantingService.deletePlanting(token.toString(), planting);

    for (int i = 0; i < plantingData.length; i++) {
      if (planting.plantingId == plantingData[i].plantingId) {
        plantingData.removeAt(i);
        break;
      }
    }
    notifyListeners();
    return statusCode;
  }

  void search(Map<String, dynamic> data) async {
    reset();
    PlantingService plantingService = PlantingService();
    String? token = tokenFromLogin?.token;
    List<Planting> searchPlantings =
        await plantingService.searchPlantingByKey2(data, token.toString());
    // List<Planting> plant = this.plantings;

    for (int i = 0; i < searchPlantings.length; i++) {
      String? token = tokenFromLogin?.token;

      Field? field;
      FieldService fieldService = FieldService();
      field = await fieldService.getFieldByPlantingID(
          searchPlantings[i].plantingId, token.toString());

      if (field != null) {
        String fieldName = '';
        String district = 'ไม่ระบุ';
        String substrict = 'ไม่ระบุ';
        String province = 'ไม่ระบุ';
        String title = 'ไม่ระบุ';
        String firstName = 'ไม่ระบุ';
        String lastName = 'ไม่ระบุ';
        // fields.add(field);
        // list_fieldName.add(field.name);
        fieldName = field.name;
        print("search fieldName = ");
        print(fieldName);
        int fieldID = field.fieldID;

        String? location =
            await fieldService.getLocationByFielID(fieldID, token.toString());
        if (location != null) {
          // locations.add(location);
          List<String> parts =
              location.split(","); // แยกข้อความด้วยเครื่องหมาย ','

          district = parts[0];
          substrict = parts[1];
          province = parts[2];
          // list_district.insert(0, parts[0]);
          // list_substrict.insert(0, parts[1]);
          // list_province.insert(0, parts[2]);
        }
        // else {
        //   locations.add("");
        //   list_district.add("ไม่ระบุ");
        //   list_substrict.add("ไม่ระบุ");
        //   list_province.add("ไม่ระบุ");
        // }

        UserService userService = UserService();
        User? user =
            await userService.getUserByFieldID(fieldID, token.toString());
        if (user != null) {
          // owners.add(user);
          title = user.title;
          firstName = user.firstName;
          lastName = user.lastName;
          // list_title.insert(0, user.title);
          // list_firstName.insert(0, user.firstName);
          // list_lastName.insert(0, user.lastName);
        }
        // else {
        //   owners.add(User(
        //       -1,
        //       "service null",
        //       "service null",
        //       "service null",
        //       "service null",
        //       "service null",
        //       UserStatus.invalid,
        //       0,
        //       RequestInfoStatus.No));
        //   list_title.add("ไม่ระบุ");
        //   list_firstName.add("ไม่ระบุ");
        //   list_lastName.add("ไม่ระบุ");
        // }
        PlantingData newPlantingData = PlantingData(
            searchPlantings[i].plantingId,
            searchPlantings[i].name,
            fieldName,
            substrict,
            district,
            province,
            title,
            firstName,
            lastName,
            searchPlantings[i]);

        plantingData.add(newPlantingData);
      }
    }
    isLoading = true;
    numberAllPlantings = plantingData.length;
    notifyListeners();
  }

  void searchByKey(Map<String, dynamic> data) async {
    reset();
    PlantingService plantingService = PlantingService();
    String? token = tokenFromLogin?.token;

    // List<Planting> plantingTemp = [];
    List<Map<String, dynamic>> detail =
        await plantingService.search(data, _page, _value, token.toString());

    for (Map<String, dynamic> data in detail) {
      // Planting? source = await plantingService.getPlantingByID(
      //     data['plantingId'], token.toString());
      // plantingTemp.add(source!);
      // list_fieldName.add(data['fieldName']);
      // list_substrict.add(data['substrict']);
      // list_district.add(data['district']);
      // list_province.add(data['province']);
      // list_title.add(data['title']);
      // list_firstName.add(data['firstName']);
      // list_lastName.add(data['lastName']);
      Planting? planting = await plantingService.getPlantingByID(
          data['plantingId'], token.toString());
      if (planting != null) {
        plantingData.add(PlantingData(
            data['plantingId'],
            data['plantingName'],
            data['fieldName'],
            data['substrict'],
            data['district'],
            data['province'],
            data['title'],
            data['firstName'],
            data['lastName'],
            planting));
      }
    }
    // this.plantings = plantingTemp;
    numberAllPlantings = plantingData.length;
    isLoading = true;
    notifyListeners();
  }

  // void searchByKey(Map<String, dynamic> data) async {
  //   reset();
  //   PlantingService plantingService = PlantingService();
  //   String? token = tokenFromLogin?.token;
  //   plantings =
  //       await plantingService.search(data, token.toString());
  //   List<Planting> plant = this.plantings;
  //   for (int i = 0; i < plant.length; i++) {
  //     String? token = tokenFromLogin?.token;

  //     Field? field;
  //     FieldService fieldService = FieldService();
  //     field = await fieldService.getFieldByPlantingID(
  //         plant[i].plantingId, token.toString());

  //     if (field != null) {
  //       fields.add(field);
  //       list_fieldName.add(field.name);
  //       int fieldID = field.fieldID;

  //       String? location =
  //           await fieldService.getLocationByFielID(fieldID, token.toString());
  //       if (location != null) {
  //         locations.add(location);
  //         List<String> parts =
  //             location.split(","); // แยกข้อความด้วยเครื่องหมาย ','

  //         list_district.add(parts[0]);
  //         list_substrict.add(parts[1]);
  //         list_province.add(parts[2]);
  //       } else {
  //         locations.add("");
  //         list_district.add("ไม่ระบุ");
  //         list_substrict.add("ไม่ระบุ");
  //         list_province.add("ไม่ระบุ");
  //       }

  //       UserService userService = UserService();
  //       User? user =
  //           await userService.getUserByFieldID(fieldID, token.toString());
  //       if (user != null) {
  //         owners.add(user);
  //         list_title.add(user.title);
  //         list_firstName.add(user.firstName);
  //         list_lastName.add(user.lastName);
  //       } else {
  //         owners.add(User(
  //             -1,
  //             "service null",
  //             "service null",
  //             "service null",
  //             "service null",
  //             "service null",
  //             UserStatus.invalid,
  //             0,
  //             RequestInfoStatus.No));
  //         list_title.add("ไม่ระบุ");
  //         list_firstName.add("ไม่ระบุ");
  //         list_lastName.add("ไม่ระบุ");
  //       }
  //     }
  //   }
  //   isLoading = true;
  //   notifyListeners();
  // }
}
