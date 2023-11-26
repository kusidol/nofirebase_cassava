import 'dart:convert';


import 'package:http/http.dart' as http;

import 'engine/debug.dart';
import 'engine/simple-auth.dart';
import 'engine/visa.dart';
import 'auth-data.dart';
import 'engine/oauth.dart';

/// Enables Google [OAuth] authentication
class GoogleAuth extends Visa {

  final baseUrl = 'https://accounts.google.com/o/oauth2/v2/auth';

  final Debug _debug = Debug(prefix: 'In GoogleAuth ->');

  String personFields;

  @override
  SimpleAuth? visa;

  var context;

  GoogleAuth(this.context,{this.personFields = ""}) {
    personFields = _getPersonFields(personFields);

    visa = SimpleAuth(
        baseUrl: baseUrl,
        /// Sends a request to the user profile api
        /// endpoint. Returns an AuthData object.
        getAuthData: (Map<String, String> oauthData) async {
          if (debugMode) _debug.info('OAuth Data: $oauthData');

          final String token = oauthData[OAuth.TOKEN_KEY] as String;
          if (debugMode) _debug.info('OAuth token: $token');

          // User profile API endpoint.
          final String baseProfileUrl =
              'https://people.googleapis.com/v1/people/me';
          final Uri profileUrl =
              Uri.parse('$baseProfileUrl?personFields=$personFields');

          final http.Response profileResponse = await http
              .get(profileUrl, headers: {'Authorization': 'Bearer $token'});
          final Map<String, dynamic> profileJson =
              json.decode(profileResponse.body);
          if (debugMode) _debug.info('Returned Profile Json: $profileJson');

          return authData(profileJson, oauthData); ;
        }, client: 'google', context: context);
  }

  /// This function combines information
  /// from the user [profileJson] and auth response [oauthData]
  /// to build an [AuthData] object.
  @override
  AuthData authData(
      Map<String, dynamic> userJson, Map<String, String> oauthData)  {


    final String accessToken = oauthData[OAuth.TOKEN_KEY] as String;

    return AuthData(
        clientID: oauthData['clientID'] as String,
        accessToken: accessToken,
        userID: userJson['metadata']['sources'][0]['id'],
        firstName: userJson['names'][0]['givenName'],
        lastName: userJson['names'][0]['familyName'],
        email: userJson['emailAddresses'][0]['value'],
        profileImgUrl: userJson['photos'][0]['url'],
        response: oauthData,
        userJson: userJson);
  }

  /// Merges the provided personFields with
  /// the default personFields.
  _getPersonFields(String fields) {
    final Set inputFields = Set.from(fields.split(RegExp('[ ,]')));
    final Set defaultFields = {'names', 'emailAddresses', 'metadata', 'photos'};

    defaultFields.addAll(inputFields);

    return defaultFields.join(',');
  }
}
