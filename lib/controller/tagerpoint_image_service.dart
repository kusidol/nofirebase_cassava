import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:mun_bot/entities/response.dart' as EntityResponse;

import '../env.dart';

class ImageData {
  final int imageId;
  final String imgBase64;

  ImageData({required this.imageId, required this.imgBase64});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      imageId: json['imageId'],
      imgBase64: json['imgBase64'],
    );
  }
}

List<ImageData> parseImages(String responseBody) {
  final parsed = json.decode(responseBody)['body'].cast<Map<String, dynamic>>();
  return parsed.map<ImageData>((json) => ImageData.fromJson(json)).toList();
}

// Sevice
class ImageTagetpointService {

  Future<List<ImageData>> fetchImages(String token, int targetpointId) async {
    //print('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    //print(token);
    final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    //final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/getimage/$targetpointId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return parseImages(response.body);
    } else {
      return [];
    }
  }

  Future<ImageData?> uploadImage(
      String imageFile, String token, int targetpointId) async {
    final url = '$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images';
    //final url = '$LOCAL_SERVER_IP_URL/survey/uploadimage/$targetpointId';
    //print(url);
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    Uint8List imageBytes = base64Decode(imageFile);
    //print(imageBytes) ;
    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(imageBytes, filename: 'image.jpg'),
      'targetpointId': targetpointId.toString(),
    });

    try {
      var response = await Dio()
          .post(url, data: formData, options: Options(headers: headers));
      //Map<String, dynamic> map  = json.decode(response.data);
      //print(response.data);
      if (response.statusCode == 200) {
       // print("Image uploaded successfully"+ "${response}");
        print(response.data);
        Map apiResponse = response.data;
        ImageData imageData = ImageData(imageId: apiResponse["body"]["imageId"], imgBase64: apiResponse["body"]["imgBase64"].toString());


        return imageData;
      } else {
        //print('Failed to upload image');
        return null;
      }
    } catch (e) {
      //print('Error uploading image: $e');
      return null;
    }
  }

  Future<int?> deleteImageByID(int targetpointId,int id, String token) async {
   // final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images/$id');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print("Image deleted successfully");
      return response.statusCode;
    }
    else {
      return response.statusCode;
      //throw Exception('Failed to delete image');
    }
  }

  Future<int?> deleteImageByTargetpointId(int targetpointId, String token) async {
     final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    //final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images/$id');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print("Image deleted successfully");
      return response.statusCode;
    }
    else {
      return response.statusCode;
      //throw Exception('Failed to delete image');
    }
  }


  Future<int?> deleteAllImage(int targetpointId, String token) async {
    // final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print("Image deleted successfully");
      return response.statusCode;
    }
    else {
      return response.statusCode;
      //throw Exception('Failed to delete image');
    }
  }

}
