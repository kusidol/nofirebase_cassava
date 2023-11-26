import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/response.dart' as EntityResponse;
import '../entities/objectlist.dart';

class Service {

  Future<dynamic> doDelete(String url, String token) async {
    BaseOptions baseOp = BaseOptions(
      followRedirects: false,
      baseUrl: url,
      connectTimeout: 5000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': 'Bearer ${token}'
      },
    );

    Dio dio = new Dio(baseOp);
    Response<String> response;
    try {
      Response<String> response = await dio.delete(
        url,
        // options: Options(headers: {
        //   HttpHeaders.contentTypeHeader: "application/json;charset=UTF-8",
        //   'Authorization': 'Bearer ${token}'
        // }),
      );
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
      }
      if (e.response != null) if (e.response!.statusCode == 401) {
        return http.Response('Unauthorized', 401);
      }
      if (e.response != null) if (e.response!.statusCode == 400) {
        final response = Response<String>(
          requestOptions: RequestOptions(path: ''),
          data: e.response!.data.toString(),
          statusCode: 400,
        );
        //print(response.data);
        return response;
      }
    }
    return http.Response('Service unavaiable', 500);
  }

  Future<dynamic> doGet(String url, String token) async {
    BaseOptions baseOp = BaseOptions(
      followRedirects: false,
      baseUrl: url,
      connectTimeout: 5000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': 'Bearer ${token}'
      },
    );

    Dio dio = new Dio(baseOp);
    Response<String> response;
    try {
      Response<String> response = await dio.get(
        url,
        // options: Options(headers: {
        //   HttpHeaders.contentTypeHeader: "application/json;charset=UTF-8",
        //   'Authorization': 'Bearer ${token}'
        // }),
      );
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
      }
      if (e.response != null) if (e.response!.statusCode == 401) {
        return http.Response('Unauthorized', 401);
      }
      if (e.response != null) if (e.response!.statusCode == 400) {
        final response = Response<String>(
          requestOptions: RequestOptions(path: ''),
          data: e.response!.data.toString(),
          statusCode: 400,
        );
        //print(response.data);
        return response;
      }
    }
    return http.Response('Service unavaiable', 500);
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<dynamic> doPostWithFormData(
      String url, String token, var object) async {
    BaseOptions baseOp = BaseOptions(
      followRedirects: false,
      baseUrl: url,
      connectTimeout: 3000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': 'Bearer ${token}'
      },
    );
    Dio dio = new Dio(baseOp);

    try {
      Response<String> response = await dio.post(
        url,
        // options: Options(
        //   followRedirects: false,
        //   headers: {
        //     HttpHeaders.contentTypeHeader: "application/json",
        //     'Authorization': 'Bearer ${token}'
        //   },
        // ),
        data: object,
      );
      //print(response);
      return response;
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
        // } else if (e.response.statusCode == 404) {
        //   return http.Response('Error', 404);
        // } else if (e.response.statusCode == 401) {
        //   return http.Response('Error', 401);
      } else {
        return http.Response('Unknow Error', 500);
      }
    }

    return http.Response('Service un;avaiable', 500);
  }

  Future<dynamic> update(String url, String token, var object) async {
    BaseOptions baseOp = BaseOptions(
      followRedirects: false,
      baseUrl: url,
      connectTimeout: 3000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': 'Bearer ${token}'
      },
    );
    Dio dio = new Dio(baseOp);

    try {
      Response<String> response = await dio.put(
        url,
        // options: Options(
        //   followRedirects: false,
        //   headers: {
        //     HttpHeaders.contentTypeHeader: "application/json",
        //     'Authorization': 'Bearer ${token}'
        //   },
        // ),
        data: object,
      );
      //print(response);
      return response;
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
        // } else if (e.response.statusCode == 404) {
        //   return http.Response('Error', 404);
        // } else if (e.response.statusCode == 401) {
        //   return http.Response('Error', 401);
      } else {
        return http.Response('Unknow Error', 500);
      }
    }

    return http.Response('Service un;avaiable', 500);
  }

  Future<dynamic> doPost(String url, var object) async {
    BaseOptions baseOp = BaseOptions(
      followRedirects: false,
      baseUrl: url,
      connectTimeout: 3000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
    );
    Dio dio = new Dio(baseOp);

    try {
      Response<String> response = await dio.post(
        url,
        // options: Options(
        //   followRedirects: false,
        //   headers: {
        //     HttpHeaders.contentTypeHeader: "application/json",
        //     'Authorization': 'Bearer ${token}'
        //   },
        // ),
        data: object,
      );
      //print(response);
      return response;
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
        // } else if (e.response.statusCode == 404) {
        //   return http.Response('Error', 404);
        // } else if (e.response.statusCode == 401) {
        //   return http.Response('Error', 401);
      } else {
        return http.Response('Unknow Error', 500);
      }
    }

    return http.Response('Service un;avaiable', 500);
  }

  Future<dynamic> delete(String url, String token, var object) async {
    BaseOptions baseOp = BaseOptions(
      followRedirects: false,
      baseUrl: url,
      connectTimeout: 3000,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        'Authorization': 'Bearer ${token}'
      },
    );
    Dio dio = new Dio(baseOp);

    try {
      Response<String> response = await dio.delete(
        url,
        // options: Options(
        //   followRedirects: false,
        //   headers: {
        //     HttpHeaders.contentTypeHeader: "application/json",
        //     'Authorization': 'Bearer ${token}'
        //   },
        // ),
        data: object,
      );
      //print(response);
      return response;
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
        // } else if (e.response.statusCode == 404) {
        //   return http.Response('Error', 404);
        // } else if (e.response.statusCode == 401) {
        //   return http.Response('Error', 401);
      } else {
        return http.Response('Unknow Error', 500);
      }
    }

    return http.Response('Service un;avaiable', 500);
  }

  Future<dynamic> login(String url, var object) async {
    BaseOptions baseOp = BaseOptions(
        followRedirects: false,
        baseUrl: url,
        connectTimeout: 3000,
        headers: {
          'Accept': 'application/json',
        });

    try {
      Response<String> response = await Dio().post(
        url,
        options: Options(
          followRedirects: false,
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
        data: object,
      );
      // print(response);
      return response;
    } on DioError catch (e) {
      print(e);
      if (e.type == DioErrorType.connectTimeout) {
        return http.Response('Error', 408);
        // } else if (e.response.statusCode == 404) {
        //   return http.Response('Error', 404);
        // } else if (e.response.statusCode == 401) {
        //   return http.Response('Error', 401);
      } else {
        return http.Response('Unknow Error', 500);
      }
    }
  }
}
