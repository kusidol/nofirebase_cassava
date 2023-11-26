import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';

import '../../env.dart';

class CardMoreDetail extends StatelessWidget {
  CardMoreDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildReadOnlyField(String label, String value, IconData) {
      return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Adjust the radius value as needed
          ),
          elevation: 8,
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Row(
                children: [
                  CircleAvatar(
                      backgroundColor:
                          HotelAppTheme.buildLightTheme().primaryColor,
                      child: Icon(
                        IconData,
                        color: Colors.white,
                      )),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(label,
                            style: TextStyle(
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            )),
                        Text(value,
                            style: TextStyle(
                              fontSize: sizeHeight(22, context),
                              // fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            )),
                      ],
                    ),
                  )
                ],
              )));
    }

    Widget CardRow() {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Adjust the radius value as needed
        ),
        elevation: 8,
        color: theme_color4.withOpacity(0.9),
        child: Container(
          height: sizeHeight(120, context),
          width: sizeWidth(170, context),
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Text(
                "data1",
                style: GoogleFonts.kanit(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: sizeHeight(25, context),
                ),
              ),
              SizedBox(
                height: sizeHeight(18, context),
              ),
              Expanded(
                child: Text(
                  "area-label".i18n(),
                  style: GoogleFonts.kanit(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: sizeHeight(16, context),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    var widget;
    return Column(
      children: [
        buildReadOnlyField(
            "code-field-label".i18n(), 'code', Icons.vpn_key_sharp),
        buildReadOnlyField("ss", "s", Icons.vpn_key_sharp),
        buildReadOnlyField("ss", "s", Icons.vpn_key_sharp),
        buildReadOnlyField("ss", "s", Icons.vpn_key_sharp),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CardRow(), CardRow()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CardRow(), CardRow()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CardRow(), CardRow()],
        )
      ],
    );
  }
}
