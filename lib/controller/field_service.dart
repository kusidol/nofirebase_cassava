import 'dart:convert';
import 'dart:developer';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/entities/response.dart' as EntityResponse;
import 'package:http/http.dart' as http;

class ImageData {
  final int fieldId;
  final String imgBase64;

  ImageData({required this.fieldId, required this.imgBase64});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      fieldId: json['fieldId'] as int,
      imgBase64: json['imgBase64'] as String,
    );
  }
}

ImageData? parseImages(String responseBody) {
  try {
    if (responseBody == null || responseBody.isEmpty) {
      return null;
    }

    Map<String, dynamic> jsonData = jsonDecode(responseBody);
    if (jsonData == null) {
      return null;
    }

    int fieldId = jsonData['body']['fieldId'];
    String imgBase64 = jsonData['body']['imgBase64'] as String;
    if (imgBase64 == "") {
      return null;
    }
    return ImageData(fieldId: fieldId, imgBase64: imgBase64);
  } catch (e) {
    print('Error parsing images: $e');
  }
}

class FieldService {
  Future<Field?> createField(String token, var field) async {
    Service service = new Service();
    String value = jsonEncode(field);

    Field? newField;

    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/", token, value);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      print("addField service ${res}");
      newField = Field.fromJson(res['body']);
      print("addField service ${newField.fieldID}");
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return newField;
  }

  Future<int> updateField(String token, var field) async {
    Service service = new Service();
    String value = jsonEncode(field);
    var response =
        await service.update("${LOCAL_SERVER_IP_URL}/fields/", token, value);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return response.statusCode;
  }

  Future<List<Field>> getFields(String token, int page, int value) async {
    int date = DateTime.now().millisecondsSinceEpoch;
    List<Field> fields = [];
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/page/${page}/value/${value}/date/${date}",
        token);
    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<List<Field>> getFieldsByUserID(int value, String token) async {
    List<Field> fields = [];
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/user/$value", token);
    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<Field?> getFieldByPlantingID(int ID, String token) async {
    Field? fields;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/planting/${ID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        fields = Field.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<List<Field>> getFieldsBySubdistrict(String token) async {
    List<Field> fields = [];
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/page/1", token);
    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<Field?> getFieldFromSurveyID(int surveyID, String token) async {
    Field? fields;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/survey/${surveyID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        fields = Field.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<List<Field>> searchFieldByKey(
      String address, String fieldName, String ownerName, String token) async {
    Map<String, dynamic> jsonData = {
      "address": address,
      "fieldName": fieldName,
      "ownerName": ownerName,
    };
    List<Field> fields = [];
    Service fieldsService = new Service();
    var response = await fieldsService.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/search", token, jsonData);

    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<ImageData?> fetchImages(String token, int id) async {
    final url = Uri.parse('$LOCAL_SERVER_IP_URL/fields/$id/imgBase64');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return parseImages(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to fetch images');
    }
  }

  Future<User?> getOwnerByfieldIdAndRole(int fieldId, String token) async {
    User? fields;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/users/owner/field/${fieldId}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        fields = User.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<Field?> getFieldByFieldID(int fieldID, String token) async {
    Field? field;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        field = Field.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return field;
  }

  Future<String?> getLocationByFielID(int fieldID, String token) async {
    String? location;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldID}/address", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        String substrict = res['body']['substrict'].toString();
        String district = res['body']['district'].toString();
        String province = res['body']['province'].toString();
        location = "${district},${substrict},${province}";
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return location;
  }

  Future<String?> getLocationByFielIDs(int fieldID, String token) async {
    String? location;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldID}/address", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        String substrict = res['body']['substrict'].toString();
        String district = res['body']['district'].toString();
        String province = res['body']['province'].toString();
        location = "${district},${province}";
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return location;
  }

  Future<String?> getAddressByFielID(
      int fieldID, String token, int select) async {
    String? location;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldID}/address", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        String substrict = res['body']['substrict'].toString();
        String district = res['body']['district'].toString();
        String province = res['body']['province'].toString();
        if (select == 3) {
          location = "${province}";
        } else if (select == 2) {
          location = "${district}";
        } else {
          location = "${substrict}";
        }
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return location;
  }

  Future<List<Field>> searchFieldsByKey2(
      Map<String, dynamic> data, String token) async {
    List<Field> fields = [];
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/search", token, data);

    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<List<Field>> search(Map<String, dynamic> data, String token) async {
    List<Field> fields = [];
    int page = 1;
    int value = 100;
    int date = DateTime.now().millisecondsSinceEpoch;
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/searchbykey/page/$page/value/$value/date/$date",
        token,
        data);

    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<List<Field>> searchNull(
      Map<String, dynamic> data, int page, int value, String token) async {
    List<Field> fields = [];
    value = 10;
    int date = DateTime.now().millisecondsSinceEpoch;
    Service service = new Service();
    var response = await service.doPostWithFormData(
        "${LOCAL_SERVER_IP_URL}/fields/search/page/$page/value/$value/date/$date",
        token,
        data);

    if (response.statusCode == 200) {
      fields = ObjectList<Field>.fromJson(
          jsonDecode(response.data), (body) => Field.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return fields;
  }

  Future<int> countFields(String token) async {
    int count = 0;
    Service service = new Service();
    var response =
        await service.doGet("${LOCAL_SERVER_IP_URL}/fields/countfield", token);
    if (response.statusCode == 200) {
      Map<String, dynamic> res = jsonDecode(response.data);
      count = res['body'];
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return count;
  }

  Future<bool> getEditableFieldID(int fieldID, String token) async {
    Field? field;
    bool editable = false;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/${fieldID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        field = Field.fromJson(res['body']);
        editable = field.editable;
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return editable;
  }

  Future<bool> checkFieldRegistrar(String token) async {
    bool result = false;
    Service fieldsService = new Service();
    var response = await fieldsService.doGet(
        "${LOCAL_SERVER_IP_URL}/fields/checkfieldregistrar", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        result = res['body'];
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return result;
  }
}
