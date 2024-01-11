import 'dart:convert';
import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/variety_service.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/variety.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/screen/cultivation/base_cultivation_screen.dart';
import 'package:mun_bot/screen/cultivation/new_cultivation_screen.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:mun_bot/util/change_date_time.dart';

import '../../env.dart';

class CardPlantingMoreDetail extends StatefulWidget {
  final Planting planting;
  PlantingProvider plantingProvider;

  CardPlantingMoreDetail(this.planting, this.plantingProvider);

  @override
  State<CardPlantingMoreDetail> createState() => _CardPlantingMoreDetailState();
}

class _CardPlantingMoreDetailState extends State<CardPlantingMoreDetail> {
  List<String> varietyName = [];
  int countVariety = 0;
  @override
  void initState() {
    // TODO: implement initState
    asyncFunction();
  }

  asyncFunction() async {
    String? token = tokenFromLogin?.token;
    VarietyService varietyService = VarietyService();
    List<Variety> varieties = await varietyService.getVarietiesByPlantingId(
        token.toString(), widget.planting.plantingId);
    List<String> temp = [];
    for (int i = 0; i < varieties.length; i++) {
      temp.add(varieties[i].name);
    }
    setState(() {
      varietyName = temp;
      countVariety = varietyName.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget CardRow() {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        color: theme_color4.withOpacity(0.9),
        child: Container(
          height: sizeHeight(116, context),
          width: sizeWidth(170, context),
          padding: EdgeInsets.all(sizeHeight(15, context)),
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

    void _handleDeletion() async {
      bool isDeleted =
          await widget.plantingProvider.deletePlanting(widget.planting);
      if (isDeleted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {}
    }

    _deleteConfirmation(context) => showCupertinoDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('confirm-deletion'.i18n()),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'no'.i18n(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  _handleDeletion();
                },
                child: Text(
                  'yes'.i18n(),
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );

    Widget buildTopic(
        String label1, String value1, String label2, String value2, IconData) {
      return Card(
        margin: EdgeInsets.all(sizeHeight(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                width: sizeWidth(250, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          label1,
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            // fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: sizeWidth(110, context),
                          child: ExpandableText(
                            ' ${value1}',
                            expandText: '${value1}',
                            collapseText: 'show less',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          label2,
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            // fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: sizeWidth(110, context),
                          child: ExpandableText(
                            ' ${value2}',
                            expandText: '${value2}',
                            collapseText: 'show less',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                        size: sizeHeight(25, context),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              height: sizeHeight(150, context),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: new Icon(
                                      Icons.edit,
                                      color: HotelAppTheme.buildLightTheme()
                                          .shadowColor,
                                      size: sizeWidth(25, context),
                                    ),
                                    title: new Text(
                                      "Edit".i18n(),
                                      style: TextStyle(
                                        fontSize: sizeHeight(17, context),
                                        fontWeight: kPoppinsRegular.fontWeight,
                                        color: HotelAppTheme.buildLightTheme()
                                            .shadowColor,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            maintainState: false,
                                            builder: (context) =>
                                                NewCultivationScreen(
                                                    0,
                                                    widget.planting,
                                                    widget.plantingProvider),
                                          ));
                                    },
                                  ),
                                  ListTile(
                                    leading: new Icon(
                                      Icons.delete,
                                      color: HotelAppTheme.buildLightTheme()
                                          .shadowColor,
                                      size: sizeWidth(25, context),
                                    ),
                                    title: new Text(
                                      "Delete".i18n(),
                                      style: TextStyle(
                                        fontSize: sizeHeight(17, context),
                                        fontWeight: kPoppinsRegular.fontWeight,
                                        color: HotelAppTheme.buildLightTheme()
                                            .shadowColor,
                                      ),
                                    ),
                                    onTap: () {
                                      // _deleteConfirmation();
                                      _deleteConfirmation(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget buildFourText(
        String label1,
        String value1,
        String label2,
        String value2,
        String label3,
        String value3,
        String label4,
        String value4,
        IconData) {
      return Card(
        margin: EdgeInsets.all(sizeWidth(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                width: sizeWidth(150, context),
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExpandableText(
                      label1,
                      maxLines: 1,
                      expandText: 'show more',
                      collapseText: 'show less',
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label3,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: sizeWidth(20, context),
              ),
              SizedBox(
                width: sizeWidth(140, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExpandableText(
                      label2,
                      expandText: '',
                      collapseText: 'show less',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label4,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value4,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildFourText_Variety(
        String label1,
        String value1,
        String label2,
        List<String> value2,
        String label3,
        String value3,
        String label4,
        String value4,
        IconData,
        BuildContext context1) {
      return Card(
        margin: EdgeInsets.all(sizeWidth(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                width: sizeWidth(150, context),
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExpandableText(
                      label1,
                      maxLines: 1,
                      expandText: 'show more',
                      collapseText: 'show less',
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label3,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: sizeWidth(20, context),
              ),
              SizedBox(
                width: sizeWidth(140, context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExpandableText(
                      label2,
                      expandText: '',
                      collapseText: 'show less',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    // Text(
                    //   value2,
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.w600,
                    //     fontSize: sizeHeight(16, context),
                    //     // fontWeight: FontWeight.bold,
                    //     // color: Colors.grey
                    //   ),
                    // ),
                    SizedBox(
                      height: sizeHeight(20, context),
                      // width: sizeWidth(20, context),
                      child: ListView.builder(
                        itemCount: countVariety,
                        itemBuilder: (context, index) {
                          return Text(
                            varietyName[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              // fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label4,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value4,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildOneText(String label1, String value1, IconData) {
      return Card(
        margin: EdgeInsets.all(sizeHeight(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label1,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: sizeWidth(20, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpandableText(
                        value1,
                        // overflow: TextOverflow.ellipsis,
                        expandText: 'show more',
                        collapseText: 'show less',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sizeHeight(16, context),
                          //fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildThreeTextTwoRow(
        String label1,
        String value1,
        String label2,
        String value2,
        String label3,
        String value3,
        String label4,
        String value4,
        String label5,
        String value5,
        String label6,
        String value6,
        IconData) {
      return Card(
        margin: EdgeInsets.all(sizeHeight(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label1,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label3,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value3,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label5,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value5,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(70, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label2,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value2,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label4,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value4,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Text(
                      label6,
                      style: TextStyle(
                        fontSize: sizeHeight(16, context),
                        //fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                    Text(
                      value6,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sizeHeight(16, context),
                        // fontWeight: FontWeight.bold,
                        // color: Colors.grey
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildSixText(
        String label1,
        String value1,
        String label2,
        String value2,
        String label3,
        String value3,
        String label4,
        String value4,
        String label5,
        String value5,
        String label6,
        String value6,
        IconData) {
      return Card(
        margin: EdgeInsets.all(sizeHeight(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label1,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(110, context),
                        child: ExpandableText(
                          ' : ${value1}',
                          expandText: '',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label2,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(170, context),
                        child: ExpandableText(
                          ' : ${value2}',
                          expandText: '',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label3,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(110, context),
                        child: ExpandableText(
                          ' : ${value3}',
                          expandText: '',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label4,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(170, context),
                        child: ExpandableText(
                          ' : ${value4}',
                          expandText: '',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label5,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(110, context),
                        child: ExpandableText(
                          ' : ${value5}',
                          expandText: '',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                  Row(
                    children: [
                      Text(
                        label6,
                        style: TextStyle(
                          fontSize: sizeHeight(16, context),
                          // fontWeight: FontWeight.bold,
                          // color: Colors.grey
                        ),
                      ),
                      SizedBox(
                        width: sizeWidth(170, context),
                        child: ExpandableText(
                          ' : ${value6}',
                          expandText: '',
                          collapseText: 'show less',
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: sizeHeight(8, context),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget buildFourText2(
        String label1,
        String value1,
        String label2,
        String value2,
        String label3,
        String value3,
        String label4,
        String value4,
        IconData) {
      return Card(
        margin: EdgeInsets.all(sizeHeight(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          label1,
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            // fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: sizeWidth(110, context),
                          child: ExpandableText(
                            ' :${value1}',
                            expandText: '${value1}',
                            collapseText: 'show less',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          label2,
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            // fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: sizeWidth(110, context),
                          child: ExpandableText(
                            ' :${value2}',
                            expandText: '${value2}',
                            collapseText: 'show less',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          label3,
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            // fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: sizeWidth(140, context),
                          child: ExpandableText(
                            ' :${value3}',
                            expandText: '${value3}',
                            collapseText: 'show less',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          label4,
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            // fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        SizedBox(
                          width: sizeWidth(140, context),
                          child: ExpandableText(
                            ' :${value4}',
                            expandText: 'show more',
                            collapseText: 'show less',
                            maxLines: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sizeHeight(16, context),
                              //fontWeight: FontWeight.bold,
                              // color: Colors.grey
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildFiveText(
        String label1,
        String value1,
        String label2,
        String value2,
        String label3,
        String value3,
        String label4,
        String value4,
        String label5,
        String value5,
        IconData) {
      return Card(
        margin: EdgeInsets.all(sizeHeight(12, context)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              sizeWidth(10, context)), // Adjust the radius value as needed
        ),
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: sizeWidth(4, context),
              horizontal: sizeHeight(4, context)),
          child: Row(
            children: [
              CircleAvatar(
                  radius: sizeHeight(25, context),
                  backgroundColor: HotelAppTheme.buildLightTheme().primaryColor,
                  child: Icon(
                    IconData,
                    color: Colors.white,
                    size: sizeHeight(25, context),
                  )),
              Container(
                margin: EdgeInsets.only(left: sizeWidth(10, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${label1}: ",
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        Text(
                          "${value1}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          "${label2}: ",
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        Text(
                          "${value2}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          "${label3}: ",
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        Text(
                          "${value3}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          "${label4}: ",
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        Text(
                          "${value4}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                    Row(
                      children: [
                        Text(
                          "${label5}: ",
                          style: TextStyle(
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                        Text(
                          "${value5}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sizeHeight(16, context),
                            //fontWeight: FontWeight.bold,
                            // color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: sizeHeight(8, context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: sizeHeight(8, context),
          ),
          buildTopic(
              "code-planting-label".i18n(),
              widget.planting.code.toString(),
              "name-planting-label".i18n(),
              widget.planting.name.toString(),
              Icons.vpn_key_sharp),
          buildFourText2(
              "area-label".i18n(),
              widget.planting.size.toString(),
              "previous-plant-label".i18n(),
              widget.planting.previousPlant.toString() == "อื่นๆ"
                  ? widget.planting.previousPlantOther.toString()
                  : widget.planting.previousPlant.toString(),
              "beside-plant-label".i18n(),
              widget.planting.besidePlant.toString() == "อื่นๆ"
                  ? widget.planting.besidePlantOther.toString()
                  : widget.planting.besidePlant.toString(),
              "soaking-stem-chemical-label".i18n(),
              widget.planting.soakingStemChemical.toString(),
              Icons.grass),
          buildFourText_Variety(
              "primary-plant-type-label".i18n(),
              "มันสำปะหลัง",
              "primary-plant-variety-label".i18n(),
              varietyName,
              "planting-date-label".i18n(),
              ChangeDateTime(widget.planting.primaryPlantPlantingDate),
              "havest-date-label".i18n(),
              ChangeDateTime(widget.planting.primaryPlantHarvestDate) ==
                      "1 ม.ค. 2513"
                  ? "no-specified".i18n()
                  : ChangeDateTime(widget.planting.primaryPlantHarvestDate),
              Icons.eco_sharp,
              context),
          buildFourText(
              "secondary-plant-type-label".i18n(),
              widget.planting.secondaryPlantType.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.secondaryPlantType.toString(),
              "secondary-plant-variety-label".i18n(),
              widget.planting.secondaryPlantVariety.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.secondaryPlantVariety.toString(),
              "planting-date-label".i18n(),
              ChangeDateTime(widget.planting.secondaryPlantPlantingDate) ==
                      "1 ม.ค. 2513"
                  ? "no-specified".i18n()
                  : ChangeDateTime(widget.planting.secondaryPlantPlantingDate),
              "havest-date-label".i18n(),
              ChangeDateTime(widget.planting.secondaryPlantHarvestDate) ==
                      "1 ม.ค. 2513"
                  ? "no-specified".i18n()
                  : ChangeDateTime(widget.planting.secondaryPlantHarvestDate),
              Icons.eco_sharp),
          buildFiveText(
              "stem-source-label".i18n(),
              widget.planting.stemSource.toString(),
              "number-tillage-label".i18n(),
              widget.planting.numTillage.toString(),
              "soil-amendments-label".i18n(),
              widget.planting.soilAmendments.toString() == "อื่นๆ"
                  ? widget.planting.soilAmendmentsOther.toString()
                  : widget.planting.soilAmendments.toString(),
              "disease-management-label".i18n(),
              widget.planting.diseaseManagement.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.diseaseManagement.toString(),
              "pest-management-label".i18n(),
              widget.planting.pestManagement.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.pestManagement.toString(),
              Icons.emoji_nature_sharp),
          buildThreeTextTwoRow(
              "filling-temp-1-label".i18n(),
              ChangeDateTime(widget.planting.fertilizerDate1) == "1 ม.ค. 2513"
                  ? "no-specified".i18n()
                  : ChangeDateTime(widget.planting.fertilizerDate1),
              "filling-soil-label".i18n(),
              (widget.planting.fertilizerFormular1.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.fertilizerFormular1.toString()),
              "filling-temp-2-label".i18n(),
              ChangeDateTime(widget.planting.fertilizerDate2) == "1 ม.ค. 2513"
                  ? "no-specified".i18n()
                  : ChangeDateTime(widget.planting.fertilizerDate2),
              "filling-soil-label".i18n(),
              widget.planting.fertilizerFormular2.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.fertilizerFormular2.toString(),
              "filling-temp-3-label".i18n(),
              ChangeDateTime(widget.planting.fertilizerDate3) == "1 ม.ค. 2513"
                  ? "no-specified".i18n()
                  : ChangeDateTime(widget.planting.fertilizerDate3),
              "filling-soil-label".i18n(),
              widget.planting.fertilizerFormular3.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.fertilizerFormular3.toString(),
              Icons.filter_hdr_sharp),
          buildSixText(
              "month-of-weeding-1-label".i18n(),
              widget.planting.weedingMonth1.toString() == "0"
                  ? "no-specified".i18n()
                  : widget.planting.weedingMonth1.toString(),
              "chemicals-used-label".i18n(),
              widget.planting.weedingChemicalOther1.toString() == ""
                  ? (widget.planting.herbicideByWeedingChemical1 == -1
                      ? "no-specified".i18n()
                      : weedingChemicalName[
                          widget.planting.herbicideByWeedingChemical1 - 1])
                  : widget.planting.weedingChemicalOther1.toString(),
              "month-of-weeding-2-label".i18n(),
              widget.planting.weedingMonth2.toString() == "0"
                  ? "no-specified".i18n()
                  : widget.planting.weedingMonth2.toString(),
              "chemicals-used-label".i18n(),
              widget.planting.weedingChemicalOther2.toString() == ""
                  ? (widget.planting.herbicideByWeedingChemical2 == -1
                      ? "no-specified".i18n()
                      : weedingChemicalName[
                          widget.planting.herbicideByWeedingChemical2 - 1])
                  : widget.planting.weedingChemicalOther2.toString(),
              "month-of-weeding-3-label".i18n(),
              widget.planting.weedingMonth3.toString() == "0"
                  ? "no-specified".i18n()
                  : widget.planting.weedingMonth3.toString(),
              "chemicals-used-label".i18n(),
              widget.planting.weedingChemicalOther3.toString() == ""
                  ? (widget.planting.herbicideByWeedingChemical3 == -1
                      ? "no-specified".i18n()
                      : weedingChemicalName[
                          widget.planting.herbicideByWeedingChemical3 - 1])
                  : widget.planting.weedingChemicalOther3.toString(),
              Icons.dangerous_sharp),
          buildOneText(
              "note-label".i18n(),
              widget.planting.note.toString() == ""
                  ? "no-specified".i18n()
                  : widget.planting.note.toString(),
              Icons.event_note_sharp),
        ],
      ),
    );
  }
}
