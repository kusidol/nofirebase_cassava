import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mun_bot/controller/user_Service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/providers/dropdown_provider.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/screen/sidebar_menu.dart';
import 'package:mun_bot/social_login/ui/auth-page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
//import 'package:splashscreen/splashscreen.dart';
import 'entities/enemy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:month_year_picker/month_year_picker.dart';
import 'package:localization/localization.dart';
import 'entities/token.dart';
//import 'package:firebase_core/firebase_core.dart';

class MyHttpOverrides extends HttpOverrides{

  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
//import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart' ;
// Token? tokenFromLogin;

bool autoLogInStatus = false;
Token? tokenFromLogin;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
   WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that the WidgetsBinding is initialized.

  // Locks the device orientation to portrait mode only
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(

      MultiProvider(
    providers: [
      ChangeNotifierProvider<TabPassModel>(
        create: (BuildContext context) {
          return TabPassModel();
        },
        // child: MyApp(),
      ),
      ChangeNotifierProvider<DropdownProvider>(
          create: (final BuildContext context) {
        return DropdownProvider();
      }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
  // This widget is the root of your application.

}

class MyAppState extends State<MyApp> {
  Locale? _locale;
  initState() {
    // tokenFromLogin = Token("123");
    _locale = Locale('th', 'TH');
    asyncFunction();
    // Initialize EasyLoading
    EasyLoading.init();
  }

  void asyncFunction() async {
    WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();
    //UserService userService = UserService();
    // Token? t = await userService.login("rojjanakorn.y@ku.th");
    // tokenFromLogin = t;
    // print("token  on main is ${tokenFromLogin}");
  }

  changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['assets/lang'];

    return MaterialApp(
      title: 'MunSurvey',
      locale: _locale,
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) {
          return locale;
        }

        if (locale?.languageCode == 'en') {
          return Locale('en', 'US');
        }
        return Locale('th', 'TH');
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: SplashScreen(),
      localizationsDelegates: [
        //S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        //MonthYearPickerLocalizations.delegate,
        LocalJsonLocalization.delegate,
      ],
      supportedLocales: [
        Locale('th', 'TH'),
        Locale('en', 'US'),
      ],
      builder: EasyLoading.init(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );



    getAutoLogInStatusFromStorage().then((status) async {

      setState(() {
        autoLogInStatus = status ;
      });

        if(status){

          loggedUser = await readUser("user");

          tokenFromLogin = Token(loggedUser.token) ;

          Map<String, dynamic> decodedToken =

          JwtDecoder.decode(tokenFromLogin!.token);

          DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);

          if(DateTime.now().isAfter(expirationDate)){

            UserService userService = UserService();
           // bool? checkRefreshtoken =
            bool? isExpired = await userService.refreshTokentoLogin(loggedUser.refresh_token);

            if(!isExpired!){
              Navigator.of(context).pushReplacement(
                FadeRoute1(LoginScreen()),
              );
              return ;
            }
          }
          Navigator.of(context).pushReplacement(
            FadeRoute1(MainScreen()),
          );

        }else{

          _fadeAnimation =
              Tween<double>(begin: 0, end: 1).animate(_animationController);

          _animationController.forward();

          Future.delayed(Duration(seconds: 5), () async {
            await requestCameraPermission(); // Request camera permission

            Navigator.of(context).pushReplacement(
              FadeRoute1(LoginScreen()),
            );
          });
        }
    });
  }

  // Function to request camera permission
  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      // Request camera permission
      final result = await Permission.camera.request();
      if (result.isDenied) {
        // Handle the case where the user denied camera permission
        // You can show a dialog or message here
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your existing build method
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logomun.png',
              width: 250,
              height: 250,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Fade
class FadeRoute1 extends PageRouteBuilder {
  final Widget page;

  FadeRoute1(this.page)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: page,
          ),
        );
}
