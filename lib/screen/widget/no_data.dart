import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/util/size_config.dart';

class NoData {
  Widget showNoData(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/emptyimg.png'), // Replace with your image path
                fit: BoxFit.contain),
            // Adjust the radius as needed
          ),
          width: sizeWidth(160, context),
          height: sizeHeight(200, context),
        ),
        Text(
          "no-data".i18n(),
          style: TextStyle(
              fontSize: sizeHeight(24, context), color: Colors.black45),
        )
      ],
    );
  }
}
//How to Use NoData().showNoData(context)