import 'package:flutter/cupertino.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class Dropdown {
  String title;
  int id;

  Dropdown(this.title, this.id);
}

class DropdownProvider with ChangeNotifier {
  List<Dropdown> dropdown = [];
  int page = 1;
  int value = 5;
  int time = DateTime.now().millisecondsSinceEpoch;

  Future<List<Dropdown>> getFields() async {
    List<Field> data = [];
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    data = await fieldService.getFields(token.toString(), page, value);
    List<Dropdown> dataConvert = [];
    for (int i = 0; i < data.length; i++) {
      dataConvert.add(Dropdown(data[i].name.toString(), data[i].fieldID));
    }
    if (dropdown.length % value != 0) {
      int x = dropdown.length % value;
      for (int i = 0; i < x; i++) {
        dropdown.removeLast();
      }
      dropdown = [...dropdown, ...dataConvert];
    } else {
      dropdown = [...dropdown, ...dataConvert];
    }

    return dropdown;
  }
  // Future<void> getFields() async {
  //   List<Field> data = [];
  //   FieldService fieldService = FieldService();
  //   String? token = tokenFromLogin?.token;
  //   data = await fieldService.getFields(token.toString(), page, value);
  //   List<Dropdown> dataConvert = [];
  //   for (int i = 0; i < data.length; i++) {
  //     dataConvert.add(Dropdown(data[i].name.toString(), data[i].fieldID));
  //   }
  //   if (dropdown.length % value != 0) {
  //     int x = dropdown.length % value;
  //     for (int i = 0; i < x; i++) {
  //       dropdown.removeLast();
  //     }
  //     dropdown = [...dropdown, ...dataConvert];
  //   } else {
  //     dropdown = [...dropdown, ...dataConvert];
  //   }

  //   // return dropdown;
  // }
}
