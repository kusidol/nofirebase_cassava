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


//RefreshToken? refreshToken;
//GoogleSignInAccount? googleUser;

//bool rememberMe = false;

//final String tokenKey = 'user_token';
//final String refreshtokenKey = 'refresh_token';
//final String googleUserKey = 'google_user';
//final String rememberMeKey = 'remember_me';

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

    /*getRefreshTokenFromStorage().then((storedRefreshToken) {
      refreshToken =
          storedRefreshToken != null ? RefreshToken(storedRefreshToken) : null;
      if (storedRefreshToken != null) {
        setState(() {
          refreshToken = RefreshToken(storedRefreshToken);
          print('RefreshToken: ${refreshToken!.refreshtoken}');
        });
      } else {
        print('refreshTokenFromLogin is null.');
      }
    });*/
    /*getTokenFromStorage().then((storedToken) async {
      tokenFromLogin = storedToken != null ? Token(storedToken) : null;
      if (storedToken != null) {
        tokenFromLogin = Token(storedToken);
        // Decode the token
        Map<String, dynamic> decodedToken =
            JwtDecoder.decode(tokenFromLogin!.token);
        DateTime expirationDate =
            DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
        if (DateTime.now().isAfter(expirationDate)) {
          UserService userService = UserService();
          bool? checkRefreshtoken =
              await userService.refreshTokentoLogin(refreshToken!.refreshtoken);
          if (checkRefreshtoken == true) {
            hasExpired = false;
          } else {
            hasExpired = true;
          }
        } else {
          hasExpired = false;
        }
        // hasExpired = Jwt.isExpired(tokenFromLogin!.token);
        print('Token From API When open login page: ${tokenFromLogin!.token}');
        print('Token Expired status : ${hasExpired.toString()}');
        //print('RememberUser status : ${rememberMe.toString()}');
        /*if (googleUser != null) {
          print(googleUser!.email);
        } else {
          print('The user is not signed in.');
        }*/
      } else {
        print('TokenFromLogin is null.');
      }
    });*/
  }

  Widget JustLogIn(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {

          loggedUser = LoggedUser("sidol.sat@gmail.com", "", "", "" );

          UserService userService = UserService();
          var response = await userService.login("sidol.sat@gmail.com", "${LOCAL_SERVER_IP_URL}/oauth/google");


          EntityResponse.Response<Token> t;

          EntityResponse.Response<RefreshToken> rft;

          t = EntityResponse.Response<Token>.fromJson(
              jsonDecode(response.data), (body) => Token.fromJson(body));

           rft = EntityResponse.Response<RefreshToken>.fromJson(
              jsonDecode(response.data), (body) => RefreshToken.fromJson(body));

          Token token = Token(t.body.token /*, t.body.user*/);
          tokenFromLogin = token ;
          RefreshToken refreshToken = RefreshToken(rft.body.refreshtoken);
          loggedUser.token = t.body.token;
          loggedUser.refresh_token = rft.body.refreshtoken;

          await saveUser("user", loggedUser);
          loggedUser = await readUser("user");
          //print(ts);
          //await saveRefreshTokenToStorage(refreshToken.refreshtoken);

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MainScreen()));

        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  /*Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (autoLogInStatus == true &&
              hasExpired == false &&
              rememberMe == true &&
              tokenFromLogin != null) {
            try {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => LoadingWidget(),
              );
              googleUser = await GoogleSignIn().signIn();
              print('Token From API: ${tokenFromLogin?.token}');
              await Future.delayed(Duration(seconds: 2));
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            } catch (e) {
              print('Google Sign-In Error: $e');
            }
          } else {
            logoutAndsignInWithGoogle();
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }*/

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

  /*Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () async {
        logoutAndsignInWithGoogle();
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }*/

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Column(

        children: [

          Utils.getButton(
              text: '  Sign in with Google',
              color: Colors.white,
              bgColor: HexColor('#4D4D4D'),
              mini: false,
              fontScale: 0.025,
              height: 65,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              icon: Image.asset('assets/images/google_new.png', width: 37),
              onPressed: () {
                Navigator.of(context).push(
                  FadeRoute1(AuthPage(context: context,isLogged: false ,thirdParty: 'google')),
                );
              }),

          Utils.getButton(
              text: '  Sign in with Apple ID',
              color: Colors.white,
              bgColor: HexColor('#4D4D4D'),
              mini: false,
              fontScale: 0.025,
              height: 65,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              icon: Image.asset('assets/images/apple.png', width: 37),
              onPressed: () {
                Navigator.of(context).push(
                  FadeRoute1(AuthPage(context: context,isLogged: false ,thirdParty: 'apple')),
                );
              }),

          /*GoogleAuthButton(
            onPressed: () => googleSignInSignUp()  ,
            style: AuthButtonStyle(
              width: 300,

              height: 65,
            ),
          ),*/

          SizedBox(height: 25),

          //Platform.isIOS ?
          /*AppleAuthButton(
            onPressed:() async {

              await AppleSignInSignUp();

              print("finish");
            },
            style: AuthButtonStyle(
              //  width: 185,
              width: 300,
              height: 65,
            ),
          )//: Container(),
*/
        ],
      )


      /*Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),
        ],
      ),*/
    );
  }
  AppleSignInSignUp() async {



  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) =>
    charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /*googleSignInSignUp() async {
    await _googleSignIn.signOut();
    saveTokenToStorage(null);
    saveRefreshTokenToStorage(null);
    saveRememberMeToStorage(false);
    googleUser = null;
    tokenFromLogin = null;
    rememberMe = false;
    try {
      googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google Sign-In Canceled');
      } else {
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          // Printing the user token for demonstration purposes.
          print('User Token: ${googleAuth.accessToken}');
          print('User gmail: ${googleUser!.email}');
          var accessToken = googleAuth.accessToken;
          var userName = googleUser!.email;
          UserService userService = UserService();
          tokenFromLogin = await userService.login(userName, accessToken!);
          googleUser = null;
          if (messageCheckpermission == "OK") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("แจ้งเตือน"),
                  content: Text("บัญชีนี้ได้ถูกลงทะเบียนแล้ว"),
                  actions: [
                    ElevatedButton(
                      child: Text("OK"),
                      onPressed: () {
                        tokenFromLogin = null;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            return;
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => LoadingWidget(),
            );
            print('Token From API: ${tokenFromLogin?.token}');
            await Future.delayed(Duration(seconds: 2));
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => QRCodeScannerScreen()));
          }
        } else {
          print('Google Sign-In Failed');
        }
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }*/


  /*Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () async {
        // If a sign-in operation is already in progress, return early

        await _googleSignIn.signOut();
        saveTokenToStorage(null);
        saveRefreshTokenToStorage(null);
        saveRememberMeToStorage(false);
        googleUser = null;
        tokenFromLogin = null;
        rememberMe = false;
        try {
          googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) {
            print('Google Sign-In Canceled');
          } else {
            final GoogleSignInAuthentication googleAuth =
                await googleUser!.authentication;

            final AuthCredential credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );
            final UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);
            if (userCredential.user != null) {
              // Printing the user token for demonstration purposes.
              print('User Token: ${googleAuth.accessToken}');
              print('User gmail: ${googleUser!.email}');
              var accessToken = googleAuth.accessToken;
              var userName = googleUser!.email;
              UserService userService = UserService();
              tokenFromLogin = await userService.login(userName, accessToken!);
              googleUser = null;
              if (messageCheckpermission == "OK") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("แจ้งเตือน"),
                      content: Text("บัญชีนี้ได้ถูกลงทะเบียนแล้ว"),
                      actions: [
                        ElevatedButton(
                          child: Text("OK"),
                          onPressed: () {
                            tokenFromLogin = null;
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
                return;
              } else {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => LoadingWidget(),
                );
                print('Token From API: ${tokenFromLogin?.token}');
                await Future.delayed(Duration(seconds: 2));
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => QRCodeScannerScreen()));
              }
            } else {
              print('Google Sign-In Failed');
            }
          }
        } catch (e) {
          print('Google Sign-In Error: $e');
        }
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF61F4BC),
                      Color(0xFF66F6E2),
                      Color(0xFF38EED5),
                      Color(0xFf1DD1B8),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                         // borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/app_icons.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )  ,

                      SizedBox(
                        height: 50.0,
                      ),
                      Text(
                        'Sign In / Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(height: 30.0),
                      // _buildEmailTF(),
                      SizedBox(
                        height: 50.0,
                      ),
                      JustLogIn(),
                      //_buildForgotPasswordBtn(),
                      //_buildRememberMeCheckbox(),
                      //_buildLoginBtn(),
                     // _buildSignInWithText(),
                      _buildSocialBtnRow(),
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

  /*Future<void> logoutAndsignInWithGoogle() async {
    await _googleSignIn.signOut();
    saveTokenToStorage(null);
    saveRefreshTokenToStorage(null);
    saveRememberMeToStorage(false);
    googleUser = null;
    tokenFromLogin = null;
    rememberMe = false;
    try {
      googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        print('Google Sign-In Canceled');
      } else {
        final GoogleSignInAuthentication googleAuth =
            await googleUser!.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          // Printing the user token for demonstration purposes.
          print('User Token: ${googleAuth.accessToken}');
          print('User gmail: ${googleUser!.email}');
          var accessToken = googleAuth.accessToken;
          var userName = googleUser!.email;
          UserService userService = UserService();
          tokenFromLogin = await userService.login(userName, accessToken!);
          if (messageCheckpermission == "Anonymous User") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("แจ้งเตือน"),
                  content: Text("บัญชีนี้ยังไม่ถูกลงทะเบียนในระบบ"),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                      ),
                      child: Text("OK"),
                      onPressed: () {
                        googleUser = null;
                        tokenFromLogin = null;
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text("Sign Up"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        googleUser = null;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRCodeScannerScreen()));
                      },
                    ),
                  ],
                );
              },
            );
            return;
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => LoadingWidget(),
            );
            print('Token From API: ${tokenFromLogin?.token}');
            await Future.delayed(Duration(seconds: 2));
            await saveTokenToStorage(tokenFromLogin!.token);
            rememberMe = true;
            await saveRememberMeToStorage(rememberMe);
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          }
        } else {
          print('Google Sign-In Failed');
        }
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
    }
  }*/
}

