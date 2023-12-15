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
  Field field;
  User owner;
  String location;
  ImageData? image;
  bool isLoading;
  FieldData(this.field, this.owner, this.location, this.image, this.isLoading);
}

class FieldProviders with ChangeNotifier {
  // List<Field> fields = [];
  // List<User> owner = [];
  // List<String> locations = [];
  // List<ImageData?> images = [];
  bool isLoading = false;
  int _value = 20;
  int _page = 1;
  int numberAllFields = 0;

  // Adding new
  List<FieldData> fieldData = [];

  void reset() {
    isLoading = false;
    // fields = [];
    // owner = [];
    // locations = [];
    // images = [];

    // adding
    fieldData.clear();

    _page = 1;
  }

  Future<void> fetchData() async {
    // List<Field> data = [];
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;

    print("token : ${token}");

    numberAllFields = await fieldService.countFields(token.toString());

    if (numberAllFields == 0 ||
        numberAllFields == fieldData.length ||
        (fieldData.length > 0 && fieldData.last.isLoading)) {
      //setFetch(false);
      notifyListeners();
      return;
    }

    _value = 20;

    isLoading = false;

    notifyListeners();

    _value = numberAllFields < _value ? numberAllFields : _value;

    int index = ((_page - 1) * _value);

    String none = "";

    Field fv = Field(0, 0, none, none, none, none, none, none, 0, none, 0, 0, 0,
        0, none, 0, 0, 0, 0, false);
    User os = User(0, none, none, none, none, none, UserStatus.invalid, 0,
        RequestInfoStatus.No);

    int dummySize = fieldData.length + _value < numberAllFields
        ? _value
        : numberAllFields - fieldData.length;

    for (int i = 0; i < dummySize; i++) {
      fieldData.add(FieldData(fv, os, none, null, true));
    }
    await fieldService
        .getFields(token.toString(), _page, _value)
        .then((value) async {
      if (value != null) {
        for (Field data in value) {
          int fieldID = data.fieldID;

          if (fieldData.isEmpty) return;
          // Image
          ImageData? fetchedImages =
              await fieldService.fetchImages(token.toString(), fieldID);

          if (fetchedImages == null) {
            fetchedImages = null;
          }

          // Location
          String? location =
              await fieldService.getLocationByFielID(fieldID, token.toString());
          if (location == null) {
            location = "";
          }

          // Owner
          UserService userService = UserService();
          User? user =
              await userService.getUserByFieldID(fieldID, token.toString());
          if (user == null) {
            user = User(
                -1,
                "service null",
                "service null",
                "service null",
                "service null",
                "service null",
                UserStatus.invalid,
                0,
                RequestInfoStatus.No);
          }
          fieldData[index].field = data;
          fieldData[index].image = fetchedImages;
          fieldData[index].location = location;
          fieldData[index].owner = user;
          fieldData[index].isLoading = false;
          new Future.delayed(const Duration(seconds: 2), () {});

          index++;
        }
        _page = (fieldData.length ~/ _value) + 1;
      }
    });

    // if (fields.length % _value != 0) {
    //   int x = fields.length % _value;
    //   for (int i = 0; i < x; i++) {
    //     fields.removeLast();
    //   }
    //   fields = [...fields, ...data];
    // } else {
    //   fields = [...fields, ...data];
    // }

    // _page = (fields.length ~/ _value) + 1;

    // for (int i = 0; i < fields.length; i++) {
    //   String? token = tokenFromLogin?.token;

    //   int fieldID = fields[i].fieldID;

    //   ImageData? fetchedImages =
    //       await fieldService.fetchImages(token.toString(), fieldID);

    //   if (fetchedImages != null) {
    //     images.add(fetchedImages);
    //   } else {
    //     images.add(null);
    //   }

    //   String? location =
    //       await fieldService.getLocationByFielID(fieldID, token.toString());
    //   if (location != null) {
    //     locations.add(location);
    //   } else {
    //     locations.add("");
    //   }

    //   UserService userService = UserService();
    //   User? user = await userService.getUserByFieldID(
    //       fields[i].fieldID, token.toString());
    //   if (user != null) {
    //     owner.add(user);
    //   } else {
    //     owner.add(User(
    //         -1,
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         UserStatus.invalid,
    //         0,
    //         RequestInfoStatus.No));
    //   }
    // }
    notifyListeners();
    isLoading = true;
  }

