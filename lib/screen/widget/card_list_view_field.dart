import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/entities/field.dart';

import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/field_provider.dart';
import 'package:mun_bot/screen/field/field_more_detail.dart';

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
                                          ))),
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

class CardItemWithOutImageField extends StatelessWidget {
  CardItemWithOutImageField({
    Key? key,
    required this.field,
    required this.owner,
    required this.location,
    this.image,
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
    required this.fieldProviders,
  }) : super(key: key);

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final Field field;
  final User owner;
  final String location;
  final ImageData? image;
  final String? itemID;
  final String? itemName;
  final String? itemOwnerName;
  final String? itemOwnerLastName;
  final String? city;
  final String? district;
  final String? date;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final FieldProviders fieldProviders;
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
                                        Icons.grass,
                                        color: theme_color2,
                                        size: sizeHeight(25, context),
                                      ),
                                      Text(
                                        '  ${itemName}',
                                        style: TextStyle(
                                            fontSize: sizeHeight(18, context),
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
                                            //print('Button Pressed');
                                          },
                                          child: IconButton(
                                            icon: Icon(
                                                Icons.info_outline_rounded),
                                            color: Colors.white,
                                            iconSize: sizeHeight(20, context),
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FieldMoreDetailScreen(
                                                          field,
                                                          owner,
                                                          location,
                                                          image,
                                                          fieldProviders)),
                                            ),
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
                                          '     รหัสแปลง: ',
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sizeWidth(170, context),
                                          child: ExpandableText(
                                            '$itemNameShow',
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
