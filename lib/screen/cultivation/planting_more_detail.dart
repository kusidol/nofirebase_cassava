import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';

import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/variety_provider.dart';

import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/screen/cultivation/base_cultivation_screen.dart';
import 'package:mun_bot/screen/cultivation/new_cultivation_screen.dart';
import 'package:mun_bot/screen/main_screen.dart';
import 'package:mun_bot/screen/widget/card_list_view.dart';
import 'package:mun_bot/screen/survey/survey_target/create_survey_target.dart';
import 'package:mun_bot/screen/widget/card_more_detail.dart';
import 'package:mun_bot/util/ui/calendar_popup_view.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import '../../util/size_config.dart';
//import 'package:mun_bot/screen/size_config.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';

import 'package:mun_bot/screen/survey/create_survey_screen.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/util/change_date_time.dart';

import 'card_planting_more_detail.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class PlantingMoreDetailScreen extends StatefulWidget {
  final Planting plantings;
  PlantingProvider provider;

  PlantingMoreDetailScreen(this.plantings, this.provider);

  @override
  State<StatefulWidget> createState() => _PlantingMoreDetailScreen();
}

class _PlantingMoreDetailScreen extends State<PlantingMoreDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;
  String storyImage = 'assets/images/cassava_field.jpg';

  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _inerscrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List<Planting> platingList = [];
  bool _istLoading = true;
  bool _isLoadMore = false;
  int page = 1;
  int check = 0;
  SampleItem? selectedMenu;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();

    super.dispose();
  }

  Widget pictureUI() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: GestureDetector(
        child: AspectRatio(
          aspectRatio: 1.6 / 2,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(storyImage), fit: BoxFit.cover),
            ),
            child: Container(
              padding: EdgeInsets.all(sizeHeight(10, context)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sizeHeight(15, context)),
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.9),
                    Colors.black.withOpacity(.1),
                  ])),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: sizeWidth(10, context),
                    right: sizeWidth(8, context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('confirm-deletion'.i18n()),
          //content: Text("Are you sure you want to delete the question?"),
          actions: <Widget>[
            FlatButton(
              child: Text('no'.i18n()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('yes'.i18n()),
              onPressed: () {
                _handleDeletion();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDeletion() async {
    bool isDelete = await widget.provider.deletePlanting(widget.plantings);
    if (isDelete == 200) {
      // Navigator.of(context).pop();
    } else {}
  }

  Widget testMain(String input) {
    return Container(
      alignment: Alignment.topLeft,
      width: SizeConfig.screenWidth,
      height: sizeHeight(50, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$input",
            style: TextStyle(
              fontSize: sizeHeight(20, context),
              fontWeight: kPoppinsBold.fontWeight,
            ),
          ),
          SizedBox(width: sizeWidth(40, context)),
          Padding(
            padding: EdgeInsets.all(sizeWidth(1, context)),
            child: IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: Colors.grey,
                size: sizeWidth(25, context),
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
                                color:
                                    HotelAppTheme.buildLightTheme().shadowColor,
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
                                              widget.plantings,
                                              widget.provider),
                                    ));
                              },
                            ),
                            ListTile(
                              leading: new Icon(
                                Icons.delete,
                                color:
                                    HotelAppTheme.buildLightTheme().shadowColor,
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
                                _deleteConfirmation();
                              },
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: sizeWidth(1, context), color: kWhite),
      )),
      padding: EdgeInsets.all(sizeHeight(10, context)),
    );
  }

  Widget _createSurveybutton() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.01,
      right: MediaQuery.of(context).size.width * 0.01,
      child: GestureDetector(
        child: isVisible == true
            ? Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme()
                      .primaryColor
                      .withOpacity(0.75),
                  borderRadius: BorderRadius.all(
                    Radius.circular(sizeHeight(38, context)),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: sizeHeight(8, context)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(sizeHeight(32, context)),
                    ),
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       maintainState: false,
                      //       builder: (context) =>
                      //           new BaseSurveyDetailInfo(null)),
                      // );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(sizeHeight(16, context)),
                      child: Icon(Icons.add,
                          size: sizeHeight(20, context),
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor),
                    ),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }

  Widget _buildTextOne(
    String head1,
    String input1,
    String head2,
    String input3,
    String head4,
    String input5,
    String head6,
    String input7,
    String head8,
    String input9,
    String head10,
    String input11,
    String head12,
    String input13,
    String head14,
    String input15,
    String head16,
    String input17,
    String head18,
    String input19,
    String head20,
    String input21,
    String head22,
    String input23,
    String head24,
    String input25,
    String head26,
    String input27,
    String head28,
    String input29,
    String head30,
    String input31,
    String head32,
    String input33,
  ) {
    return Container(
      alignment: Alignment.topLeft,
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head1",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input1',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: sizeWidth(60, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head2",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input3',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(10, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head4",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input5',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: sizeWidth(46, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head6",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input7',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(35, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head8",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input9',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: sizeWidth(25, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head10",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input11',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: sizeWidth(25, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head12",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input13',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(15, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head14",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input15',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(35, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head16",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input17',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: sizeWidth(25, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head18",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input19',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: sizeWidth(25, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head20",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input21',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(15, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head22",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input23',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(30, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head24",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input25',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(10, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head26",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input27',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(10, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head28",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input29',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: sizeHeight(15, context),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head30",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input31',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: sizeWidth(25, context),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$head32",
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: sizeHeight(15, context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: sizeHeight(5, context),
                  ),
                  Text(
                    '$input33',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: sizeHeight(17, context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: sizeWidth(1, context), color: kWhite),
      )),
      padding: EdgeInsets.all(sizeHeight(10, context)),
    );
  }

  Widget _buildTextTwo(
    String head1,
    String input1,
    String head2,
    String input3,
    String head4,
    String input5,
    String head6,
    String input7,
    String head8,
    String input9,
    String head10,
    String input11,
    String head12,
    String input13,
    String head14,
    String input15,
    String head16,
    String input17,
    String head18,
    String input19,
    String head20,
    String input21,
    String head22,
    String input23,
    String head24,
    String input25,
  ) {
    return Container(
      alignment: Alignment.topLeft,
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight,
      child: Column(children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head1",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input1',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(25, context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head2",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input3',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(10, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head4",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input5',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(25, context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head6",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input7',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(15, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head8",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input9',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(55, context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head10",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input11',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(20, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head12",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input13',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(55, context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head14",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input15',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(20, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head16",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input17',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(55, context),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head18",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input19',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(20, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head20",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input21',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(30, context),
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(20, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head22",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input23',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(30, context),
            ),
          ],
        ),
        SizedBox(
          height: sizeHeight(20, context),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$head24",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: sizeHeight(15, context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: sizeHeight(5, context),
                ),
                Text(
                  '$input25',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sizeHeight(17, context),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sizeWidth(30, context),
            ),
          ],
        ),
      ]),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: sizeWidth(1, context), color: kWhite),
      )),
      padding: EdgeInsets.all(sizeHeight(10, context)),
    );
  }

  Widget _buildListView() {
    String storyImage = 'assets/images/map.png';

    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 1,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          child: Container(
            padding: EdgeInsets.all(sizeHeight(10, context)),
            width: SizeConfig.screenWidth,
            height: MediaQuery.of(context).size.height * 2.1,
            child: GestureDetector(
              onTap: () {},
              child: AspectRatio(
                aspectRatio: 1.7 / 2,
                child: Container(
                  //margin: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(),
                  child: Container(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /*testMain("code-planting-label".i18n() +
                            widget.plantings.plantingId.toString()),
                        _buildTextOne(
                            "name-planting-label".i18n(),
                            widget.plantings.name.toString(),
                            "area-label".i18n(),
                            widget.plantings.size.toString(),
                            "previous-plant-label".i18n(),
                            widget.plantings.previousPlant.toString() == "อื่นๆ"
                                ? widget.plantings.previousPlantOther.toString()
                                : widget.plantings.previousPlant.toString(),
                            "beside-plant-label".i18n(),
                            widget.plantings.besidePlant.toString() == "อื่นๆ"
                                ? widget.plantings.besidePlantOther.toString()
                                : widget.plantings.besidePlant.toString(),
                            "primary-plant-type-label".i18n(),
                            "มันสำปะหลัง",
                            "primary-plant-variety-label".i18n(),
                            widget.plantings.primaryVarietyOther.toString(),
                            "planting-date-label".i18n(),
                            ChangeDateTime(
                                widget.plantings.primaryPlantPlantingDate),
                            "havest-date-label".i18n(),
                            ChangeDateTime(widget.plantings.primaryPlantHarvestDate) ==
                                    "01-01-1970"
                                ? "no-specified".i18n()
                                : ChangeDateTime(
                                    widget.plantings.primaryPlantHarvestDate),
                            "secondary-plant-type-label".i18n(),
                            widget.plantings.secondaryPlantType.toString() == ""
                                ? "no-specified".i18n()
                                : widget.plantings.secondaryPlantType
                                    .toString(),
                            "secondary-plant-variety-label".i18n(),
                            widget.plantings.secondaryPlantVariety.toString() == ""
                                ? "no-specified".i18n()
                                : widget.plantings.secondaryPlantVariety
                                    .toString(),
                            "planting-date-label".i18n(),
                            ChangeDateTime(widget.plantings.secondaryPlantPlantingDate) ==
                                    "01-01-1970"
                                ? "no-specified".i18n()
                                : ChangeDateTime(widget
                                    .plantings.secondaryPlantPlantingDate),
                            "havest-date-label".i18n(),
                            ChangeDateTime(widget.plantings.secondaryPlantHarvestDate) ==
                                    "01-01-1970"
                                ? "no-specified".i18n()
                                : ChangeDateTime(
                                    widget.plantings.secondaryPlantHarvestDate),
                            "number-tillage-label".i18n(),
                            widget.plantings.numTillage.toString(),
                            "soil-amendments-label".i18n(),
                            widget.plantings.soilAmendments.toString() == "อื่นๆ"
                                ? widget.plantings.soilAmendmentsOther
                                    .toString()
                                : widget.plantings.soilAmendments.toString(),
                            "soaking-stem-chemical-label".i18n(),
                            widget.plantings.soakingStemChemical.toString(),
                            "filling-temp-1-label".i18n(),
                            ChangeDateTime(widget.plantings.fertilizerDate1) ==
                                    "01-01-1970"
                                ? "no-specified".i18n()
                                : ChangeDateTime(
                                    widget.plantings.fertilizerDate1),
                            "filling-soil-label".i18n(),
                            widget.plantings.fertilizerFormular1.toString() == ""
                                ? "no-specified".i18n()
                                : widget.plantings.fertilizerFormular1
                                    .toString()),
                        _buildTextTwo(
                          "filling-temp-2-label".i18n(),
                          ChangeDateTime(widget.plantings.fertilizerDate2) ==
                                  "01-01-1970"
                              ? "no-specified".i18n()
                              : ChangeDateTime(
                                  widget.plantings.fertilizerDate2),
                          "filling-soil-label".i18n(),
                          widget.plantings.fertilizerFormular2.toString() == ""
                              ? "no-specified".i18n()
                              : widget.plantings.fertilizerFormular2.toString(),
                          "filling-temp-3-label".i18n(),
                          ChangeDateTime(widget.plantings.fertilizerDate3) ==
                                  "01-01-1970"
                              ? "no-specified".i18n()
                              : ChangeDateTime(
                                  widget.plantings.fertilizerDate3),
                          "filling-soil-label".i18n(),
                          widget.plantings.fertilizerFormular3.toString() == ""
                              ? "no-specified".i18n()
                              : widget.plantings.fertilizerFormular3.toString(),
                          "month-of-weeding-1-label".i18n(),
                          widget.plantings.weedingMonth1.toString() == "0"
                              ? "no-specified".i18n()
                              : widget.plantings.weedingMonth1.toString(),
                          "chemicals-used-label".i18n(),
                          widget.plantings.weedingChemicalOther1.toString() ==
                                  ""
                              ? (widget.plantings.herbicideByWeedingChemical1 ==
                                      -1
                                  ? "no-specified".i18n()
                                  : weedingChemicalName[widget.plantings
                                          .herbicideByWeedingChemical1 -
                                      1])
                              : widget.plantings.weedingChemicalOther1
                                  .toString(),
                          "month-of-weeding-2-label".i18n(),
                          widget.plantings.weedingMonth2.toString() == "0"
                              ? "no-specified".i18n()
                              : widget.plantings.weedingMonth2.toString(),
                          "chemicals-used-label".i18n(),
                          widget.plantings.weedingChemicalOther2.toString() ==
                                  ""
                              ? (widget.plantings.herbicideByWeedingChemical2 ==
                                      -1
                                  ? "no-specified".i18n()
                                  : weedingChemicalName[widget.plantings
                                          .herbicideByWeedingChemical2 -
                                      1])
                              : widget.plantings.weedingChemicalOther2
                                  .toString(),
                          "month-of-weeding-3-label".i18n(),
                          widget.plantings.weedingMonth3.toString() == "0"
                              ? "no-specified".i18n()
                              : widget.plantings.weedingMonth3.toString(),
                          "chemicals-used-label".i18n(),
                          widget.plantings.weedingChemicalOther3.toString() ==
                                  ""
                              ? (widget.plantings.herbicideByWeedingChemical3 ==
                                      -1
                                  ? "no-specified".i18n()
                                  : weedingChemicalName[widget.plantings
                                          .herbicideByWeedingChemical3 -
                                      1])
                              : widget.plantings.weedingChemicalOther3
                                  .toString(),
                          "disease-management-label".i18n(),
                          widget.plantings.diseaseManagement.toString() == ""
                              ? "no-specified".i18n()
                              : widget.plantings.diseaseManagement.toString(),
                          "pest-management-label".i18n(),
                          widget.plantings.pestManagement.toString() == ""
                              ? "no-specified".i18n()
                              : widget.plantings.pestManagement.toString(),
                          "note-label".i18n(),
                          widget.plantings.note.toString() == ""
                              ? "no-specified".i18n()
                              : widget.plantings.note.toString(),
                        ),*/
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(sizeHeight(65, context)),
          child: getAppBarUI(),
        ),
        body: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(1),
                            theme_color3.withOpacity(.4),
                            theme_color4.withOpacity(1),
                            //Colors.white.withOpacity(1),
                            //Colors.white.withOpacity(1),
                          ],
                        ),
                      ),
                      width: SizeConfig.screenWidth,
                      height: MediaQuery.of(context).size.height * 0.90,
                      child: CardPlantingMoreDetail(
                          widget.plantings, widget.provider),
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

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: sizeHeight(8, context)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: sizeWidth(8, context),
            right: sizeWidth(8, context)),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + sizeHeight(40, context),
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
                    padding: EdgeInsets.all(sizeHeight(8, context)),
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
                  'planting-more-detail-label'.i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 0,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeHeight(32, context)),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeHeight(32, context)),
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
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
