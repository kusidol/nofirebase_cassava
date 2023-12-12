import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/entities/enemy.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/providers/field_dropdown_provider.dart';
import 'package:mun_bot/providers/field_provider.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/home/base_home_screen.dart';
import 'package:mun_bot/screen/cultivation/base_cultivation_screen.dart';
import 'package:mun_bot/screen/field/base_field_screen.dart';
import 'package:mun_bot/screen/map/map_ui_screen.dart';
import 'package:mun_bot/screen/menuscreen/menu_screen.dart';
import 'package:mun_bot/screen/sidebar_menu.dart';
import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/size_config.dart';

import 'package:mun_bot/screen/survey/create_survey_screen.dart';
import 'package:mun_bot/screen/survey/base_survey_screen.dart';

import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:provider/provider.dart';
//import 'package:splashscreen/splashscreen.dart';
import 'package:localization/localization.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart' ;

//เพิ่มเติม
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';

import '../main.dart';
import 'login/login_screen.dart';

//

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreen();
}

final _colorpurple = Color(0xFFA084CA);
final _colorBase = Colors.deepPurple;
final _colorBase2 = Color(0xFF645CAA);
final _colorpurple2 = Color(0xFFBFACE0);
var iconTabSize = SizeConfig.screenWidth! * 0.045;
var textSize = SizeConfig.screenWidth! * 0.045;
final _iconTabs = [];

class _MainScreen extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? _mainTapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainTapController = new TabController(vsync: this, length: 4);
    // _mainTapController = new TabController(vsync: this, length: 5);
  }

  Widget textTabbar(String textIn) {
    return Text(textIn, style: TextStyle(fontSize: sizeHeight(12, context)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ////print(SizeConfig.screenHeight);
    var iconTabSize = SizeConfig.screenWidth! * 0.043;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //home: DefaultTabController(

      //length: 5,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: SizeConfig.screenHeight,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) {
                    return PlantingProvider();
                  },
                ),
                ChangeNotifierProvider(
                  create: (context) {
                    return SurveyProvider();
                  },
                ),
                ChangeNotifierProvider(
                  create: (context) {
                    return FieldProviders();
                  },
                ),
                //   ChangeNotifierProvider(create: (context){
                //   return Dropdownfield();
                // },)
              ],
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                bottomNavigationBar: BottomAppBar(

                    //color: theme_color4.withOpacity(0.9),
                    child: TabBar(
                  controller: _mainTapController,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.radio_button_checked_outlined,
                        size: iconTabSize,
                      ),
                      child: textTabbar("home-label".i18n()),
                      height: SizeConfig.screenHeight! * 0.0715,
                    ),
                    Tab(
                      icon: Icon(
                        Icons.location_on_rounded,
                        size: iconTabSize,
                      ),
                      child: textTabbar("field-label".i18n()),
                      height: SizeConfig.screenHeight! * 0.0715,
                    ),
                    Tab(
                      icon: Icon(
                        Icons.image,
                        size: iconTabSize,
                      ),
                      child: textTabbar("planting-label".i18n()),
                      height: SizeConfig.screenHeight! * 0.0715,
                    ),
                    Tab(
                      icon: Icon(
                        Icons.description,
                        size: iconTabSize,
                      ),
                      child: textTabbar("survey-label".i18n()),
                      height: SizeConfig.screenHeight! * 0.0715,
                    ),
                  ],
                  //unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,

                  indicator: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(sizeHeight(30, context)),
                    color: HotelAppTheme.buildLightTheme()
                        .primaryColor
                        .withOpacity(0.3),
                  ),
                )),
                body:
                    //scrollDirection: Axis.horizontal,
                    Consumer2<SurveyProvider, PlantingProvider>(builder:
                        (context, surveyProvider, plantingProvider, index) {
                  return TabBarView(
                    controller: _mainTapController,
                    children: [
                      MenuScreen(_mainTapController!, surveyProvider),
                      BaseFieldScreen(_mainTapController!),
                      BaseCultivationScreen(
                          _mainTapController!, plantingProvider),
                      SurveyTable(_mainTapController!, surveyProvider),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),

      //),
    );
  }
}
