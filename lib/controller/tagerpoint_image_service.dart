import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

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
    final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images');
    //final url = Uri.parse('$LOCAL_SERVER_IP_URL/survey/getimage/$targetpointId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      return parseImages(response.body);
    } else {
      throw Exception('Failed to fetch images');
    }
  }

  Future<int?> uploadImage(
      String imageFile, String token, int targetpointId) async {
    final url = '$LOCAL_SERVER_IP_URL/survey/surveytargetpoint/$targetpointId/images';
    //final url = '$LOCAL_SERVER_IP_URL/survey/uploadimage/$targetpointId';
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    Uint8List imageBytes = base64Decode(imageFile);

    FormData formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(imageBytes, filename: 'image.jpg'),
      'targetpointId': targetpointId.toString(),
    });

    try {
      final response = await Dio()
          .post(url, data: formData, options: Options(headers: headers));

      if (response.statusCode == 200) {
        print("Image uploaded successfully");
        return response.statusCode;
      } else {
        print('Failed to upload image');
        return response.statusCode;
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Failed to upload image');
    }
  }

  Future<int?> deleteImage(int targetpointId,int id, String token) async {
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
}
