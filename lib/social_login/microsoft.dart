

import 'dart:convert';

import 'auth-data.dart';

import 'engine/debug.dart';
import 'engine/simple-auth.dart';
import 'engine/visa.dart';
import 'package:http/http.dart' as http;
import 'engine/oauth.dart';

/// Enables Google [OAuth] authentication
class MicrosoftAuth extends Visa {
  final baseUrl = 'https://login.microsoftonline.com/399ae2e4-044d-4424-82b9-c18f1f786af9/oauth2/v2.0/authorize';

  final Debug _debug = Debug(prefix: "In MicrosoftAuth ->");

  @override
  SimpleAuth? visa;

  var context;

  MicrosoftAuth(this.context){

    visa = SimpleAuth(
      baseUrl: baseUrl,
        getAuthData: (Map<String, String> oauthData) async {
          if (debugMode) _debug.info('OAuth Data: $oauthData');


          final String token = oauthData[OAuth.TOKEN_KEY] as String;
          if (debugMode) _debug.info('OAuth token: $token');

          final String baseProfileUrl =  'https://graph.microsoft.com/oidc/userinfo';

          final Uri profileUrl = Uri.parse('$baseProfileUrl');

          final http.Response profileResponse = await http
              .get(profileUrl, headers: {'Authorization': 'Bearer $token'});

          // User profile API endpoint.

          final Map<String, dynamic> profileJson =
          json.decode(profileResponse.body);
          if (debugMode) _debug.info('Returned Profile Json: $profileJson');
          return authData(profileJson, oauthData);
        },
    responseType: 'id_token token',
    otherQueryParams:{
      "nonce":"678910",
    }, client: 'microsoft', context: null);

  }


  AuthData authData(Map<String, dynamic> profileJson, Map<String, String> oauthData) {
    final String accessToken = oauthData[OAuth.TOKEN_KEY] as String;

    return AuthData(
        clientID:   visa!.clientId,
        accessToken: oauthData['access_token'] as String,
        userID: profileJson['sub'],
        firstName: profileJson['name'],
        lastName: profileJson['family_name'],
        email: profileJson['email'],
        profileImgUrl: profileJson['picture'],
        response: oauthData,
        userJson: profileJson);
  }


}