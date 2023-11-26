import 'package:flutter/foundation.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class FieldProvider with ChangeNotifier {
  List<Field> fields = [];
  final int _value = 2;
  int _page = 1;

  FieldProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    List<Field> data = [];
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    data = await fieldService.getFields(token.toString(), _page, _value);

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

    notifyListeners();
  }

  Future<void> fetchDataPagination() async {
    int checkCount = 0;
    print("Page : ${_page}");
    List<Field> data = [];
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    data = await fieldService.getFields(token.toString(), _page, _value);
    for (int i = 0; i < data.length; i++) {
      print(data[i].fieldID);
      checkCount++;
    }
    if (checkCount == _value) {
      _page++;
      fields = [...fields, ...data];
    } else {
      if (checkCount != 0) {
        _page++;
        fields = [...fields, ...data];
      }
    }
    notifyListeners();
  }

  void resetFields() async {
    _page = 1;
    fields = [];
    List<Field> data = [];
    FieldService fieldService = FieldService();
    String? token = tokenFromLogin?.token;
    data = await fieldService.getFields(token.toString(), _page, _value);
    fields = [...fields, ...data];
    _page++;
    notifyListeners();
  }

  List<Field> getFields() {
    return fields;
  }
}
