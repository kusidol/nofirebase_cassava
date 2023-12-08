import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/entities/planting.dart';

import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/screen/cultivation/planting_more_detail.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

import 'package:mun_bot/util/size_config.dart';

import 'package:mun_bot/util/ui/survey_theme.dart';

import 'package:mun_bot/entities/user.dart';
import '../../env.dart';

class CardItem extends StatelessWidget {
  CardItem({
    Key? key,
    this.itemID,
    this.itemOwner,
    this.city,
    this.district,
    this.animationController,
    this.animation,
    this.callback2,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final String? itemID;
  final String? itemOwner;
  final String? city;
  final String? district;
  final AnimationController? animationController;
  final Animation<double>? animation;
  List<Survey> listData = [];

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (itemID != null) {
      if (itemID!.length > 15) {
        itemNameShow = itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = itemID.toString();
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.asset(
                                'assets/images/cassava_field.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              itemNameShow,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  '${city}, ${district}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  FontAwesomeIcons.locationDot,
                                                  size: 12,
                                                  color: HotelAppTheme
                                                          .buildLightTheme()
                                                      .primaryColor,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, top: 8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          '${itemOwner}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          '(เจ้าของแปลง)',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  Colors.grey.withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            top: 12,
                            right: 12,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(32.0),
                                ),
                                onTap: callback,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Color.fromARGB(100, 22, 44, 33),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: InkWell(
                                          onTap: callback,
                                          child: Container(
                                            child: Icon(
                                              Icons.more_vert,
                                              color: HotelAppTheme
                                                      .buildLightTheme()
                                                  .primaryColor,
                                            ),
                                          ))

                                      // PopupMenuButton(
                                      //   icon: Icon(
                                      //     Icons.more_vert,
                                      //     color: HotelAppTheme.buildLightTheme()
                                      //         .primaryColor,
                                      //   ),
                                      //   itemBuilder: (context) {
                                      //     return [
                                      //       PopupMenuItem(
                                      //         value: 'info',
                                      //         child: Text('ข้อมูล'),
                                      //       ),
                                      //     ];
                                      //   },
                                      //   onSelected: (value) {
                                      //     /*if (value == 'info') {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 NewSurveyScreen(0, null)),
                                      //       );
                                      //     }*/
                                      //   },
                                      // ),
                                      ),
                                ),
                              ),
                            )),
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
}