  void search(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    // fields = await fieldService.searchFieldsByKey2(data, token.toString());

    // List<Field> data2 = this.fields;
    // numberAllFields = this.fields.length;
    // for (int i = 0; i < fields.length; i++) {
    //   String? token = tokenFromLogin?.token;

    //   int fieldID = fields[i].fieldID;

    //   ImageData? fetchedImages =
    //       await fieldService.fetchImages(token.toString(), fieldID);

    //   if (fetchedImages != null) {
    //     images.add(fetchedImages);
    //   } else {
    //     images.add(null);
    //   }

    //   String? location =
    //       await fieldService.getLocationByFielID(fieldID, token.toString());
    //   if (location != null) {
    //     locations.add(location);
    //   } else {
    //     locations.add("");
    //   }

    //   UserService userService = UserService();
    //   User? user = await userService.getUserByFieldID(
    //       fields[i].fieldID, token.toString());
    //   if (user != null) {
    //     owner.add(user);
    //   } else {
    //     owner.add(User(
    //         -1,
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         UserStatus.invalid,
    //         0,
    //         RequestInfoStatus.No));
    //   }
    // }
    int index = 0;
    await fieldService
        .searchFieldsByKey2(data, token.toString())
        .then((value) async {
      if (value != null) {
        for (Field data in value) {
          int fieldID = data.fieldID;

          if (fieldData.isEmpty) return;
          // Image
          ImageData? fetchedImages =
              await fieldService.fetchImages(token.toString(), fieldID);

          if (fetchedImages == null) {
            fetchedImages = null;
          }

          // Location
          String? location =
              await fieldService.getLocationByFielID(fieldID, token.toString());
          if (location == null) {
            location = "";
          }

          // Owner
          UserService userService = UserService();
          User? user =
              await userService.getUserByFieldID(fieldID, token.toString());
          if (user == null) {
            user = User(
                -1,
                "service null",
                "service null",
                "service null",
                "service null",
                "service null",
                UserStatus.invalid,
                0,
                RequestInfoStatus.No);
          }
          fieldData[index].field = data;
          fieldData[index].image = fetchedImages;
          fieldData[index].location = location;
          fieldData[index].owner = user;
          fieldData[index].isLoading = false;
          new Future.delayed(const Duration(seconds: 2), () {});

          index++;
        }
      }
    });
    isLoading = true;
    numberAllFields = fieldData.length;
    notifyListeners();
  }

  void searchByKey(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    // fields = await fieldService.search(data, token.toString());

    // List<Field> data2 = this.fields;
    // numberAllFields = this.fields.length;
    // for (int i = 0; i < fields.length; i++) {
    //   String? token = tokenFromLogin?.token;

    //   int fieldID = fields[i].fieldID;

    //   ImageData? fetchedImages =
    //       await fieldService.fetchImages(token.toString(), fieldID);

    //   if (fetchedImages != null) {
    //     images.add(fetchedImages);
    //   } else {
    //     images.add(null);
    //   }

    //   String? location =
    //       await fieldService.getLocationByFielID(fieldID, token.toString());
    //   if (location != null) {
    //     locations.add(location);
    //   } else {
    //     locations.add("");
    //   }

    //   UserService userService = UserService();
    //   User? user = await userService.getUserByFieldID(
    //       fields[i].fieldID, token.toString());
    //   if (user != null) {
    //     owner.add(user);
    //   } else {
    //     owner.add(User(
    //         -1,
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         UserStatus.invalid,
    //         0,
    //         RequestInfoStatus.No));
    //   }
    // }

    int index = 0;
    await fieldService.search(data, token.toString()).then((value) async {
      if (value != null) {
        for (Field data in value) {
          int fieldID = data.fieldID;

          if (fieldData.isEmpty) return;
          // Image
          ImageData? fetchedImages =
              await fieldService.fetchImages(token.toString(), fieldID);

          if (fetchedImages == null) {
            fetchedImages = null;
          }

          // Location
          String? location =
              await fieldService.getLocationByFielID(fieldID, token.toString());
          if (location == null) {
            location = "";
          }

          // Owner
          UserService userService = UserService();
          User? user =
              await userService.getUserByFieldID(fieldID, token.toString());
          if (user == null) {
            user = User(
                -1,
                "service null",
                "service null",
                "service null",
                "service null",
                "service null",
                UserStatus.invalid,
                0,
                RequestInfoStatus.No);
          }
          fieldData[index].field = data;
          fieldData[index].image = fetchedImages;
          fieldData[index].location = location;
          fieldData[index].owner = user;
          fieldData[index].isLoading = false;
          new Future.delayed(const Duration(seconds: 2), () {});

          index++;
        }
      }
    });
    isLoading = true;
    numberAllFields = fieldData.length;
    notifyListeners();
  }

