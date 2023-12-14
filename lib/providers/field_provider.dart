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

class FieldData {
  int fieldId;
  String fieldName;
  String substrict;
  String district;
  String province;
  String title;
  String firstName;
  String lastName;
  bool isLoading;
  FieldData(this.fieldId, this.fieldName, this.substrict, this.district,
      this.province, this.title, this.firstName, this.lastName, this.isLoading);
}

class FieldProviders with ChangeNotifier {
  bool isHaveField = false;
  // List<Field> fields = [];
  // List<User> owner = [];
  // List<String> locations = [];
  // List<ImageData?> images = [];

  bool isLoading = false;
  int _value = 20;
  int _page = 1;
  bool isSearch = false;
  bool _fetch = false;
  int fieldID = 0;
  String fieldName = "";
  int numberAllFields = 0;
  List<FieldData> fieldData = [];

  void reset() {
    isLoading = false;
    if (!isFetch()) {
      fieldData.clear();
    }
    // fields = [];
    // owner = [];
    // locations = [];
    // images = [];
    _page = 1;
  }

  void resetFieldID() {
    fieldID = 0;
    fieldName = "";
  }

  bool isFetch() {
    return _fetch;
  }

  setFetch(bool fetch) {
    this._fetch = fetch;

    ///notifyListeners();
  }

  Future<void> fetchData() async {
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    int count = await fieldService.countFields(token.toString());

    numberAllFields = count;

    if (numberAllFields == 0 || numberAllFields == fieldData.length) {
      notifyListeners();
      return;
    }

    _value = 20;

    isLoading = false;

    notifyListeners();

    _value = numberAllFields < _value ? numberAllFields : _value;

    int index = ((_page - 1) * _value);

    String none = "";

    FieldData pt = FieldData(0, none, none, none, none, none, none, none, true);

    int dummySize = fieldData.length + _value < numberAllFields
        ? _value
        : numberAllFields - fieldData.length;

    for (int i = 0; i < dummySize; i++) {
      fieldData
          .add(FieldData(0, none, none, none, none, none, none, none, true));
    }

    notifyListeners();

    await fieldService
        .getFieldsByUserID(
      _value,
      token.toString(),
    )
        .then((value) async {
      if (value != null) {
        for (Map<String, dynamic> data in value) {
          Field? field = await fieldService.getFieldByFieldID(
              data['fieldID'], token.toString());

          fieldData[index].fieldId = data['fieldID'];
          fieldData[index].fieldName = data['fieldName'];
          fieldData[index].substrict = data['substrict'];
          fieldData[index].district = data['district'];
          fieldData[index].province = data['province'];
          fieldData[index].firstName = data['firstName'];
          fieldData[index].lastName = data['lastName'];
          fieldData[index].isLoading = false;

          notifyListeners();

          new Future.delayed(const Duration(seconds: 2), () {});

          index++;
        }

        _page = (fieldData.length ~/ _value) + 1;

        setFetch(false);
      }
    });

    isLoading = true;
    if (count > 0) {
      isHaveField = true;
    }
    notifyListeners();
  }

  void search(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;

    if (fieldID != 0) {
      data["fieldId"] = fieldID.toString();
    }

    await fieldService.searchFieldsByKey2(data, token.toString()).then((value) async {
      if (value != null) {
        print(value);
        await _doSearch(value, 0);
      }
    });

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
