

import 'dart:collection';
import 'dart:convert';

import 'auth-data.dart';

import 'engine/debug.dart';
import 'engine/simple-auth.dart';
import 'engine/visa.dart';
import 'package:http/http.dart' as http;
import 'engine/oauth.dart';

/// Enables Google [OAuth] authentication
class AppleAuth extends Visa {
  final baseUrl = 'https://appleid.apple.com/auth/authorize?response_mode=form_post';

  final Debug _debug = Debug(prefix: "In AppleAuth ->");

  @override
  SimpleAuth? visa;

  var context;

  AppleAuth(this.context){

    visa = SimpleAuth(

      baseUrl: baseUrl,
        getAuthData: (Map<String, String> oauthData) async {
          if (debugMode) _debug.info('OAuth Data: $oauthData');


          final String token = oauthData[OAuth.TOKEN_KEY] as String;
          //print(">>>>>>>>>"+token) ;
          if (debugMode) _debug.info('OAuth token: $token');

          final String baseProfileUrl =  '';

          final Uri profileUrl = Uri.parse('$baseProfileUrl');

          //final http.Response profileResponse = await http
          //   .get(profileUrl, headers: {'Authorization': 'Bearer $token'});

          // User profile API endpoint.
          Map<String, String> profileJson = HashMap();

          //final Map<String, dynamic> profileJson =
          //json.decode(profileResponse.body);
          //if (debugMode) _debug.info('Returned Profile Json: $profileJson');
          return authData(profileJson, oauthData);
        },
    otherQueryParams:{
      "nonce":"678910",
    }, client: 'apple', context: context);

  }


  AuthData authData(Map<String, dynamic> profileJson, Map<String, String> oauthData) {
    final String accessToken = oauthData[OAuth.TOKEN_KEY] as String;

    return AuthData(
        clientID:   visa!.clientId,
        accessToken: oauthData['access_token'] as String,
        email: oauthData['email']  as String );
  }


}