class CardItemWithOutImage_Planting_Calendar extends StatelessWidget {
  CardItemWithOutImage_Planting_Calendar(
      {Key? key,
      this.itemID,
      this.itemName,
      this.itemOwnerName,
      this.itemOwnerLastName,
      this.city,
      this.district,
      this.animationController,
      this.animation,
      this.callback2,
      this.callback,
      this.date,
      this.plantings,
      this.provider})
      : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final String? itemID;
  final String? itemName;
  final String? itemOwnerName;
  final String? itemOwnerLastName;
  final String? city;
  final String? district;
  final String? date;
  final AnimationController? animationController;
  final Animation<double>? animation;
  Planting? plantings;
  PlantingProvider? provider;

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (itemID != null) {
      if (itemID!.length > 15) {
        itemNameShow = itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = itemID.toString();
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.white,
                onTap: callback2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                width: sizeWidth(600, context),
                                height: sizeHeight(50, context),
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: sizeWidth(15, context),
                                    top: sizeHeight(8, context),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.grass_sharp,
                                        //color: theme_color2,
                                        color: cultivation_theme_color,
                                        size: sizeHeight(25, context),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Text(
                                          '  การเพาะปลูก : ${itemID}',
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontSize: sizeHeight(16, context),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: sizeWidth(8, context),
                                            bottom: sizeHeight(4, context)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            // primary:
                                            //     theme_color2,
                                            primary:
                                                cultivation_theme_color, // Change the button color here
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the border radius here
                                            ),
                                          ),
                                          onPressed: () {
                                            // Button press logic goes here
                                            print('Button Pressed');

                                            if (plantings != null &&
                                                provider != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlantingMoreDetailScreen(
                                                            plantings!,
                                                            provider!)),
                                              );
                                            }
                                          },
                                          child: Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Colors.white,
                                            size: sizeHeight(25, context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Container(
                              width: sizeWidth(500, context),
                              height: sizeHeight(0.5, context),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Container(
                              height: sizeHeight(80, context),
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     แปลง: ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sizeWidth(170, context),
                                          child: ExpandableText(
                                            '$itemName',
                                            expandText: '${itemName}',
                                            collapseText: 'show less',
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize:
                                                    sizeHeight(16, context),
                                                fontWeight: FontWeight.w700
                                                //fontWeight: FontWeight.bold,
                                                // color: Colors.grey
                                                ),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.person,
                                          // color: theme_color2,
                                          color: cultivation_theme_color,
                                          size: sizeHeight(20, context),
                                        ),
                                        Text(
                                          " เจ้าของแปลง",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: sizeHeight(14, context),
                                          color: Colors.red,
                                        ),
                                        Text(
                                          ' ${district}',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          ' ${itemOwnerName} ${itemOwnerLastName}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context),
                                        bottom: sizeHeight(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     ${city} ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

class CardItemWithOutImage_Planting extends StatelessWidget {
  CardItemWithOutImage_Planting(
      {Key? key,
      this.itemID,
      this.itemName,
      this.itemOwnerName,
      this.itemOwnerLastName,
      this.city,
      this.district,
      this.animationController,
      this.animation,
      this.callback2,
      this.callback,
      this.date,
      this.plantings,
      this.provider})
      : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final String? itemID;
  final String? itemName;
  final String? itemOwnerName;
  final String? itemOwnerLastName;
  final String? city;
  final String? district;
  final String? date;
  final AnimationController? animationController;
  final Animation<double>? animation;
  Planting? plantings;
  PlantingProvider? provider;

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (itemID != null) {
      if (itemID!.length > 15) {
        itemNameShow = itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = itemID.toString();
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.white,
                onTap: callback2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                width: sizeWidth(600, context),
                                height: sizeHeight(50, context),
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: sizeWidth(15, context),
                                    top: sizeHeight(8, context),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.grass_sharp,
                                        //color: theme_color2,
                                        color: theme_color2,
                                        size: sizeHeight(25, context),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Text(
                                          '  การเพาะปลูก : ${itemID}',
                                          maxLines: 1,
                                          overflow: TextOverflow.fade,
                                          softWrap: false,
                                          style: TextStyle(
                                              fontSize: sizeHeight(16, context),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: sizeWidth(8, context),
                                            bottom: sizeHeight(4, context)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            // primary:
                                            //     theme_color2,
                                            primary:
                                                theme_color2, // Change the button color here
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the border radius here
                                            ),
                                          ),
                                          onPressed: () {
                                            // Button press logic goes here
                                            print('Button Pressed');
                                            if (plantings != null &&
                                                provider != null) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PlantingMoreDetailScreen(
                                                            plantings!,
                                                            provider!)),
                                              );
                                            }
                                          },
                                          child: Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Colors.white,
                                            size: sizeHeight(25, context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Container(
                              width: sizeWidth(500, context),
                              height: sizeHeight(0.5, context),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Container(
                              height: sizeHeight(80, context),
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     แปลง: ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sizeWidth(170, context),
                                          child: ExpandableText(
                                            '$itemName',
                                            expandText: '${itemName}',
                                            collapseText: 'show less',
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize:
                                                    sizeHeight(16, context),
                                                fontWeight: FontWeight.w700
                                                //fontWeight: FontWeight.bold,
                                                // color: Colors.grey
                                                ),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.person,
                                          // color: theme_color2,
                                          color: theme_color2,
                                          size: sizeHeight(20, context),
                                        ),
                                        Text(
                                          " เจ้าของแปลง",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: sizeHeight(14, context),
                                          color: Colors.red,
                                        ),
                                        Text(
                                          ' ${district}',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          ' ${itemOwnerName} ${itemOwnerLastName}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context),
                                        bottom: sizeHeight(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     ${city} ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

class CardItemWithOutImage_Calendar extends StatelessWidget {
  CardItemWithOutImage_Calendar({
    Key? key,
    this.itemID,
    this.itemName,
    this.itemOwnerName,
    this.itemOwnerLastName,
    this.city,
    this.district,
    this.animationController,
    this.animation,
    this.callback2,
    this.callback,
    this.date,
  }) : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final String? itemID;
  final String? itemName;
  final String? itemOwnerName;
  final String? itemOwnerLastName;
  final String? city;
  final String? district;
  final String? date;
  final AnimationController? animationController;
  final Animation<double>? animation;
  List<Survey> listData = [];

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (itemID != null) {
      if (itemID!.length > 15) {
        itemNameShow = itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = itemID.toString();
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.white,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                width: sizeWidth(600, context),
                                height: sizeHeight(50, context),
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: sizeWidth(15, context),
                                    top: sizeHeight(8, context),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: Colors.amber,
                                        size: sizeHeight(25, context),
                                      ),
                                      Text(
                                        '  ${date}',
                                        style: TextStyle(
                                            fontSize: sizeHeight(16, context),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: sizeWidth(8, context),
                                            bottom: sizeHeight(4, context)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors
                                                .amber, // Change the button color here
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the border radius here
                                            ),
                                          ),
                                          onPressed: callback2,
                                          child: Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Colors.white,
                                            size: sizeHeight(25, context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Container(
                              width: sizeWidth(500, context),
                              height: sizeHeight(0.5, context),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Container(
                              height: sizeHeight(80, context),
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     เพาะปลูก: ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sizeWidth(170, context),
                                          child: ExpandableText(
                                            '${itemName} ($itemNameShow)',
                                            expandText: '${itemName}',
                                            collapseText: 'show less',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: sizeHeight(16, context),
                                              //fontWeight: FontWeight.bold,
                                              // color: Colors.grey
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.person,
                                          color: Colors.amber,
                                          size: sizeHeight(20, context),
                                        ),
                                        Text(
                                          " เจ้าของแปลง",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: sizeHeight(14, context),
                                          color: Colors.red,
                                        ),
                                        Text(
                                          ' ${district}',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          ' ${itemOwnerName} ${itemOwnerLastName}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context),
                                        bottom: sizeHeight(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     ${city} ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

class CardItemWithOutImage extends StatelessWidget {
  CardItemWithOutImage({
    Key? key,
    this.itemID,
    this.itemName,
    this.itemOwnerName,
    this.itemOwnerLastName,
    this.city,
    this.district,
    this.animationController,
    this.animation,
    this.callback2,
    this.callback,
    this.date,
  }) : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final String? itemID;
  final String? itemName;
  final String? itemOwnerName;
  final String? itemOwnerLastName;
  final String? city;
  final String? district;
  final String? date;
  final AnimationController? animationController;
  final Animation<double>? animation;
  List<Survey> listData = [];

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (itemID != null) {
      if (itemID!.length > 15) {
        itemNameShow = itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = itemID.toString();
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 10 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.white,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                width: sizeWidth(600, context),
                                height: sizeHeight(50, context),
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: sizeWidth(15, context),
                                    top: sizeHeight(8, context),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: theme_color2,
                                        size: sizeHeight(25, context),
                                      ),
                                      Text(
                                        '  ${date}',
                                        style: TextStyle(
                                            fontSize: sizeHeight(16, context),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: sizeWidth(8, context),
                                            bottom: sizeHeight(4, context)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                theme_color2, // Change the button color here
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the border radius here
                                            ),
                                          ),
                                          onPressed: callback2,
                                          child: Icon(
                                            Icons.remove_red_eye_rounded,
                                            color: Colors.white,
                                            size: sizeHeight(25, context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Container(
                              width: sizeWidth(500, context),
                              height: sizeHeight(0.5, context),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Container(
                              height: sizeHeight(80, context),
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     เพาะปลูก: ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sizeWidth(170, context),
                                          child: ExpandableText(
                                            '${itemName} ($itemNameShow)',
                                            expandText: '${itemName}',
                                            collapseText: 'show less',
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: sizeHeight(16, context),
                                              //fontWeight: FontWeight.bold,
                                              // color: Colors.grey
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.person,
                                          color: theme_color2,
                                          size: sizeHeight(20, context),
                                        ),
                                        Text(
                                          " เจ้าของแปลง",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context)),
                                    child: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: sizeHeight(14, context),
                                          color: Colors.red,
                                        ),
                                        Text(
                                          ' ${district}',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          ' ${itemOwnerName} ${itemOwnerLastName}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: sizeWidth(8, context),
                                        right: sizeWidth(8, context),
                                        bottom: sizeHeight(8, context)),
                                    child: Row(
                                      children: [
                                        Text(
                                          '     ${city} ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
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
}

class CardItemForFieldNoImage extends StatelessWidget {
  CardItemForFieldNoImage({
    Key? key,
    this.itemID,
    this.itemOwner,
    this.city,
    this.district,
    this.dateTime,
    this.animationController,
    this.animation,
    this.callback2,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final String? itemID;
  final String? itemOwner;
  final String? city;
  final String? district;
  final String? dateTime;
  final AnimationController? animationController;
  final Animation<double>? animation;
  List<Survey> listData = [];

  String? token = tokenFromLogin?.token;

  User? userFromField;
  Future<User?> getOwnerByfieldIdAndRole(int id) async {
    try {
      FieldService fieldService = FieldService();
      final userFromFields =
          await fieldService.getOwnerByfieldIdAndRole(id, token.toString());
      userFromField = userFromFields;
      return userFromField;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (itemID != null) {
      if (itemID!.length > 15) {
        itemNameShow = itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = itemID.toString();
      }
    }

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.white,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                                width: sizeWidth(600, context),
                                height: sizeHeight(50, context),
                                color: HotelAppTheme.buildLightTheme()
                                    .backgroundColor,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: sizeWidth(15, context),
                                    top: sizeHeight(8, context),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.date_range,
                                        color: theme_color2,
                                        size: sizeHeight(25, context),
                                      ),
                                      Text(
                                        '  ${dateTime}',
                                        style: TextStyle(
                                            fontSize: sizeHeight(16, context),
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: sizeWidth(8, context),
                                            bottom: sizeHeight(4, context)),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                theme_color2, // Change the button color here
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  50.0), // Set the border radius here
                                            ),
                                          ),
                                          onPressed: () {
                                            // Button press logic goes here
                                            print('Button Pressed');
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: sizeHeight(25, context),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                            Container(
                              width: sizeWidth(500, context),
                              height: sizeHeight(0.5, context),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            Container(
                              color: HotelAppTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: sizeHeight(
                                                        4, context))),
                                            Row(
                                              children: [
                                                Text(
                                                  ' แปลง : ',
                                                  style: TextStyle(
                                                    fontSize:
                                                        sizeHeight(14, context),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:
                                                      sizeWidth(170, context),
                                                  child: ExpandableText(
                                                    '${itemID} ($itemOwner)',
                                                    expandText: '${itemID}',
                                                    collapseText: 'show less',
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: sizeHeight(
                                                          16, context),
                                                      //fontWeight: FontWeight.bold,
                                                      // color: Colors.grey
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: sizeHeight(
                                                        8, context))),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.locationDot,
                                                  size: sizeHeight(14, context),
                                                  color: Colors.red,
                                                ),
                                                Text(
                                                  '  ${city} ${district}',
                                                  style: TextStyle(
                                                    fontSize:
                                                        sizeHeight(14, context),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: sizeWidth(4, context),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: sizeHeight(
                                                        8, context))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: sizeHeight(8, context),
                                            right: sizeWidth(8, context)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: theme_color2,
                                              size: sizeHeight(20, context),
                                            ),
                                            Text(
                                              " เจ้าของแปลง",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize:
                                                    sizeHeight(14, context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      FutureBuilder<User?>(
                                        future: getOwnerByfieldIdAndRole(
                                            int.parse(itemOwner!)),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final user = snapshot.data!;
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: sizeHeight(14, context),
                                                  right: sizeWidth(8, context)),
                                              child: Text(
                                                user.title.toString() +
                                                    user.firstName.toString() +
                                                    " " +
                                                    user.lastName.toString(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      sizeHeight(14, context),
                                                ),
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          }
                                          // By default, show a loading indicator
                                          return CircularProgressIndicator();
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Positioned(
                        //     top: 12,
                        //     right: 12,
                        //     child: Material(
                        //       color: Colors.transparent,
                        //       child: InkWell(
                        //         borderRadius: const BorderRadius.all(
                        //           Radius.circular(32.0),
                        //         ),
                        //         onTap: callback,
                        //         child: Container(
                        //           child: Padding(
                        //               padding: const EdgeInsets.all(1.0),
                        //               child: InkWell(
                        //                   onTap: callback,
                        //                   child: Container(
                        //                     child: Icon(
                        //                       Icons.more_vert,
                        //                       color: HotelAppTheme
                        //                               .buildLightTheme()
                        //                           .primaryColor,
                        //                     ),
                        //                   ))),
                        //         ),
                        //       ),
                        //     )),
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
}