  void searchNull(Map<String, dynamic> data) async {
    reset();
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    // fields =
    //     await fieldService.searchNull(data, _page, _value, token.toString());

    // List<Field> data2 = this.fields;
    // numberAllFields = this.fields.length;
    // for (int i = 0; i < fields.length; i++) {
    //   String? token = tokenFromLogin?.token;

    //   int fieldID = fields[i].fieldID;

    //   ImageData? fetchedImages =
    //       await fieldService.fetchImages(token.toString(), fieldID);

    //   if (fetchedImages != null) {
    //     images.add(fetchedImages);
    //   } else {
    //     images.add(null);
    //   }

    //   String? location =
    //       await fieldService.getLocationByFielID(fieldID, token.toString());
    //   if (location != null) {
    //     locations.add(location);
    //   } else {
    //     locations.add("");
    //   }

    //   UserService userService = UserService();
    //   User? user = await userService.getUserByFieldID(
    //       fields[i].fieldID, token.toString());
    //   if (user != null) {
    //     owner.add(user);
    //   } else {
    //     owner.add(User(
    //         -1,
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         "service null",
    //         UserStatus.invalid,
    //         0,
    //         RequestInfoStatus.No));
    //   }
    // }
    int index = 0;
    await fieldService
        .searchNull(data, _page, _value, token.toString())
        .then((value) async {
      if (value != null) {
        for (Field data in value) {
          int fieldID = data.fieldID;

          if (fieldData.isEmpty) return;
          // Image
          ImageData? fetchedImages =
              await fieldService.fetchImages(token.toString(), fieldID);

          if (fetchedImages == null) {
            fetchedImages = null;
          }

          // Location
          String? location =
              await fieldService.getLocationByFielID(fieldID, token.toString());
          if (location == null) {
            location = "";
          }

          // Owner
          UserService userService = UserService();
          User? user =
              await userService.getUserByFieldID(fieldID, token.toString());
          if (user == null) {
            user = User(
                -1,
                "service null",
                "service null",
                "service null",
                "service null",
                "service null",
                UserStatus.invalid,
                0,
                RequestInfoStatus.No);
          }
          fieldData[index].field = data;
          fieldData[index].image = fetchedImages;
          fieldData[index].location = location;
          fieldData[index].owner = user;
          fieldData[index].isLoading = false;
          new Future.delayed(const Duration(seconds: 2), () {});

          index++;
        }
      }
    });
    isLoading = true;
    numberAllFields = fieldData.length;
    notifyListeners();
  }

  void addField(Field data) async {
    String? token = tokenFromLogin?.token;
    FieldService fieldService = FieldService();
    // print("addField ${data.fieldID}");

    int fieldID = data.fieldID;

    ImageData? fetchedImages =
        await fieldService.fetchImages(token.toString(), fieldID);

    if (fetchedImages == null) {
      fetchedImages = null;
    }

    String? location =
        await fieldService.getLocationByFielID(fieldID, token.toString());
    if (location == null) {
      location = "";
    }

    UserService userService = UserService();
    User? user =
        await userService.getUserByFieldID(data.fieldID, token.toString());
    // print("addField ${user!.firstName} ${user.lastName}");
    if (user == null) {
      user = User(
          -1,
          "service null",
          "service null",
          "service null",
          "service null",
          "service null",
          UserStatus.invalid,
          0,
          RequestInfoStatus.No);
    }

    FieldData newFieldData =
        FieldData(data, user, location, fetchedImages, false);

    fieldData.insert(0, newFieldData);

    notifyListeners();
  }
}
