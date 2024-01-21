import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localization/src/localization_extension.dart';
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

class AnimatedListItem extends StatefulWidget {
  //final int index;

  final VoidCallback? callback;
  final VoidCallback? callback2;
  final FieldData fieldData;
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

  final FieldProviders fieldProviders;

  AnimatedListItem({
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
    this.callback2,
    this.callback,
    required this.fieldData,
    this.date,
    required this.fieldProviders,
  }) : super(key: key);

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem> {
  bool _animate = false;

  bool _isStart = true;

  @override
  void initState() {
    super.initState();
    if (_isStart) {
      Future.delayed(Duration(milliseconds: 250), () {
        if (!mounted) {
          return;
        }
        setState(() {
          _animate = true;
          _isStart = false;
        });
      });
    } else {
      _animate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String itemNameShow = "No Data";
    if (widget.itemID != null) {
      if (widget.itemID!.length > 15) {
        itemNameShow = widget.itemID!.substring(0, 12) + "...";
      } else {
        itemNameShow = widget.itemID.toString();
      }
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _animate ? 1 : 0,
      curve: Curves.easeInOutQuart,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 500),
        padding: _animate
            ? const EdgeInsets.all(4.0)
            : const EdgeInsets.only(top: 10),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 16),
          child: InkWell(
            splashColor: Colors.white,
            onTap: widget.callback,
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
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
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
                                    " " + "field-label".i18n() + " : ",
                                    style: TextStyle(
                                        fontSize: sizeHeight(18, context),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: sizeWidth(170, context),
                                    child: ExpandableText(
                                      widget.itemName.toString(),
                                      expandText:
                                          '${widget.itemName.toString().substring(0, 7)}',
                                      collapseText: 'show less',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: sizeHeight(18, context),
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
                                        primary:
                                            theme_color2, // Change the button color here
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              sizeHeight(50,
                                                  context)), // Set the border radius here
                                        ),
                                        minimumSize: Size(
                                            sizeHeight(80, context),
                                            sizeHeight(50, context)),
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FieldMoreDetailScreen(
                                                    widget.field,
                                                    widget.owner,
                                                    widget.fieldData,
                                                    widget.image,
                                                    widget.fieldProviders)),
                                      ),
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
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: sizeWidth(8, context),
                                    right: sizeWidth(8, context)),
                                child: Row(
                                  children: [
                                    Text(
                                      '     ' + 'field-code'.i18n() + ': ',
                                      style: TextStyle(
                                        fontSize: sizeHeight(14, context),
                                      ),
                                    ),
                                    SizedBox(
                                      width: sizeWidth(170, context),
                                      child: ExpandableText(
                                        '$itemNameShow',
                                        expandText:
                                            '${itemNameShow.substring(0, 3)}',
                                        collapseText: 'show less',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: sizeHeight(16, context),
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
                                      ' ' + "owner".i18n(),
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
                                      ' ${widget.district}',
                                      style: TextStyle(
                                        fontSize: sizeHeight(14, context),
                                      ),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: sizeWidth(170, context),
                                      child: ExpandableText(
                                        ' ${widget.itemOwnerName} ${widget.itemOwnerLastName}',
                                        expandText: '${widget.itemOwnerName}',
                                        collapseText: 'show less',
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: sizeHeight(14, context),
                                        ),
                                        textAlign: TextAlign.right,
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
                                      '     ${widget.city} ',
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
  }
}
