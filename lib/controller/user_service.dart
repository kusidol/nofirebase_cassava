import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mun_bot/entities/refreshtoken.dart';
import 'package:mun_bot/entities/response.dart' as EntityResponse;
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/entities/objectlist.dart';
import 'package:mun_bot/entities/token.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:mun_bot/social_login/ui/auth-page.dart';
import 'dart:io';
import '../main.dart';
import 'package:basic_utils/basic_utils.dart';

class UserService {

  static int timeout = 1500;

  static Future<Dio> initSSL(String url) async{
    BaseOptions baseOp = new BaseOptions(
        baseUrl: url,
        connectTimeout: timeout
    );

    Dio _dio = Dio(baseOp);

    ByteData rootCACertificate = await rootBundle.load("assets/certificate/ca.pem");

    ByteData clientCertificate = await rootBundle.load("assets/certificate/cert.pem");

    ByteData privateKey = await rootBundle.load("assets/certificate/key.pem");

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client)  {

      SecurityContext context = SecurityContext(withTrustedRoots: true);

      context.setTrustedCertificatesBytes(rootCACertificate.buffer.asUint8List());

      context.useCertificateChainBytes(clientCertificate.buffer.asUint8List());

      context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

      HttpClient httpClient = new HttpClient(context: context);
      httpClient.badCertificateCallback = (
          X509Certificate cert,
          String host,
          int port,
          ) {
        X509CertificateData callback_cert_data = X509Utils.x509CertificateFromPem(cert.pem);
        X509CertificateData client_cert_data = X509Utils.x509CertificateFromPem(utf8.decode(clientCertificate.buffer.asInt8List()));
        return callback_cert_data.sha256Thumbprint.toString() == client_cert_data.sha256Thumbprint.toString()  ? true : false ;
      };
      return httpClient;
    } ;
    return _dio ;
  }

  Future<dynamic> loginSSO(String url,String userName, String token) async{

  Dio _dio = await initSSL(url);
  var params =  {
    "username": userName,
    "token": token,
  };
  try{
    Response<String> response  = await _dio.post(url,
      options: Options(headers: {
        HttpHeaders.contentTypeHeader: "application/json",

      }
      ),
      data: jsonEncode(params),
    );
    return response ;
  }on DioError catch(e){

    if(e.type == DioErrorType.connectTimeout){

      return http.Response('Error', 408);
    }
    if(e.response == null){
      return http.Response("Please update new version", 426);
    }
  }
    return http.Response('Unauthorized', 401);

  }

  Future<dynamic> login(String userName,String url) async {

    Dio _dio = await initSSL(url);
    var params =  {
      "username": userName,

    };
    try{
      Response<String> response  = await _dio.post(url,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",

        }
        ),
        data: jsonEncode(params),
      );
      return response ;
    }on DioError catch(e){

      if(e.type == DioErrorType.connectTimeout){

        return http.Response('Error', 408);
      }
      if(e.response == null){
        return http.Response("Please update new version", 426);
      }
    }
    return http.Response('Unauthorized', 401);
  }



  /*Future<Token?> login(String userName, String token) async {
    EntityResponse.Response<Token> t;
    EntityResponse.Response<RefreshToken> rft;
    var user = {"username": userName, "token": token};
    Service service = new Service();
    var response = await service.login(
        "${LOCAL_SERVER_IP_URL}/oauth/google/access_token", user);

    print('call service authen');

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.data);
      String messageCheck = responseBody['message'] as String;
      if (messageCheck == "Anonymous User") {
        messageCheckpermission = messageCheck;
        t = EntityResponse.Response<Token>.fromJson(
            jsonDecode(response.data), (body) => Token.fromJson(body));
        Token token = Token(t.body.token /*, t.body.user*/);
        return token;
      } else if (messageCheck == "OK") {
        messageCheckpermission = messageCheck;
        t = EntityResponse.Response<Token>.fromJson(
            jsonDecode(response.data), (body) => Token.fromJson(body));
        rft = EntityResponse.Response<RefreshToken>.fromJson(
            jsonDecode(response.data), (body) => RefreshToken.fromJson(body));
        Token token = Token(t.body.token /*, t.body.user*/);
        RefreshToken refreshToken = RefreshToken(rft.body.refreshtoken);
        await saveRefreshTokenToStorage(refreshToken.refreshtoken);
        return token;
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error without statusCode");
    }
    return null;
  }*/

  Future<bool?> deleteAccount(String token) async {
    Service service = Service();

    var response = await service.doDelete("${LOCAL_SERVER_IP_URL}/oauth/delete", token);

    if(response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool?> refreshTokentoLogin(String refreshtoken) async {
    EntityResponse.Response<Token> t;
    var refreshToken = {"refreshToken": refreshtoken};
    Service service = Service();
    var response = await service.doPost(
        "${LOCAL_SERVER_IP_URL}/oauth/refreshtoken", refreshToken);
    print('call service authen');
    if (response.statusCode == 200) {
      print("can refresh token");
      Map<String, dynamic> responseBody = jsonDecode(response.data);
      t = EntityResponse.Response<Token>.fromJson(
          jsonDecode(response.data), (body) => Token.fromJson(body));

      Token token = Token(t.body.token /*, t.body.user*/);

      tokenFromLogin = token ;

      loggedUser.token = t.body.token;

      await save("user", loggedUser);

      loggedUser = await readUser("user");

      return true;

    } else {


      return false;
    }
  }

  Future<List<User>> getUser(String token) async {
    List<User> user = [];
    Service userService = new Service();
    var response = await userService.doGet(
        "${LOCAL_SERVER_IP_URL}/users/1/subdistricts/1", token);

    if (response.statusCode == 200) {
      user = ObjectList<User>.fromJson(
          jsonDecode(response.data), (body) => User.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return user;
  }

  Future<List<User>> getUserBySubdistrict(int value, String token) async {
    List<User> user = [];
    Service userService = new Service();
    var response = await userService.doGet(
        "${LOCAL_SERVER_IP_URL}/users/$value/subdistricts/1", token);

    if (response.statusCode == 200) {
      user = ObjectList<User>.fromJson(
          jsonDecode(response.data), (body) => User.fromJson(body)).list;
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return user;
  }

  Future<User?> getUserByFieldID(int fieldID, String token) async {
    User? user;
    Service userService = new Service();
    var response = await userService.doGet(
        "${LOCAL_SERVER_IP_URL}/users/owner/field/${fieldID}", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        user = User.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return user;
  }

  Future<User?> getUserBySurveyID(int surveyID, String token) async {
    User? user;
    Service userService = new Service();
    var response = await userService.doGet(
        "${LOCAL_SERVER_IP_URL}/survey/${surveyID}/user", token);
    if (response.statusCode == 200) {
      try {
        Map<String, dynamic> res = jsonDecode(response.data);
        user = User.fromJson(res['body']);
      } catch (e) {
        print("error on service");
      }
    } else if (response.statusCode == 401) {
      print('error statusCode 401');
    } else {
      print("error with out statusCode");
    }
    return user;
  }
}
