import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/refreshtoken.dart';
import 'package:mun_bot/entities/token.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/login/qrcode_scren.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/social_login/engine/debug.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/social_login/engine/visa.dart';
import 'package:mun_bot/util/stateful_wrapper.dart';
import 'package:mun_bot/entities/response.dart' as EntityResponse;
import '../../main.dart';
import '../apple.dart';
import '../auth-data.dart';
import '../google.dart';
import 'utils.dart';
import 'package:mun_bot/env.dart';

class LoggedUser {
  String email ;
  String token ;
  String refresh_token ;
  String img_url ;

  LoggedUser(this.email,this.token,this.refresh_token,this.img_url) ;

  //LoggedUser();

  LoggedUser.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        token = json['token'],
        refresh_token = json['refresh_token'],
        img_url = json['img_url'];

  Map<String, dynamic> toJson() => {
    'email': email,
    'token': token,
    'refresh_token': refresh_token,
    'img_url': img_url,
  };

}

LoggedUser loggedUser = LoggedUser("","","","");

class AuthPage extends StatelessWidget {
  var context;
  var isLogged ;



  AuthPage({Key? key,required this.context,required this.isLogged, required this.thirdParty, String? this.url})
      : super(key: key);


  //Box? _UserBox;

  final String thirdParty;
  final String? url;
  final Debug _debug = Debug(prefix: 'In AuthPage ->');

  @override
  Widget build(BuildContext context) {
    Widget authenticate = _getThirdPartyAuth(context);

    return StatefulWrapper(
        onInit: () {
          //_UserBox = Hive.box("Users");
        },
        child: WillPopScope(
          onWillPop: () async {
            //Navigator.pop(context, true);
            //Navigator.pushNamed(context, NEW_LOGIN_ROUTE);
            return true; //  exit the app
          },
          child: Scaffold(
            appBar: Utils.getAppBar(context),
            body: authenticate,
          ),
        ));
  }

  Widget _getThirdPartyAuth(context) {

      showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget continueButton = TextButton(
        child: Container(
          child: Text(
            "ok",
            style: TextStyle(
                color: Colors.blueAccent[800],
                fontWeight: FontWeight.bold,
                fontSize: 20),
          ),
        ),
        onPressed: () {
          //Navigator.of(context).pushReplacementNamed(NEW_LOGIN_ROUTE);
        },
      ); // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Row(
          children: [
            Image.asset(
              "assets/images/unknown_user.png",
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Text(
              "Warning",
            ),
          ],
        ),
        content: const Text(
          "   Unauthorized User  ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          continueButton,
        ],
      ); // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

     done(AuthData authData) async {

      if(isLogged)
         return ;
      isLogged = true ;

      UserService userService = UserService();

      var response;
      var userName = authData.email as String;
      String profileImgUrl = await authData.profileImgUrl == null ? "" :  await Utils.networkImageToBase64(authData.profileImgUrl  as String ) as String;

      loggedUser = LoggedUser(userName, authData.accessToken as String, "", profileImgUrl );
      //print(userName);
      //print(authData.accessToken);
      //print(authData. profileImgUrl);
      switch (this.thirdParty) {
        case 'google':
          response = await userService.loginSSO(
                "$SSO_SERVER_IP_URL/oauth/google/access_token",
              userName,
              authData.accessToken as String);
          break;
        case 'apple':

          response = await userService.loginSSO(
              "$SSO_SERVER_IP_URL/oauth/apple/access_token",
              userName,
              authData.accessToken as String);
          break;
        default:
          break;
      }

      EntityResponse.Response<Token> t;

      EntityResponse.Response<RefreshToken> rft;

      if (response.statusCode == 200 ) {

        //Map<String, dynamic> responseBody = jsonDecode(response.data);
        //String messageCheck = responseBody['message'] as String;

        /*if (messageCheck == "Anonymous User") {
          //messageCheckpermission = messageCheck;
          t = EntityResponse.Response<Token>.fromJson(
              jsonDecode(response.data), (body) => Token.fromJson(body));
          Token token = Token(t.body.token /*, t.body.user*/);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => LoadingWidget(),
          );
          tokenFromLogin = token ;

          await Future.delayed(Duration(seconds: 2));

          await saveTokenToStorage(tokenFromLogin!.token);

          rememberMe = true;

          await saveRememberMeToStorage(rememberMe);


       } else*/


          //messageCheckpermission = messageCheck;

          t = EntityResponse.Response<Token>.fromJson(
              jsonDecode(response.data), (body) => Token.fromJson(body));

          rft = EntityResponse.Response<RefreshToken>.fromJson(
              jsonDecode(response.data), (body) => RefreshToken.fromJson(body));

          Token token = Token(t.body.token /*, t.body.user*/);
          tokenFromLogin = token ;
          RefreshToken refreshToken = RefreshToken(rft.body.refreshtoken);

          //await saveRefreshTokenToStorage(refreshToken.refreshtoken);

          loggedUser.token = t.body.token;
          loggedUser.refresh_token = rft.body.refreshtoken;

          await save("user", loggedUser);

          Navigator.of(context).pop();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreen()));

      } else if(response.statusCode == 201 ){

        t = EntityResponse.Response<Token>.fromJson(
            jsonDecode(response.data), (body) => Token.fromJson(body));

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("registration".i18n()),
              content: Text("register-warning-message".i18n()),
              actions: [
                TextButton(

                  child: Text("cancle".i18n(),
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    //googleUser = null;
                    tokenFromLogin = null;
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("confirm".i18n(),
                    style: TextStyle(color: Colors.blue),

                  ),
                  onPressed: () {

                    Navigator.of(context).pop();

                    Navigator.of(context).pop();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QRCodeScannerScreen(t.body.token)));
                  },
                ),
              ],
            );

          },

        );

      }


      //loggedUser

      /*if (resp.statusCode == 200) {
        EntityResponse.Response<Token> t =
            EntityResponse.Response<Token>.fromJson(
                jsonDecode(resp.data), (body) => Token.fromJson(body));
        String token = t.body.token;

      } else if (resp.statusCode == 401) {
        //useShowDialogSSO("UNAUTHRIZED USER", context);
      }else if (resp.statusCode == 426) {
        //useShowDialog("Please update new version!!", context);
      }*/

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

    var googleAuth = GoogleAuth(context);
   // var microsoft = MicrosoftAuth();
    var apple = AppleAuth(context);
    List<Visa> allProviders = [googleAuth,apple];

    //for (var provider in allProviders) {
    //  provider.debug = true;
    //}

    switch (thirdParty) {
      case 'google':
        return googleAuth.visa!.authenticate(
            clientID:
                '279975869260-pn1rkjjc74narl3gdkmc9fbeaischmlt.apps.googleusercontent.com',
            //redirectUri: 'https://158.108.207.83.nip.io:8443/cassava/google/callback',
            redirectUri: 'https://cpeserver.eng.kps.ku.ac.th:8443/cassava/google/callback',
            newSession: true,
            state: 'googleAuth',
            scope: 'https://www.googleapis.com/auth/user.emails.read '
                'https://www.googleapis.com/auth/userinfo.profile',
            onDone: done);

      case 'apple':
        return apple.visa!.authenticate(
            clientID: 'org.munbot.cassava.apple.signin',
            //redirectUri: 'https://www.158.108.207.83.nip.io:8443/cassava/apple/callback',
            redirectUri: 'https://cpeserver.eng.kps.ku.ac.th:8443/cassava/apple/callback',
            newSession: true,
            scope: 'openid name email',
            state: "",
            responseType:'code',
            onDone: done);
      default:
        return Scaffold();
    }
  }
}
