import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:mun_bot/controller/service.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/notification_screen/notification_screen.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/home/base_home_screen.dart';

import 'package:mun_bot/screen/sidebar_menu.dart';
import 'package:mun_bot/social_login/ui/auth-page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../map/map_ui_screen.dart';

import '../../util/size_config.dart';
import '../surveys_serch/survey_search_screen.dart';
import 'package:localization/localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MenuScreen extends StatefulWidget {
  TabController mainTapController;
  SurveyProvider surveyProvider;
  MenuScreen(this.mainTapController, this.surveyProvider, {Key? key})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  double topEleven = 0;
  double topTen = 0;
  double topNine = 0;
  double topEight = 0;
  double topSeven = 0;
  double topSix = 0;
  double topFive = 0;
  double topFour = 0;
  double topThree = 0;
  double topTwo = 0;
  double topOne = 0;

  static const textColor = Colors.black;
  static const bgIcon = theme_color3;

  String? token;
  late int count = 0;

  late bool _permissionReady;
  late String _localPath;

  bool checkNoti = false;
   Color notificationColor = Colors.grey.shade800 ;
  @override
  void initState() {
    super.initState();
    token = tokenFromLogin?.token;
    PlantingProvider plantingProvider =
        Provider.of<PlantingProvider>(context, listen: false);
    plantingProvider.resetFieldID();
    SurveyProvider surveyProvider = widget.surveyProvider;
    surveyProvider.resetPlantingID();
    getCountMessage();
     getNotificationToStorage().then((storedNotification) {
      setState(() {
      checkNoti= storedNotification;
      if (checkNoti == true) {
       notificationColor = Colors.green;
      } else {
        notificationColor = Colors.grey.shade800;
      }
      });
    });
    _permissionReady = false;
    _localPath = "";

    // Request permission when the app starts
    _checkPermission();
  }

  Future<void> getCountMessage() async {
    Service service = Service();
    try {
      var response = await service.doGet(
          "$LOCAL_SERVER_IP_URL/messagereceiver/countmessage",
          token.toString());
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.data);
        print(responseBody);
        setState(() {
          count = responseBody['body'] as int;
        });
      }
    } catch (e) {}
  }

  Future<void> _checkPermission() async {
    final status = await Permission.storage.status;
    print("Permission status: $status");
    if (status != PermissionStatus.granted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        setState(() {
          _permissionReady = true;
        });
      } else {
        print("Permission not granted");
      }
    } else {
      setState(() {
        _permissionReady = true;
      });
    }
  }

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

  Future<void> _downloadPdf() async {
    final dio = Dio();
    final url =
        "http://cpeserver.eng.kps.ku.ac.th:8080/cassava/api/manual/download";
    final fileName = "userManual.pdf";

    try {
      Directory? directory;

      if (Platform.isAndroid) {
        // Use path_provider to get the external storage directory on Android
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        // Handle iOS-specific directory if needed
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory != null) {
        final filePath = '${directory.path}/$fileName';

        final response = await dio.download(url, filePath);
        if (response.statusCode == 200) {
          showToastMessage("Download Success at $filePath");
        } else {
          showToastMessage("Download Failed");
        }
      } else {
        print("Platform not supported.");
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
      showToastMessage("Permission not granted");
    }
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    SurveyProvider surveyProvider = widget.surveyProvider;
    //print("menu Screen context :${context}");
    return Consumer<PlantingProvider>(
      builder: (context, plantingProvider, index) {
        return WillPopScope(
          onWillPop: () => onBackButtonPressed(context),
          child: Scaffold(
            body: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(),
                ),
                SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    //physics: BouncingScrollPhysics(),
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0),
                              theme_color3.withOpacity(.4),
                              theme_color4.withOpacity(1),
                              //Colors.white.withOpacity(1),
                              //Colors.white.withOpacity(1),
                            ],
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: SafeArea(
                            child: Column(
                              children: [
                                Padding(
                                    padding:
                                        EdgeInsets.all(sizeHeight(5, context))),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sizeWidth(25, context)),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: sizeHeight(
                                                          10, context))),
                                              Text(
                                                'welcome-to-munbot-label'
                                                    .i18n(),
                                                style: TextStyle(
                                                  color: textColor,
                                                  fontSize:
                                                      sizeHeight(18, context),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'have-a-good-day-label'.i18n(),
                                                style: TextStyle(
                                                    fontSize:
                                                        sizeHeight(10, context),
                                                    color:
                                                        Colors.deepPurple[200]),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(
                                                sizeHeight(1, context)),
                                            child: count != null && count != 0
                                                ? Badge(
                                                    position:
                                                        BadgePosition.topEnd(
                                                            top: 0, end: 0),
                                                    animationDuration: Duration(
                                                        milliseconds: 100),
                                                    animationType:
                                                        BadgeAnimationType
                                                            .scale,
                                                    badgeContent: Text(
                                                      count != null &&
                                                              count != 0
                                                          ? count.toString()
                                                          : '',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    child: IconButton(
                                                        icon: Icon(
                                                          Icons.notifications,
                                                          color:
                                                             checkNoti ? Colors.green : Colors.grey.shade800,
                                                          size: sizeHeight(
                                                              25, context),
                                                        ),
                                                        onPressed: () {
                                                          //print("home");
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        NotificationScreen()),
                                                          );
                                                        }),
                                                  )
                                                : IconButton(
                                                    icon: Icon(
                                                      Icons.notifications,
                                                      color: notificationColor,
                                                      size: sizeHeight(
                                                          25, context),
                                                    ),
                                                    onPressed: () {
                                                      //print("home");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                NotificationScreen()),
                                                      );
                                                    }),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NavBar()),
                                              );
                                            },
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Container(
                                                width: sizeWidth(35, context),
                                                height: sizeHeight(35, context),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width:
                                                        sizeWidth(1, context),
                                                  ),
                                                  image: DecorationImage(
                                                    image: (loggedUser.img_url == "")? AssetImage('assets/images/no_profile_img.png') as ImageProvider : MemoryImage(Base64Decoder().convert(loggedUser.img_url)),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: sizeHeight(10, context),
                                      ),
                                      //
                                      Padding(
                                          padding: EdgeInsets.all(
                                              sizeHeight(5, context))),
                                      Container(
                                        height: sizeHeight(300, context),
                                        decoration: BoxDecoration(
                                          color: bgIcon.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                              sizeHeight(15, context)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              sizeHeight(10, context)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: bgIcon
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  sizeHeight(10,
                                                                      context)),
                                                        ),
                                                        width: sizeWidth(
                                                            150, context),
                                                        height: sizeHeight(
                                                            90, context),
                                                        child: IconButton(
                                                            alignment: Alignment
                                                                .center,
                                                            icon: Icon(
                                                                Icons
                                                                    .access_alarm,
                                                                size: sizeHeight(
                                                                    60,
                                                                    context),
                                                                color: Colors
                                                                    .orange),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        BaseHomeScreen(
                                                                            plantingProvider,
                                                                            surveyProvider)),
                                                              );
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        height: sizeHeight(
                                                            8, context),
                                                      ),
                                                      Text(
                                                        "schedule-label".i18n(),
                                                        style: TextStyle(
                                                          color: textColor,
                                                          fontSize: sizeHeight(
                                                              16, context),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  //Map
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: bgIcon
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  sizeHeight(10,
                                                                      context)),
                                                        ),
                                                        width: sizeWidth(
                                                            150, context),
                                                        height: sizeHeight(
                                                            90, context),
                                                        child: IconButton(
                                                            icon: Icon(
                                                              Icons.search,
                                                              size: sizeHeight(
                                                                  60, context),
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) => SearchSurveyFieldScreen(
                                                                        widget
                                                                            .mainTapController,
                                                                        surveyProvider)),
                                                              );
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        height: sizeHeight(
                                                            8, context),
                                                      ),
                                                      Text(
                                                        "survey-point-label"
                                                            .i18n(),
                                                        style: TextStyle(
                                                          color: textColor,
                                                          fontSize: sizeHeight(
                                                              16, context),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: sizeHeight(20, context),
                                              ),
                                              //schedule

                                              //Menu4
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: sizeHeight(25, context),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            'agencies'.i18n(),
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize: sizeHeight(22, context),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(
                                              sizeHeight(10, context))),

                                      bannerCarousel(context)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _currentIndexCarousel = 0;
  List imgList = [
    'assets/images/Menupic/arda.png',
    'assets/images/Menupic/doae.png',
    'assets/images/Menupic/doa.png',
    'assets/images/Menupic/tmd.png',
  ];
  final List<Uri> uriList = [
    Uri.parse("https://www.arda.or.th/"), //สำนักงานพัฒนาการวิจัยการเกษตร
    Uri.parse("https://www.doae.go.th/"), //กรมส่งเสริมการเกษตร
    Uri.parse("https://www.doa.go.th/th/"), //กรมวิชาการเกษตร
    Uri.parse("https://www.tmd.go.th/"), //กรมอุตุนิยมวิทยา
  ];
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  Future<void> _launchURL(BuildContext context, String uriToString) async {
    final theme = Theme.of(context);
    try {
      await launch(
        uriToString,
        customTabsOption: CustomTabsOption(
          toolbarColor: theme.primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsSystemAnimation.slideIn(),
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Colors.amber,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  Widget bannerCarousel(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: sizeHeight(150, context),
            initialPage: 0,
            enlargeCenterPage: true,
            autoPlay: true,
            reverse: false,
            enableInfiniteScroll: true,
            aspectRatio: 16 / 9,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 2000),
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndexCarousel = index;
              });
            },
          ),
          items: imgList.map((imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    print("click");
                    _launchURL(
                        context, uriList[_currentIndexCarousel].toString());
                  },
                  child: Container(
                    width: sizeWidth(343, context),
                    height: sizeHeight(150, context),
                    margin: EdgeInsets.symmetric(
                        horizontal: sizeHeight(10, context)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(sizeHeight(10,
                          context)), // Adjust the value for different border radii
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          sizeHeight(10, context)), // Same value as above
                      child: Padding(
                        padding: EdgeInsets.all(sizeHeight(8, context)),
                        child: Image.asset(
                          imgUrl,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: sizeHeight(10, context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: map<Widget>(imgList, (index, Url) {
            return Container(
              width: sizeWidth(10, context),
              height: sizeHeight(10, context),
              margin: EdgeInsets.symmetric(
                  vertical: sizeHeight(10, context),
                  horizontal: sizeWidth(2, context)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndexCarousel == index
                    ? Colors.black
                    : Colors.white,
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<bool> onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('แจ้งเตือน'),
            content: Text('ต้องการออกจากแอปพลิเคชั่น?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text('Yes'),
              ),
            ],
          );
        });

    return exitApp;
  }
}
