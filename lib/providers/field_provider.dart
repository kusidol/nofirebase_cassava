import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class FieldProviders with ChangeNotifier {
  List<Field> fields = [];
  List<User> owner = [];
  List<String> locations = [];
  List<ImageData?> images = [];
  bool isLoading = false;
  final int _value = 5;
  int _page = 1;
  int numberAllFields = 0;
  void reset() {
    isLoading = false;
    fields = [];
    owner = [];
    locations = [];
    images = [];
    _page = 1;
  }

  Future<void> fetchData() async {
    List<Field> data = [];
    FieldService fieldService = FieldService();

    String? token = tokenFromLogin?.token;
    data = await fieldService.getFields(token.toString(), _page, _value);
    numberAllFields = await fieldService.countFields(token.toString());
    if (fields.length % _value != 0) {
      int x = fields.length % _value;
      for (int i = 0; i < x; i++) {
        fields.removeLast();
      }
      fields = [...fields, ...data];
    } else {
      fields = [...fields, ...data];
    }

    _page = (fields.length ~/ _value) + 1;

    for (int i = 0; i < fields.length; i++) {
      String? token = tokenFromLogin?.token;

      int fieldID = fields[i].fieldID;

      ImageData? fetchedImages =
          await fieldService.fetchImages(token.toString(), fieldID);

      if (fetchedImages != null) {
        images.add(fetchedImages);
      } else {
        images.add(null);
      }

      String? location =
          await fieldService.getLocationByFielID(fieldID, token.toString());
      if (location != null) {
        locations.add(location);
      } else {
        locations.add("");
      }

      UserService userService = UserService();
      User? user = await userService.getUserByFieldID(
          fields[i].fieldID, token.toString());
      if (user != null) {
        owner.add(user);
      } else {
        owner.add(User(
            -1,
            "service null",
            "service null",
            "service null",
            "service null",
            "service null",
            UserStatus.invalid,
            0,
            RequestInfoStatus.No));
      }
    }
    notifyListeners();
    isLoading = true;
  }

  void search(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    fields = await fieldService.searchFieldsByKey2(data, token.toString());

    List<Field> data2 = this.fields;
    numberAllFields = this.fields.length;
    for (int i = 0; i < fields.length; i++) {
      String? token = tokenFromLogin?.token;

      int fieldID = fields[i].fieldID;

      ImageData? fetchedImages =
          await fieldService.fetchImages(token.toString(), fieldID);

      if (fetchedImages != null) {
        images.add(fetchedImages);
      } else {
        images.add(null);
      }

      String? location =
          await fieldService.getLocationByFielID(fieldID, token.toString());
      if (location != null) {
        locations.add(location);
      } else {
        locations.add("");
      }

      UserService userService = UserService();
      User? user = await userService.getUserByFieldID(
          fields[i].fieldID, token.toString());
      if (user != null) {
        owner.add(user);
      } else {
        owner.add(User(
            -1,
            "service null",
            "service null",
            "service null",
            "service null",
            "service null",
            UserStatus.invalid,
            0,
            RequestInfoStatus.No));
      }
    }
    isLoading = true;
    notifyListeners();
  }

  void searchByKey(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    fields = await fieldService.search(data, token.toString());

    List<Field> data2 = this.fields;
    numberAllFields = this.fields.length;
    for (int i = 0; i < fields.length; i++) {
      String? token = tokenFromLogin?.token;

      int fieldID = fields[i].fieldID;

      ImageData? fetchedImages =
          await fieldService.fetchImages(token.toString(), fieldID);

      if (fetchedImages != null) {
        images.add(fetchedImages);
      } else {
        images.add(null);
      }

      String? location =
          await fieldService.getLocationByFielID(fieldID, token.toString());
      if (location != null) {
        locations.add(location);
      } else {
        locations.add("");
      }

      UserService userService = UserService();
      User? user = await userService.getUserByFieldID(
          fields[i].fieldID, token.toString());
      if (user != null) {
        owner.add(user);
      } else {
        owner.add(User(
            -1,
            "service null",
            "service null",
            "service null",
            "service null",
            "service null",
            UserStatus.invalid,
            0,
            RequestInfoStatus.No));
      }
    }
    isLoading = true;
    notifyListeners();
  }

  void searchNull(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    fields =
        await fieldService.searchNull(data, _page, _value, token.toString());

    List<Field> data2 = this.fields;
    numberAllFields = this.fields.length;
    for (int i = 0; i < fields.length; i++) {
      String? token = tokenFromLogin?.token;

      int fieldID = fields[i].fieldID;

      ImageData? fetchedImages =
          await fieldService.fetchImages(token.toString(), fieldID);

      if (fetchedImages != null) {
        images.add(fetchedImages);
      } else {
        images.add(null);
      }

      String? location =
          await fieldService.getLocationByFielID(fieldID, token.toString());
      if (location != null) {
        locations.add(location);
      } else {
        locations.add("");
      }

      UserService userService = UserService();
      User? user = await userService.getUserByFieldID(
          fields[i].fieldID, token.toString());
      if (user != null) {
        owner.add(user);
      } else {
        owner.add(User(
            -1,
            "service null",
            "service null",
            "service null",
            "service null",
            "service null",
            UserStatus.invalid,
            0,
            RequestInfoStatus.No));
      }
    }
    isLoading = true;
    notifyListeners();
  }

  void addField(Field data) async {
    String? token = tokenFromLogin?.token;
    FieldService fieldService = FieldService();
    print("addField ${data.fieldID}");

    int fieldID = data.fieldID;

    ImageData? fetchedImages =
        await fieldService.fetchImages(token.toString(), fieldID);

    if (fetchedImages != null) {
      images.insert(0, fetchedImages);
    } else {
      images.insert(0, null);
    }

    String? location =
        await fieldService.getLocationByFielID(fieldID, token.toString());
    if (location != null) {
      locations.insert(0, location);
    } else {
      locations.insert(0, "");
    }

    UserService userService = UserService();
    User? user =
        await userService.getUserByFieldID(data.fieldID, token.toString());
    print("addField ${user!.firstName} ${user.lastName}");

    if (user != null) {
      owner.insert(0, user);
    } else {
      owner.insert(
          0,
          User(
              -1,
              "service null",
              "service null",
              "service null",
              "service null",
              "service null",
              UserStatus.invalid,
              0,
              RequestInfoStatus.No));
    }
    fields.insert(0, data);
    notifyListeners();
  }
}