/*class UserProfileSscreen extends StatelessWidget {
  //final GoogleSignInAccount googleUser;

  //UserProfileScreen(this.googleUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage("" ?? ''),
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${"googleUser.email" ?? ''}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'Name: ${"googleUser.email" ?? ''}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
*/
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
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*Future<void> saveTokenToStorage(String? token) async {
  final prefs = await SharedPreferences.getInstance();
  if (token != null) {
    prefs.setString(tokenKey, token);
  } else {
    // Clear the stored token if it's null
    prefs.remove(tokenKey);
  }
}

Future<String?> getTokenFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(tokenKey);
}*/

/*Future<void> saveRefreshTokenToStorage(String? refreshToken) async {
  final prefs = await SharedPreferences.getInstance();
  if (refreshToken != null) {
    prefs.setString(refreshtokenKey, refreshToken);
  } else {
    prefs.remove(refreshtokenKey);
  }
}

Future<String?> getRefreshTokenFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(refreshtokenKey);
}*/

/*Future<void> saveRememberMeToStorage(bool rememberMe) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(rememberMeKey, rememberMe);
}

Future<bool> getRememberMeFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(rememberMeKey) ?? false;
}*/

saveUser(String key,value) async {
  final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
}

readUser (String key) async {
  final prefs = await SharedPreferences.getInstance();
  var js = json.decode(prefs.getString(key) as String);
  return LoggedUser(js["email"], js['token'], js['refresh_token'], js['img_url']) ;
}

remove(String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}

