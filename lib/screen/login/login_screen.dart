import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/refreshtoken.dart';
import 'package:mun_bot/entities/token.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/screen/menuscreen/menu_screen.dart';
import 'package:mun_bot/social_login/ui/auth-page.dart';
import 'package:mun_bot/social_login/ui/utils.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import '../../env.dart';
import '../../main.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import '../sidebar_menu.dart';
import 'app_styles.dart';
import 'qrcode_scren.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:crypto/crypto.dart';
import 'package:mun_bot/entities/response.dart' as EntityResponse;
import 'package:flutter/cupertino.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
//  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String errorMessage = '';
  //late bool hasExpired = true;
  @override
  void initState() {
    super.initState();
  }

  Widget JustLogIn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          loggedUser = LoggedUser("sidol.sat@gmail.com", "", "", "");

          UserService userService = UserService();
          var response = await userService.login(
              "sidol.sat@gmail.com", "${LOCAL_SERVER_IP_URL}/oauth/google");

          EntityResponse.Response<Token> t;

          EntityResponse.Response<RefreshToken> rft;

          t = EntityResponse.Response<Token>.fromJson(
              jsonDecode(response.data), (body) => Token.fromJson(body));

          rft = EntityResponse.Response<RefreshToken>.fromJson(
              jsonDecode(response.data), (body) => RefreshToken.fromJson(body));

          Token token = Token(t.body.token /*, t.body.user*/);
          tokenFromLogin = token;
          RefreshToken refreshToken = RefreshToken(rft.body.refreshtoken);
          loggedUser.token = t.body.token;
          loggedUser.refresh_token = rft.body.refreshtoken;

          await save("user", loggedUser);

          loggedUser = await readUser("user");
          ////print(ts);
          //await saveRefreshTokenToStorage(refreshToken.refreshtoken);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            //color: Color(0xFF527DAA),
            color: Color(0xFF4D4D4D),

            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        /*Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),*/
        SizedBox(height: 20.0),
        /*Text(
          'Sign in with',
          style: kLabelStyle,
        ),*/
      ],
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: sizeHeight(30, context)),
        child: Column(
          children: [
            Utils.getButton(
                text: '  Sign in with Google',
                color: Colors.white,
                //bgColor: HexColor('#4D4D4D'),
                bgColor: Colors.black.withOpacity(0.7),
                mini: false,
                fontScale: 0.025,
                height: sizeHeight(65, context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.grey.shade400,
                      width: sizeWidth(3, context)),
                  borderRadius: BorderRadius.circular(sizeWidth(15, context)),
                ),
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google_new.png',
                        width: sizeWidth(37, context)),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    FadeRoute1(AuthPage(
                        context: context,
                        isLogged: false,
                        thirdParty: 'google')),
                  );
                }),

            Utils.getButton(
                text: '  Sign in with Apple ID',
                color: Colors.white,
                //bgColor: HexColor('#4D4D4D'),
                bgColor: Colors.black.withOpacity(0.7),
                mini: false,
                fontScale: 0.025,
                height: sizeHeight(65, context),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.grey.shade400,
                      width: sizeWidth(3, context)),
                  borderRadius: BorderRadius.circular(sizeWidth(15, context)),
                ),
                icon: Image.asset('assets/images/apple.png',
                    width: sizeWidth(37, context)),
                onPressed: () {
                  Navigator.of(context).push(
                    FadeRoute1(AuthPage(
                        context: context,
                        isLogged: false,
                        thirdParty: 'apple')),
                  );
                }),

            /*GoogleAuthButton(
            onPressed: () => googleSignInSignUp()  ,
            style: AuthButtonStyle(
              width: 300,

              height: 65,
            ),
          ),*/

            SizedBox(height: sizeHeight(25, context)),

            //Platform.isIOS ?
            /*AppleAuthButton(
            onPressed:() async {

              await AppleSignInSignUp();

              //print("finish");
            },
            style: AuthButtonStyle(
              //  width: 185,
              width: 300,
              height: 65,
            ),
          )//: Container(),
*/
          ],
        ));
  }

  AppleSignInSignUp() async {}

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: AssetImage(
                    //     'assets/images/Login_Bg1.png'),
                    image: AssetImage(
                        'assets/images/Login_Bg3.png'), // Replace with your image path
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: sizeHeight(143, context),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: sizeWidth(10, context)),
                        child: Container(
                          width: sizeWidth(300, context),
                          height: sizeHeight(300, context),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            // borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage('assets/images/app_icons2.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign In / Sign Up',
                          style: TextStyle(
                            // color: Colors.white,
                            // color: theme_color2,
                            color: Colors.black.withOpacity(0.7),
                            fontFamily: 'OpenSans',
                            fontSize: sizeHeight(18, context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // SizedBox(height: 30.0),
                      // _buildEmailTF(),
                      JustLogIn(),
                      //_buildForgotPasswordBtn(),
                      //_buildRememberMeCheckbox(),
                      //_buildLoginBtn(),
                      // _buildSignInWithText(),
                      Align(
                        alignment: Alignment.center,
                        child: _buildSocialBtnRow(),
                      ),
                      //_buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  final String message;

  LoadingWidget({this.message = "Loading..."});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: sizeHeight(16, context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

save(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(value));
}

loadSetting(String key) async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getString(key) == null) return AppSetting(0, false);

  var js = json.decode(prefs.getString(key) as String);

  return AppSetting(js["local"], js['signIn']);
}

readUser(String key) async {
  final prefs = await SharedPreferences.getInstance();
  var js = json.decode(prefs.getString(key) as String);
  return LoggedUser(
      js["email"], js['token'], js['refresh_token'], js['img_url']);
}

remove(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}
