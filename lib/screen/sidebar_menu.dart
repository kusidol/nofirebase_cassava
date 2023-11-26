import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:localization/localization.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/screen/menuscreen/change_language.dart';
import 'package:mun_bot/util/size_config.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import 'login/login_screen.dart';

import 'package:mun_bot/social_login/ui/auth-page.dart';

final String notiStatusKey = 'noti_status';
final String autoLogInStatusKey = 'auto_login_status';

Color notificationColor = Colors.grey.shade800;

class NavBar extends StatefulWidget {
  bool notificationStatus = false;
  TargetPlatform platform = defaultTargetPlatform;
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with WidgetsBindingObserver {
  late bool _permissionReady;
  late String _localPath;

  @override
  void initState() {
    super.initState();
    _permissionReady = false;
    _localPath = "";
    WidgetsBinding.instance!.addObserver(this);
    getNotificationToStorage().then((storedNotification) {
      setState(() {
        widget.notificationStatus = storedNotification;
        if (storedNotification == true) {
          notificationColor = Colors.green;
        } else {
          notificationColor = Colors.grey.shade800;
        }
      });
    });
    // Request permission when the app starts
    _checkPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final granted = await Permission.storage.isGranted;
      if (granted) {
        setState(() {
          _permissionReady = true;
        });

        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _checkPermission() async {

    final granted = await Permission.storage.isGranted;

    if (granted){
      setState(() {
          _permissionReady = true;
      });
    }

  }

  showAboutDialog(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("Permission Denied"),
          content: Text('Allow access to Storage'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel')),
            CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () => openAppSettings(),
                child: Text('Settings')),
          ],
        ),
      );
  Future<String?> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      return directory.path;
    }
    return null;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath);
    final hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  // Future<void> _downloadPdf() async {
  //   final dio = Dio();
  //   final url =
  //       "http://cpeserver.eng.kps.ku.ac.th:8080/cassava/api/manual/download";
  //   final fileName = "userManual.pdf";

  //   try {
  //     Directory? directory;

  //     if (Platform.isAndroid) {
  //       // Use path_provider to get the external storage directory on Android
  //       directory = await getExternalStorageDirectory();
  //     } else if (Platform.isIOS) {
  //       // Handle iOS-specific directory if needed
  //       directory = await getApplicationDocumentsDirectory();
  //     }

  //     if (directory != null) {
  //       final filePath = '${directory.path}/$fileName';

  //       final response = await dio.download(url, filePath);
  //       if (response.statusCode == 200) {
  //         showToastMessage("Download Success at $filePath");
  //       } else {
  //         showToastMessage("Download Failed");
  //       }
  //     } else {
  //       print("Platform not supported.");
  //     }
  //   } catch (e) {
  //     showToastMessage("Download Failed");
  //   }
  // }
  Future<void> _downloadPdf() async {
    final dio = Dio();
    final url = "${LOCAL_SERVER_IP_URL}/manual/download";
    final fileName = "userManual.pdf";
    final filePath =
        '/storage/emulated/0/Download/$fileName'; // Specify the desired path

    try {
      final response = await dio.download(url, filePath);
      if (response.statusCode == 200) {
        showToastMessage("Download Success at $filePath");
      } else {
        showToastMessage("Download Failed");
      }
    } catch (e) {
      showToastMessage("Download Failed");
    }
  }

  void showToastMessage(String msg) {
    FlutterToastr.show(msg, context,
        duration: 5,
        position: FlutterToastr.bottom,
        backgroundColor: theme_color,
        textStyle: TextStyle(fontSize: 15, color: Colors.black));
  }

  Future<void> _checkPermissionAndDownloadPdf() async {
    if (_permissionReady) {
      await _prepareSaveDir();
      showToastMessage("Downloading...");
      await _downloadPdf();
    } else {
      // Handle the case where permission is not granted
      showAboutDialog(context);
      //showToastMessage("Permission not granted");
    }
  }

  void alertNoti(BuildContext context, bool values) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: values == true
              ? Text('ต้องการที่จะเปิดการแจ้งเตือน?')
              : Text('ต้องการที่จะปิดการแจ้งเตือน?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('ไม่'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.notificationStatus = values;
                  print(widget.notificationStatus);
                  values == true
                      ? notificationColor = Colors.green
                      : notificationColor = Colors.grey.shade800;
                });
                Navigator.of(context).pop();
              },
              child: Text('ใช่'),
            ),
          ],
        );
      },
    );
  }

  Color autoLoginColor = Colors.grey.shade800;
  void alertAutoLogin(BuildContext context, bool values) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: values == true
              ? Text('ต้องการที่จะเปิดการเข้าสู่ระบบอัตโนมัติ?')
              : Text('ต้องการที่จะปิดการเข้าสู่ระบบอัตโนมัติ?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('ไม่'),
            ),
            ElevatedButton(
              onPressed: () {

                setState(() async {
                  if (autoLogInStatus == false) {
                    autoLogInStatus = true;
                  } else {
                    autoLogInStatus = false;
                  }
                  //print(autoLogInStatus.toString());
                  saveAutoLogInStatusToStorage(autoLogInStatus);

                  values == true
                      ? autoLoginColor = Colors.green
                      : autoLoginColor = Colors.grey.shade800;
                });
                Navigator.of(context).pop();
              },
              child: Text('ใช่'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    //final GoogleSignIn _googleSignIn = GoogleSignIn();

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(loggedUser.email ,
                style: TextStyle(fontSize: sizeHeight(15, context))),
            accountEmail: Text(loggedUser.email ,
                style: TextStyle(fontSize: sizeHeight(15, context))),
            currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Container(
                  width: sizeWidth(50, context),
                  height: sizeHeight(50, context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: sizeWidth(2, context)),
                    image: DecorationImage(
                      image: (loggedUser.img_url == "")? AssetImage('assets/images/no_profile_img.png') as ImageProvider : MemoryImage(Base64Decoder().convert(loggedUser.img_url)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ) /*ClipOval(
                child: Image.network(
                  'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),*/

                ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/Menupic/profilebg.jpg"),
                colorFilter: ColorFilter.mode(
                  Colors.blue.withOpacity(0.3),
                  BlendMode.color,
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: sizeHeight(12, context))),
          ExpansionTile(
            title: Text(
              "setting-label".i18n(),
              style: TextStyle(fontSize: sizeHeight(18, context)),
            ),
            leading: Icon(Icons.settings, size: sizeHeight(25, context)),
            children: [
              SwitchListTile(
                activeColor: theme_color,
                value: widget.notificationStatus,
                onChanged: (bool values) {
                  setState(() {
                    widget.notificationStatus = values;
                    print(widget.notificationStatus);
                    saveNotificationToStorage(widget.notificationStatus);
                    values == true
                        ? notificationColor = Colors.green
                        : notificationColor = Colors.grey.shade800;
                  });
                  values == true
                      ? showToastMessage("การแจ้งเตือนเปิดอยู่")
                      : showToastMessage("การแจ้งเตือนปิด");
                },
                secondary: Icon(
                  Icons.notifications,
                  size: sizeHeight(25, context),
                  color: notificationColor,
                ),
                title: Text(
                  "notification-label".i18n(),
                  style: TextStyle(
                    fontSize: sizeHeight(18, context),
                    color: notificationColor,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.language, size: sizeHeight(25, context)),
                title: Text(
                  'change-value'.i18n(),
                  style: TextStyle(fontSize: sizeHeight(18, context)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeLanguage()),
                  );
                },
              ),
              SwitchListTile(
                  activeColor: theme_color,
                  value: autoLogInStatus,
                  onChanged: (bool values) async {
                    setState(() {
                      autoLogInStatus = values ;
                     /* if (autoLogInStatus == false) {
                        autoLogInStatus = true;
                      } else {
                        autoLogInStatus = false;
                      }*/
                      //print(autoLogInStatus.toString());
                      saveAutoLogInStatusToStorage(values);

                      values == true
                          ? autoLoginColor = Colors.green
                          : autoLoginColor = Colors.grey.shade800;
                    });
                    values == true
                        ? showToastMessage("เปิดการล็อคอินอัตโนมัติ")
                        : showToastMessage("ปิดการล็อคอินอัตโนมัติ");
                  },
                  secondary: Icon(
                    Icons.login,
                    size: sizeHeight(25, context),
                    color: autoLoginColor,
                  ),
                  title: Text('SignIn'.i18n(),
                      style: TextStyle(
                          fontSize: sizeHeight(18, context),
                          color: autoLoginColor))),
              ListTile(
                leading: Icon(Icons.person, size: sizeHeight(25, context)),
                title: Text(
                  'delete-account'.i18n(),
                  style: TextStyle(fontSize: sizeHeight(18, context)),
                ),
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Delete Account'),
                      content: Text('delete-account-message'.i18n()
                      ,style: TextStyle(fontSize: 15),),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => {

                            Navigator.pop(context, 'Cancel')

                          },
                          child: Text('cancle'.i18n(),
                              style: TextStyle(color: Colors.blue,fontSize: SizeConfig.AlertfontSize)),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Show a loading dialog
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => LoadingWidget(),
                            );

                            UserService uservice = UserService();

                            uservice.deleteAccount(tokenFromLogin!.token).then((value) async {

                              if(value == true){

                                saveAutoLogInStatusToStorage(false);

                                await remove("user");

                                await Future.delayed(Duration(seconds: 2));

                                Navigator.pop(context);

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                      (route) => false,
                                );
                              }

                            });
                          },
                          child: Text(
                            'delete'.i18n(),
                            style: TextStyle(color: Colors.red,fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: sizeHeight(12, context))),
          ListTile(
            leading:
                Icon(Icons.menu_book_rounded, size: sizeHeight(25, context)),
            title: Text(
              'user-manual'.i18n(),
              style: TextStyle(fontSize: sizeHeight(18, context)),
            ),
            onTap: () async {
              // Navigator.pop(context); // Close the drawer
              await _checkPermissionAndDownloadPdf();
            },
          ),
          Padding(padding: EdgeInsets.only(top: sizeHeight(12, context))),
          ListTile(
              title: Text('exit-label'.i18n(),
                  style: TextStyle(fontSize: sizeHeight(18, context))),
              leading: Icon(Icons.exit_to_app, size: sizeHeight(25, context)),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Text('logout'.i18n()),
                    content: Text('exit-application'.i18n()),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => {
                          Navigator.pop(context, 'Cancel')
                        },
                        child: Text('cancle'.i18n(),
                            style: TextStyle(color: Colors.blue)),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Show a loading dialog
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => LoadingWidget(),
                          );

                          setState(() {
                            autoLogInStatus = false ;
                          });

                          saveAutoLogInStatusToStorage(false);

                          await remove("user");

                          await Future.delayed(Duration(seconds: 2));
                          
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'logout'.i18n(),
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ListTile(
            title: Text(
              'back-to-main'.i18n(),
              style: TextStyle(fontSize: sizeHeight(18, context)),
            ),
            leading: Icon(Icons.arrow_back, size: sizeHeight(25, context)),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return MainScreen();
                }),
                (r) {
                  return false;
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

void  saveAutoLogInStatusToStorage(bool autoLogInStatus)  {
  final prefs = SharedPreferences.getInstance().then((value)  {
      value.setBool(autoLogInStatusKey, autoLogInStatus);
      return true;
  });

}

Future<bool> getAutoLogInStatusFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(autoLogInStatusKey) ?? false;
}

Future<void> saveNotificationToStorage(bool _notiStatus) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(notiStatusKey, _notiStatus);
}

Future<bool> getNotificationToStorage() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(notiStatusKey) ?? false;
}
