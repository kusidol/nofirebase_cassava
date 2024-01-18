import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/util/size_config.dart';

import '../../main.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeLanguage();
}

class _ChangeLanguage extends State<ChangeLanguage> {
  List colors = [Colors.white, Colors.white];
  List lang = ["ไทย (Thai)", "English (United States)"];

  int selectedLanguage = 0;

  @override
  void initState() {
    _selectedLanguage(appSetting!.local);
  }

  void _selectedLanguage(int k) {
    selectedLanguage = k;
    for (int i = 0; i < colors.length; i++) {
      colors[i] = i == k ? Colors.black : Colors.white;
    }
  }

  List<Widget> makeLanguageList() {
    List<Widget> list = [];

    for (int i = 0; i < colors.length; i++) {
      list.add(Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          children: [
            SizedBox(
              height: sizeHeight(15, context),
            ),
            ListTile(
              leading: Text(
                (i + 1).toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
              trailing: Icon(
                Icons.check,
                size: sizeWidth(25, context),
                color: colors[i],
              ),
              title: Text(
                lang[i],
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05),
              ),
              onTap: () {
                setState(() {
                  _selectedLanguage(i);
                  //colors[i] = Colors.black ;
                });
              },
            ),
            SizedBox(
              height: sizeHeight(15, context),
            ),
          ],
        ),
      ));
    }
    return list;
  }

  Widget _ChangeLan() {
    return Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView(
          children: makeLanguageList(),
        ));
  }

  Widget getAppBarUI() {
    return Container(
      height: sizeHeight(85, context),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: sizeWidth(8, context),
            right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeHeight(32, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(8, context)),
                    child: Icon(
                      Icons.arrow_back,
                      size: sizeWidth(25, context),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'change-value'.i18n(),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeWidth(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeWidth(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        // child: Icon(FontAwesomeIcons.per,color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(theme_color),
      ),
      onPressed: () {
        setState(() {
          switch (selectedLanguage) {
            case 0:
              final myApp = context.findAncestorStateOfType<MyAppState>()!;
              myApp.changeLocale(Locale('th', 'TH'));
              break;
            case 1:
              final myApp = context.findAncestorStateOfType<MyAppState>()!;
              myApp.changeLocale(Locale('en', 'US'));
              break;
          }
          appSetting!.local = selectedLanguage;
          save("app_setting", appSetting);
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.all(sizeWidth(16, context)),
        child: Text(
          'Apply-lable'.i18n(),
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            getAppBarUI(),
            Padding(padding: EdgeInsets.all(sizeWidth(10, context))),
            // Container(
            //     width: MediaQuery.of(context).size.width * 0.9,
            //     child: Text(
            //       'Description-ChangeLanguage'.i18n(),
            //       style: TextStyle(
            //           fontSize: MediaQuery.of(context).size.width * 0.04),
            //     )),
            Padding(padding: EdgeInsets.all(sizeWidth(10, context))),
            _ChangeLan(),
            button()
          ],
        ),
      ),
    );
  }
}
