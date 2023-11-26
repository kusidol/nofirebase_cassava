import 'dart:convert';

import 'package:der/controller/login_service.dart';
import 'package:der/entities/site/user.dart';
import 'package:der/entities/token.dart';
import 'package:der/entities/user.dart';
import 'package:der/screens/main/signup_screen.dart';
import 'package:der/social_login/engine/debug.dart';
import 'package:der/social_login/engine/visa.dart';
import 'package:der/utils/constants.dart';
import 'package:der/utils/stateful_wrapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:der/entities/response.dart' as EntityResponse;


import 'package:http/http.dart' as Http;
import '../auth-data.dart';
import '../google.dart';
import '../microsoft.dart';
import 'utils.dart';
import 'package:der/env.dart';


class AuthPage extends StatelessWidget {
  AuthPage({Key? key, required this.thirdParty,String? this.url}) : super(key: key);

  Box? _UserBox;

  final String thirdParty;
  final String? url;
  final Debug _debug = Debug(prefix: 'In AuthPage ->');



  @override
  Widget build(BuildContext context) {

    Widget authenticate = _getThirdPartyAuth(context);

    return StatefulWrapper(
            onInit: (){
          _UserBox = Hive.box("Users");
        },
        child:  WillPopScope(
          onWillPop: () async {
          Navigator.pop(context, true);
          Navigator.pushNamed(context, NEW_LOGIN_ROUTE);
          return true; //  exit the app

          },
        child: Scaffold(
          appBar: Utils.getAppBar(context),
          body: authenticate,

        ),
     )
    );
  }

  Widget _getThirdPartyAuth(context) {


    showAlertDialog(BuildContext context) {  // set up the buttons

      Widget continueButton = TextButton(
        child: Container(
          child: Text(
            "ok",
            style: TextStyle(
                color: Colors.blueAccent[800],
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),
          ),
        ),

        onPressed:  () {
          Navigator.of(context).pushReplacementNamed(NEW_LOGIN_ROUTE);
        },
      );  // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Row(
          children: [
            Image.asset("assets/images/unknown_user.png",width: 50,height: 50,fit: BoxFit.contain,),
            Text("Warning",

            ),
          ],
        ),

        content: const Text("   Unauthorized User  ",

          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
        ),),
        actions: [

          continueButton,
        ],
      );  // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


    done(AuthData authData) async {
      LoginService login = LoginService();
      var resp ;
      var userName = authData.email as String ;
       switch(this.thirdParty){

         case 'google':   resp  = await login.attemptSSOLogIn("$SSO_SERVER_IP_URL/api/google/authenticate",userName,authData.accessToken as String);break ;
         case 'microsoft' : resp = await login.attemptSSOLogIn("$SSO_SERVER_IP_URL/api/azure/authenticate",userName,authData.response!['id_token'] as String);break ;
         default :  break ;
       }
      if(resp.statusCode == 200) {
        EntityResponse.Response<Token> t = EntityResponse.Response<
            Token>.fromJson(
            jsonDecode(resp.data), (body) => Token.fromJson(body));
        String token = t.body.token;
        User u = t.body.user;
        userNameNow = u.userName ;
        if (_UserBox?.get(u.userName) == null) {
          print(" not  token null");
          OnSiteUser user = OnSiteUser(u.userName, u.firstName, u.lastName,
              u.picture, token, 123, "", [], [], "");
          _UserBox?.put(u.userName, user);
          Navigator.of(context).pushReplacementNamed(SETDIGIT_ROUTE);
        } else {
          print(" save token");
          _UserBox?.get(u.userName).token = token;
          _UserBox?.get(u.userName).save();
          Navigator.of(context).pushReplacementNamed(HOME_ROUTE);
        }

      }else if(resp.statusCode == 401){

        useShowDialogSSO("UNAUTHRIZED USER", context);
      }



/*
      if(resp.statusCode == 408){
        useShowDialog("REQUEST TIMEOUT", context);
      }else if(resp.statusCode == 401){
        useShowDialog("UNAUTHRIZED USER", context);
      }else if(resp.statusCode == 200) {
        EntityResponse.Response<Token> t = EntityResponse.Response<
            Token>.fromJson(
            jsonDecode(resp.data), (body) => Token.fromJson(body));
        String token = t.body.token;
        User u = t.body.user;
        u.userName = userNameNow = userName;
        _UserBox?.get(userNameNow).token = token;
        _UserBox?.get(userNameNow).save();
        Navigator.of(context).pushReplacementNamed(HOME_ROUTE);

      }else if(resp.statusCode == 500){
        useShowDialog("SERVICE UNAVAILABLE", context);
      }
*/

      /*res.then((value) {

        if(value == null){
            useShowDialog("SERVICE UNAVAILABLE", context);
            Navigator.of(context).pushReplacementNamed(NEW_LOGIN_ROUTE);
        }

        Map<String, dynamic> map = jsonDecode(value);
       int status =  jsonDecode(value)['status'];


        if(status == 200){
          Response<Token> t = Response<Token>.fromJson(
              jsonDecode(value), (body) => Token.fromJson(body));
          userNameNow = userName ;
          String token = t.body.token;

          User u = t.body.user;
          u.userName = userName;

          if (_UserBox?.get(userNameNow) == null) {
              print(" not  token null");
              OnSiteUser user = OnSiteUser(u.userName, u.firstName, u.lastName,
                  u.picture, token, 123, "", [], [], "");
              _UserBox?.put(u.userName, user);
          } else {
              print(" save token");
              _UserBox?.get(userNameNow).token = token;
              _UserBox?.get(userNameNow).save();
          }
            Navigator.of(context).pushReplacementNamed(HOME_ROUTE);
        }else if (status == 401){
            showAlertDialog(context);
        }
      });*/
    }




    var googleAuth = GoogleAuth();
    var microsoft = MicrosoftAuth();
    List<Visa> allProviders = [

      googleAuth,
      microsoft
    ];

    //for (var provider in allProviders) {
    //  provider.debug = true;
    //}

    switch (thirdParty) {


      case 'google':
        return googleAuth.visa!.authenticate(
            clientID: '279975869260-v5l141hsqcra1f5rs8m92f0679lkougu.apps.googleusercontent.com',
            redirectUri: 'https://www.e-oj.com/oauth',
            newSession: true,
            // redirectUri: 'http://10.0.2.2.nip.io:8080/ders/login/oauth2/code/google',
            //redirectUri: 'http://158.108.207.83.nip.io:8080/ders/login/oauth2/code/ss',
            //redirectUri: 'http://158.108.207.83.nip.io:8080/ders/login/oauth2/code/ss',

            // clientID: '463257508739-c03fcu5pej7odrci1tclk53qdd'
            //     'tsa0vo.apps.googleusercontent.com',
            // redirectUri: 'https://www.e-oj.com/oauth',
            state: 'googleAuth',
            scope: 'https://www.googleapis.com/auth/user.emails.read '
                'https://www.googleapis.com/auth/userinfo.profile',
            onDone: done);

      case 'microsoft':
        return microsoft.visa!.authenticate(
            clientID: '8398310e-83d1-4251-a46a-f8a389b7a419',
            clientSecret: '9Ae7Q~kAmGuFMJGiiQRgTSOIFyETYzlnajTY2',
            redirectUri: 'https://www.e-oj.com/oauth',
            newSession: true,
            state: 'msAuth',
            scope: 'openid  https://graph.microsoft.com/User.Read ',
            onDone: done);
      default:
        return Scaffold();
    }
  }
}
