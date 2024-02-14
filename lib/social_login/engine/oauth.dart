import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'debug.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
/// This class contains [OAuth] data and
/// functionality. It has one public method
/// that returns a [WebView] which has been set up
/// for OAuth 2.0 Authentication.
class OAuth {
  var context;

  OAuth(
      {required this.context,
        required this.baseUrl,
      required this.clientID,
      required this.redirectUri,
      required this.state,
      required this.scope,
      required this.debugMode,
      this.clientSecret,
      this.responseType,
      this.otherQueryParams});

  final String baseUrl; // OAuth url
  final String clientID; // OAuth clientID
  final String? clientSecret; // OAuth clientSecret
  final String? responseType; // OAuth clientSecret
  final String redirectUri; // OAuth redirectUri
  final String? state; // OAuth state
  final String scope; // OAuth scope
  final Map<String, String>? otherQueryParams;
  final bool debugMode; // Debug mode?
  static const String TOKEN_KEY = 'access_token'; // OAuth token key
  static const String CODE_KEY = 'code'; // OAuth code key
  static const String STATE_KEY = 'state'; // OAuth state key
  static const String SCOPE_KEY = 'scope'; // OAuth scope key
  static const String CLIENT_ID_KEY = 'clientID'; // custom client id key
  static const String CLIENT_SECRET_KEY =
      'clientSecret'; // custom client secret key
  static const String REDIRECT_URI_KEY =
      'redirectURI'; // custom redirect uri key
  final String userAgent = 'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/87.0.4280.86 Mobile Safari/537.36'; // UA
  final Debug _debug = Debug(prefix: 'In OAuth ->');

  /// Sets up a [WebView] for OAuth authentication.
  /// [onDone] is called when authentication is
  /// completed successfully.
  InAppWebViewController? webViewController;

  bool _loadedPage = false ;

  String? client ;
  WebView authenticate(String client,{required Function onDone, bool clearCache = false}) {
    this.client = client;
    String clientSecretQuery =
        clientSecret != null ? '&client_secret=$clientSecret' : '';
    String responseTypeQuery =
        '&response_type=${responseType == null ? 'token' : responseType}';
    String otherParams = '';

    if (otherQueryParams != null) {
      for (String key in otherQueryParams!.keys) {
        otherParams += '&$key=${otherQueryParams![key]}';
      }
    }

    String param =  (client == 'apple') ? "&" : "?" ;
    String authUrl = '$baseUrl'
        '$param'
        'client_id=$clientID'
        '$clientSecretQuery'
        '&redirect_uri=$redirectUri'
        '&state=$state'
        '&scope=$scope'
        '$responseTypeQuery'
        '$otherParams';

    //if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    InAppWebView wv = InAppWebView(

       onReceivedServerTrustAuthRequest: (controller, challenge) async {
          //Do some checks here to decide if CANCELS or PROCEEDS
          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        },
        initialUrlRequest: URLRequest(url: Uri.parse(authUrl)),
      initialOptions: InAppWebViewGroupOptions(
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),

        crossPlatform: InAppWebViewOptions(

          userAgent: 'random',
          clearCache:true,
          javaScriptEnabled: true,
          javaScriptCanOpenWindowsAutomatically: true,
          useShouldOverrideUrlLoading: true,
          useOnLoadResource: true,
          cacheEnabled: true,
        ),
      ),
      onWebViewCreated: (controller) {
        webViewController = controller;

        //webViewController.req
      },
      onLoadStop: _getNavigationDelegate(webViewController,onDone),
      //shouldOverrideUrlLoading: _getNavigationDelegate(webViewController,onDone),
    );
    //wv.setW


    return wv;
  }


  /// Returns a navigation delegate that attempts
  /// to match the redirect url whenever the browser
  /// navigates to a new page. Once the redirect url
  /// is found, it calls the [onDone] callback.
  _getNavigationDelegate(controller, onDone) => (controller, _url) async {
    //controller.requestImageRef();
    String url = _url.toString();
    if (debugMode) _debug.info('Inspecting Url Before Loading: $url');

    if (url.startsWith(redirectUri)) {

      await controller.evaluateJavascript(
          source: "document.getElementById('dip').hidden = true ;");
      switch (this.client) {

        case 'apple':
          var html = await controller.evaluateJavascript(
              source: "document.getElementById('dip').innerText;");

          await controller!.loadUrl(urlRequest: URLRequest(url: Uri.parse(GOOGLE_REDIRECT_URI)));

          Map<String, dynamic> map = jsonDecode(html);

          Map<String, String> returnedData = HashMap();

          returnedData[CLIENT_ID_KEY] = clientID ;

          returnedData[TOKEN_KEY] = map['id_token'] ;

          returnedData['firstName'] = map['firstName']  == null ? "" :  map['firstName'] ;

          returnedData['lastName'] = map['lastName'] == null ? "":  map['lastName'] ; ;

          returnedData['email'] = map['email'] ;

          onDone(returnedData);

          break ;

        default :
          if (debugMode) _debug.info('Found Redirect Url: $url');

          var returnedData = _getQueryParams(url);

          returnedData[CLIENT_ID_KEY] = clientID;

          returnedData[REDIRECT_URI_KEY] = redirectUri;

          returnedData[STATE_KEY] = state!;

          if (clientSecret != null) {
            returnedData[CLIENT_SECRET_KEY] = clientSecret!;
          }
          onDone(returnedData);
          //return ;
          break ;
      }
      //Navigator.push(context,
      //    MaterialPageRoute(builder: (context) => MainScreen()));



    } else if (debugMode) {
      _debug.info('Redirect Url Not Found');
      _debug.info('Url = $url');
      _debug.info('Redirect Url = $redirectUri');
    }

    //return NavigationDecision.navigate;
  };

  /// Parses url query params into a map
  /// @param url: The url to parse.
  Map<String, String> _getQueryParams(String url) {
    if (debugMode) _debug.info('Getting Query Params From Url: $url');

    final List<String> urlParams = url.split(RegExp('[?&# ]'));
    final Map<String, String> queryParams = HashMap();
    List<String> parts;

    for (String param in urlParams) {
      if (!param.contains('=')) continue;

      parts = param.split('=');
      queryParams[parts[0]] = Uri.decodeFull(parts[1]);
    }

    if (debugMode) _debug.info('Extracted Query Params: $queryParams');
    return queryParams;
  }
}
