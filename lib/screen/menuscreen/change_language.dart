import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/util/size_config.dart';

import '../../main.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeLanguage();
}

List<bool> itemSelected = List<bool>.generate(2, (index) => false);
Color colorIcon = Colors.white;
Color colorIcon2 = Colors.black;
String language = "th";

class _ChangeLanguage extends State<ChangeLanguage> {
  Widget _ChangeLan() {
    return Container(
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListTile(
                leading: Text(
                  '1',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
                trailing: Icon(
                  Icons.check,
                  color: colorIcon,
                ),
                title: Text(
                  "ไทย (Thai)",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
                onTap: () {
                  setState(() {
                    colorIcon = Colors.black;
                    colorIcon2 = Colors.white;
                    language = "th";
                  });
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(0),
              ),
              child: ListTile(
                leading: Text(
                  '2',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
                trailing: Icon(
                  Icons.check,
                  color: colorIcon2,
                ),
                title: Text(
                  "English (United States)",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
                onTap: () {
                  setState(() {
                    colorIcon = Colors.white;
                    colorIcon2 = Colors.black;
                    language = "en";
                  });
                },
              ),
            )
          ],
        ));
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
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
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
        backgroundColor: MaterialStateProperty.all<Color>(theme_color),
      ),
      onPressed: () {
        setState(() {
          if (language == "th") {
            final myApp = context.findAncestorStateOfType<MyAppState>()!;
            myApp.changeLocale(Locale('th', 'TH'));
          } else if (language == "en") {
            final myApp = context.findAncestorStateOfType<MyAppState>()!;
            myApp.changeLocale(Locale('en', 'US'));
          }
        });
        Navigator.pop(context);
      },
      child: Text(
        'Apply-lable'.i18n(),
        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.05),
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
            Padding(padding: EdgeInsets.all(10)),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  'Description-ChangeLanguage'.i18n(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                )),
            Padding(padding: EdgeInsets.all(10)),
            _ChangeLan(),
            button()
          ],
        ),
      ),
    );
  }
}
