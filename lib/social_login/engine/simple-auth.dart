import 'package:flutter/material.dart';
import 'debug.dart';

import 'package:mun_bot/social_login/auth-data.dart';
import 'oauth.dart';

import 'package:http/http.dart' as Http;
/// Magic class [SimpleAuth] makes it easy to
/// add new [OAuth] providers by handling the
/// shared authentication process and
/// delegating the platform specific user
/// retrieval process to [getAuthData], a function
/// provided through the constructor.
class SimpleAuth {
  String client;

  var context;

  /// Creates a new instance based on the given OAuth
  /// baseUrl and getAuthData function.
  SimpleAuth({
    required this.context,
    required this.client,
    required this.baseUrl,
    required this.getAuthData,
    this.responseType,
    this.otherQueryParams
  });

  final String baseUrl; // OAuth base url
  final String? responseType;
  final Map<String, String>? otherQueryParams;

  /// This function makes the necessary api calls to
  /// get a user's profile data. It accepts a single
  /// argument: a Map<String, String> containing the
  /// full auth response including an api access token.
  /// An [AuthData] object is created from a combination
  /// of the passed in auth response and the user
  /// response returned from the api.
  ///
  /// @return [AuthData]
  final Function getAuthData;
  late String clientId ;
  /// Debug mode?
  bool debugMode = false;

  final Debug _debug = Debug(prefix: 'In SimpleAuth ->');

  /// Creates an [OAuth] instance with the
  /// provided credentials. Returns a WebView
  /// That's been set up for authentication
   authenticate(
      {required String clientID,
      String? clientSecret,
        String? state,
      required String redirectUri,
      required String scope,
      required Function onDone,
      bool newSession = false, String? responseType}) {
    final OAuth oAuth = OAuth(
      context: context,
        baseUrl: baseUrl,
        clientID: clientID,
        clientSecret: clientSecret,
        redirectUri: redirectUri,
        state: state as String,
        scope: scope,
        responseType: responseType,
        otherQueryParams: otherQueryParams,
        debugMode: debugMode);
    this.clientId = clientID ;
    return oAuth.authenticate(client,
        clearCache: newSession,
        onDone: (responseData) async {
          if (debugMode) _debug.info('Response: $responseData');

          final String token = responseData[OAuth.TOKEN_KEY] == null ? "null" : responseData[OAuth.TOKEN_KEY]  as String;
          final String code = responseData[OAuth.CODE_KEY]== null ? "null":  responseData[OAuth.TOKEN_KEY]  as String;

          AuthData authData = token == null && code == null
              ? AuthData(response: responseData)
              : await getAuthData(responseData);

          if (debugMode) _debug.info('Returned Authentication Data: $authData');

          onDone(authData);
        });
  }
}
