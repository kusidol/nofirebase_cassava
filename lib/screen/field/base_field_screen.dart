import 'dart:convert';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/providers/field_provider.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/field/new_field_screen.dart';
import 'package:mun_bot/screen/widget/card_list_view_field.dart';
import 'package:mun_bot/screen/widget/no_data.dart';

import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';

import 'package:mun_bot/util/ui/calendar_popup_view.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'field_more_detail.dart';

import 'package:mun_bot/entities/user.dart';
import '../../util/size_config.dart';
import 'package:mun_bot/util/change_date_time.dart';

import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class BaseFieldScreen extends StatefulWidget {
  TabController mainTapController;

  BaseFieldScreen(this.mainTapController);

  @override
  State<StatefulWidget> createState() => _BaseFieldScreen();
}

class _BaseFieldScreen extends State<BaseFieldScreen>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;

  //--------------------serach more
  // final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  bool isSearching = false;
  TextEditingController codeNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cultivationController = TextEditingController();

  String addressValue = '';
  String fieldNameValue = '';
  String ownerNameValue = '';
  String plantingNameValue = '';

  bool isShowbasicSearch = true;
  GlobalKey expansionTileKey = GlobalKey();

  //--------------------serach more

  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _inerscrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List<Field> fieldsList = [];
  bool _istLoading = true;
  bool _isLoadMore = false;

  int check = 0;

  // checking checkfieldregistrar
  bool checkCreateField = false;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
    onfirst();
  }

  @override
  void dispose() {
    animationController?.dispose();

    super.dispose();
  }

  void showToastMessage(String msg) {
    FlutterToastr.show(msg, context,
        duration: 2,
        position: FlutterToastr.bottom,
        backgroundColor: theme_color,
        textStyle: TextStyle(fontSize: 15, color: Colors.black));
  }

  onfirst() async {
    String? token = tokenFromLogin?.token;
    FieldService fieldService = FieldService();

    if (!mounted) return;

    checkCreateField = await fieldService.checkFieldRegistrar(token.toString());
    if (mounted) {
      setState(() {
        _istLoading = true;
      });
    }
    if (!mounted) return;
    FieldProviders provider =
        Provider.of<FieldProviders>(context, listen: false);
    provider.reset();
    PlantingProvider plantingProvider =
        Provider.of<PlantingProvider>(context, listen: false);
    plantingProvider.resetFieldID();
    SurveyProvider surveyProvider =
        Provider.of<SurveyProvider>(context, listen: false);
    surveyProvider.resetPlantingID();

    provider.fetchData();
    if (mounted) {
      setState(() {
        _istLoading = false;
      });
    }
  }

  Future<ImageData?> _fetchImagesById(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      FieldService fieldService = FieldService();
      final fetchedImages =
          await fieldService.fetchImages(token.toString(), id);
      return fetchedImages;
    } catch (e) {
      //print('Error fetching images: $e');
      return null;
    }
  }

  String? locationFromField;

  Future<String?> getLocationByFielID(int id) async {
    try {
      String? token = tokenFromLogin?.token;
      FieldService fieldService = FieldService();
      final locationFromFields =
          await fieldService.getLocationByFielIDs(id, token.toString());
      locationFromField = locationFromFields;
      return locationFromField;
    } catch (e) {
      //print(e);
    }
  }

  void fetchMoreData(BuildContext context) async {
    if (mounted) {
      setState(() {
        _isLoadMore = true;
      });
    }
    FieldProviders provider =
        Provider.of<FieldProviders>(context, listen: false);
    if (!isSearching) provider.fetchData();

    if (mounted) {
      setState(() {
        _isLoadMore = false;
      });
    }
  }

  Future<void> _pullRefresh() async {
    // //print("123");
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
    } else {}
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
            right: sizeWidth(8, context)),
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
                    Radius.circular(
                        MediaQuery.of(context).size.height * 0.0404),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.01),
                    // child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description,
                      size: sizeHeight(20, context),
                    ),
                    SizedBox(
                      width: sizeWidth(15, context),
                    ),
                    Text(
                      'field-label'.i18n(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.height * 0.029,
                      ),
                    ),
                  ],
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
                        Radius.circular(
                            MediaQuery.of(context).size.height * 0.0409),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.005),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            MediaQuery.of(context).size.height * 0.0409),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.005),
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

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }

  Widget getTimeDateUI() {
    var fontsize16 = MediaQuery.of(context).size.height * 0.0204;
    return Padding(
      padding: EdgeInsets.only(
          left: sizeWidth(18, context), bottom: sizeHeight(6, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(sizeHeight(4, context)),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                // setState(() {
                //   isDatePopupOpen = true;
                // });
                showDemoDialog(context: context);
              },
              child: Row(
                children: <Widget>[
                  Text(
                    'choose-date-label'.i18n(),
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: fontsize16,
                        color: Colors.grey.withOpacity(0.8)),
                  ),
                  SizedBox(
                    width: sizeWidth(8, context),
                  ),
                  Text(
                    '${DateFormat("dd, MMM").format(startDate)} - ${DateFormat("dd, MMM").format(endDate)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: fontsize16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: sizeWidth(32, context)),
            child: Container(
              decoration: BoxDecoration(
                color: HotelAppTheme.buildLightTheme().primaryColor,
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
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(16, context)),
                    child: Icon(FontAwesomeIcons.magnifyingGlass,
                        size: MediaQuery.of(context).size.height * 0.025,
                        color: HotelAppTheme.buildLightTheme().backgroundColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI(context, FieldProviders fieldProvider) {
    return !isShowbasicSearch
        ? Container()
        : Padding(
            padding: EdgeInsets.only(
                left: sizeWidth(16, context),
                right: sizeWidth(16, context),
                top: sizeHeight(0, context),
                bottom: sizeHeight(0, context)),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: sizeWidth(16, context),
                        top: sizeHeight(8, context),
                        bottom: sizeHeight(8, context)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(sizeHeight(38, context)),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: Offset(0, 2),
                              blurRadius: sizeHeight(8, context)),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: sizeWidth(16, context),
                            right: sizeWidth(16, context),
                            top: sizeHeight(4, context),
                            bottom: sizeHeight(4, context)),
                        child: TextField(
                          onChanged: (String txt) {
                            setState(() {
                              fieldNameValue = txt;
                            });
                          },
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.023,
                          ),
                          cursorColor:
                              HotelAppTheme.buildLightTheme().primaryColor,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'searchField'.i18n() + "...",
                              hintStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.019)),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: HotelAppTheme.buildLightTheme().primaryColor,
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
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (fieldNameValue == null || fieldNameValue == "") {
                          onfirst();
                        } else {
                          _handleSearchByKeyButton(fieldProvider);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(16, context)),
                        child: Icon(FontAwesomeIcons.magnifyingGlass,
                            size: MediaQuery.of(context).size.height * 0.025,
                            color: HotelAppTheme.buildLightTheme()
                                .backgroundColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget getFilterBarUI(int numItemFounded) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.01,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HotelAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: EdgeInsets.only(
              left: sizeWidth(16, context),
              right: sizeWidth(16, context),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: sizeHeight(8, context),
                        bottom: sizeHeight(8, context)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: ExpandableText(
                              'platings-founded-label'.i18n() +
                                  ' ${numItemFounded} ' +
                                  'item-label'.i18n(),
                              expandText: 'platings-founded-id-label'.i18n() +
                                  ' (${numItemFounded})',
                              collapseText: 'show less',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.0204,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateNewField(FieldProviders fieldProviders) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.01,
      right: MediaQuery.of(context).size.width * 0.01,
      child: GestureDetector(
        child: isVisible == true
            ? Container(
                decoration: BoxDecoration(
                  // color: HotelAppTheme.buildLightTheme()
                  //     .primaryColor
                  //     .withOpacity(0.75),
                  color: theme_color2.withOpacity(0.75),
                  borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.height * 0.048),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        offset: Offset(0, 2),
                        blurRadius: sizeWidth(8, context)),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(
                      Radius.circular(sizeHeight(32, context)),
                    ),
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) => Provider(
                      //         create: (context) => Dropdownfield(),
                      //         builder: (context, child) =>
                      //             NewCultivationScreen(0, null)),
                      //   ),
                      // );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewFieldScreen(
                                0, null, null, "", fieldProviders)),
                      );

                      //print("GO TO PAGE => CREATE FIELDS");
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.0204),
                      child: Icon(FontAwesomeIcons.add,
                          size: MediaQuery.of(context).size.height * 0.025,
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

  void _handleSearchFilterButton(FieldProviders provider) async {
    //call Service
    provider.reset();
    Map<String, dynamic> jsonData = {
      "address": addressValue,
      "fieldName": fieldNameValue,
      "ownerName": ownerNameValue,
    };

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    //print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    provider.searchFilter(jsonData);
    isSearching = true;
  }

  void _handleSearchByKeyButton(FieldProviders provider) async {
    //call Service

    provider.reset();
    Map<String, dynamic> jsonData = {
      "key": fieldNameValue,
    };

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    //print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    provider.searchByKey(jsonData);
    isSearching = true;
  }

  /*void _handleSearch(FieldProviders provider) async {
    //call Service
    Map<String, dynamic> jsonData = {
      "address": addressValue,
      "fieldName": fieldNameValue,
      "ownerName": ownerNameValue,
    };

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    //print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    provider.searchNull(jsonData);
    isSearching = true;
  }*/

  Widget searchMore1(FieldProviders provider) {
    var _startDateUserNameColor = Colors.black;
    String _startDateTimeText = " Start Date";

    return Column(
      children: [
        ListTile(
          title: Text('search-more'.i18n()),
          leading: Icon(
            Icons.perm_contact_calendar_outlined,
            color: isShowbasicSearch == false ? theme_color2 : Colors.grey,
            size: sizeHeight(25, context),
          ),
          trailing: Icon(
            isShowbasicSearch == false
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: isShowbasicSearch == false ? theme_color2 : Colors.grey,
            size: sizeHeight(25, context),
          ),
          onTap: () {
            setState(() {
              isShowbasicSearch = !isShowbasicSearch;
            });
          },
        ),
        if (!isShowbasicSearch)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sizeHeight(16, context)),
            child: Column(
              children: [
                Container(
                  color: Colors.tealAccent[50],
                  padding: EdgeInsets.all(sizeHeight(20, context)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: codeNameController,
                        decoration: InputDecoration(
                          labelText: "field-address".i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            addressValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      TextFormField(
                        controller: ownerController,
                        decoration: InputDecoration(
                          labelText: "name-code-field-label".i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            fieldNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      TextFormField(
                        controller: locationController,
                        decoration: InputDecoration(
                          labelText: 'owner'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            ownerNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: sizeHeight(2, context),
                      left: sizeWidth(20, context),
                      right: sizeWidth(20, context),
                      bottom: sizeHeight(20, context)),
                  height: sizeHeight(50, context),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(sizeHeight(18, context)),
                      //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
                    ),
                    onPressed: () {
                      if (addressValue == "" &&
                          fieldNameValue == "" &&
                          ownerNameValue == "") {
                        onfirst();
                      } else {
                        _handleSearchFilterButton(provider);
                      }
                    },
                    padding: EdgeInsets.all(sizeHeight(10, context)),
                    color: theme_color2,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'search'.i18n(),
                          style: TextStyle(fontSize: sizeHeight(20, context)),
                        ),
                        SizedBox(width: sizeWidth(5, context)),
                        Icon(Icons.search),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child:
            Consumer<FieldProviders>(builder: (context, fieldProvder, index) {
          return WillPopScope(
            onWillPop: () => onBackButtonPressed(context),
            child: Scaffold(
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
                      child: Flex(
                        direction: Axis.vertical,
                        children: <Widget>[
                          getAppBarUI(),
                          Container(
                            height: isShowbasicSearch
                                ? MediaQuery.of(context).size.height * 0.175
                                : MediaQuery.of(context).size.height * 0.475,
                            child: CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        getSearchBarUI(context, fieldProvder),
                                        searchMore1(fieldProvder)
                                        // getTimeDateUI(),
                                      ],
                                    );
                                  }, childCount: 1),
                                )
                              ],
                            ),
                          ),
                          getFilterBarUI(fieldProvder.numberAllFields),
                          _istLoading
                              ? Container()
                              : Expanded(
                                  flex: 1,
                                  child: NotificationListener<
                                      ScrollEndNotification>(
                                    onNotification:
                                        (ScrollEndNotification scrollInfo) {
                                      if (fieldProvder.fieldData.length < 2) {
                                        if (scrollInfo.depth == 0) {
                                          if (scrollInfo.metrics.pixels <
                                              scrollInfo
                                                  .metrics.maxScrollExtent) {
                                            check = 0;
                                          } else if (check == 0) {
                                            fetchMoreData(context);
                                            check = 1;
                                          }
                                        }
                                      } else {
                                        if (scrollInfo.depth == 1) {
                                          if (scrollInfo.metrics.pixels <
                                              scrollInfo
                                                  .metrics.maxScrollExtent) {
                                            check = 0;
                                          } else if (check == 0) {
                                            fetchMoreData(context);

                                            check = 1;
                                          }
                                        }
                                      }
                                      if (check == 1) {
                                        if (fieldProvder.fieldData.length ==
                                            fieldProvder.numberAllFields) {
                                          showToastMessage(
                                              "all-information".i18n());
                                        }
                                      }
                                      return true;
                                    },
                                    child: RefreshIndicator(
                                      onRefresh: _pullRefresh,
                                      child: NestedScrollView(
                                          controller: _scrollController,
                                          headerSliverBuilder:
                                              (BuildContext context,
                                                  bool innerBoxIsScrolled) {
                                            return <Widget>[
                                              SliverList(
                                                delegate:
                                                    SliverChildBuilderDelegate(
                                                        (BuildContext context,
                                                            int index) {
                                                  return Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 1,
                                                      )
                                                    ],
                                                  );
                                                }, childCount: 1),
                                              ),
                                            ];
                                          },
                                          body: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.white.withOpacity(1),
                                                  theme_color3.withOpacity(.4),
                                                  theme_color4.withOpacity(1),
                                                ],
                                              ),
                                            ),
                                            child: fieldProvder
                                                    .fieldData.isNotEmpty
                                                ? ListView.builder(
                                                    itemCount: fieldProvder
                                                        .fieldData.length,
                                                    padding: EdgeInsets.only(
                                                        top: sizeHeight(
                                                            8, context)),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemBuilder:
                                                        (context, index) {
                                                      User owner = fieldProvder
                                                          .fieldData[index]
                                                          .owner;
                                                      Field field = fieldProvder
                                                          .fieldData[index]
                                                          .field;
                                                      String location =
                                                          fieldProvder
                                                              .fieldData[index]
                                                              .location;
                                                      ImageData? image =
                                                          fieldProvder
                                                              .fieldData[index]
                                                              .image;
                                                      return fieldProvder
                                                                  .fieldData[
                                                                      index]
                                                                  .isLoading &&
                                                              fieldProvder
                                                                  .fieldData[
                                                                      index]
                                                                  .isLoading
                                                          ? mockShimmer(context)
                                                          : AnimatedListItem(
                                                              callback: () {
                                                                widget
                                                                    .mainTapController
                                                                    .animateTo(
                                                                        2);
                                                                PlantingProvider
                                                                    provider =
                                                                    Provider.of<
                                                                            PlantingProvider>(
                                                                        context,
                                                                        listen:
                                                                            false);
                                                                provider
                                                                    .resetFieldID();
                                                                provider.fieldID =
                                                                    field
                                                                        .fieldID;
                                                                provider.fieldName =
                                                                    field.name;
                                                              },
                                                              callback2: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => FieldMoreDetailScreen(
                                                                          field,
                                                                          owner,
                                                                          location,
                                                                          image,
                                                                          fieldProvder)),
                                                                );
                                                              },
                                                              field: field,
                                                              owner: owner,
                                                              location:
                                                                  location,
                                                              image: image,
                                                              itemName:
                                                                  "${field.name}",
                                                              itemID:
                                                                  "${field.code}",
                                                              city: "อ." +
                                                                  "${location.split(",").first}," +
                                                                  " จ." +
                                                                  "${location.split(",").last}",
                                                              district: "ต." +
                                                                  "${location.split(",").length < 2 ? "" : location.split(",")[1]}",
                                                              itemOwnerName:
                                                                  "${owner.title} ${owner.firstName}",
                                                              itemOwnerLastName:
                                                                  "${owner.lastName}",
                                                              date: ChangeDateTime(
                                                                  field
                                                                      .createDate),
                                                              fieldProviders:
                                                                  fieldProvder,
                                                            );
                                                    },
                                                  )
                                                : !fieldProvder.isSearch
                                                    ? Container()
                                                    : NoData()
                                                        .showNoData(context),
                                          )),
                                    ),
                                  ),
                                ),
                        ],
                      )),
                  // Note for BuildCreateNewField
                  fieldProvder.isLoading
                      ? checkCreateField
                          ? _buildCreateNewField(fieldProvder)
                          : Container()
                      : Container(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Future<bool> onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text("notification-label".i18n()),
        content: Text("exit-application".i18n()),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(false);
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
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
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

    return exitApp ?? false;
  }

  Widget shimmerLoading() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(1),
            theme_color3.withOpacity(.4),
            theme_color4.withOpacity(1),
          ],
        ),
      ),
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.only(top: sizeHeight(8, context)),
        itemBuilder: (context, index) {
          return mockShimmer(context);
        },
      ),
    );
  }
}

Shimmer mockShimmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[700]!,
    highlightColor: Colors.grey[500]!,
    child: Column(
      children: [
        Container(
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                        width: sizeWidth(600, context),
                        height: sizeHeight(50, context),
                        color: Colors.grey.withOpacity(0.4),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: sizeWidth(15, context),
                            top: sizeHeight(8, context),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.grass,
                                color: Colors.white,
                              ),
                              Text(
                                ' ' + 'name-field-label'.i18n(),
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
                                    primary: Colors.grey.withOpacity(
                                        0.4), // Change the button color here
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(sizeWidth(
                                          50,
                                          context)), // Set the border radius here
                                    ),
                                  ),
                                  onPressed: () {
                                    // Button press logic goes here
                                    //print('Button Pressed');
                                  },
                                  child: Icon(
                                    Icons.info_outline_rounded,
                                    color: Colors.white,
                                    size: sizeHeight(20, context),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    Container(
                      width: sizeWidth(500, context),
                      height: sizeHeight(0.5, context),
                      color: Colors.black.withOpacity(0.00000005),
                    ),
                    Container(
                      color: Colors.grey.withOpacity(0.4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: sizeWidth(16, context),
                                    top: sizeHeight(8, context),
                                    bottom: sizeHeight(8, context)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: sizeHeight(4, context))),
                                    Row(
                                      children: [
                                        Text(
                                          'field-code'.i18n() +
                                              " : " +
                                              'field-code'.i18n(),
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: TextStyle(
                                              fontSize: sizeHeight(16, context),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: sizeHeight(8, context))),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.locationDot,
                                          size: 14,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          'district'.i18n() +
                                              ', ' +
                                              'province'.i18n(),
                                          style: TextStyle(
                                            fontSize: sizeHeight(14, context),
                                          ),
                                        ),
                                        SizedBox(
                                          width: sizeWidth(4, context),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: sizeHeight(8, context))),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: theme_color2,
                                      size: sizeHeight(20, context),
                                    ),
                                    Text(
                                      " " + "owner".i18n(),
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
                                    top: sizeHeight(14, context),
                                    right: sizeWidth(8, context)),
                                child: Text(
                                  ' ',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: sizeHeight(14, context),
                                  ),
                                ),
                              ),
                            ],
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
        SizedBox(height: sizeHeight(23.5, context)),
      ],
    ),
  );
}

Widget _buildMultiSearchBar(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.7,
    height: MediaQuery.of(context).size.height * 0.07,
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'search'.i18n(),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sizeHeight(25, context)),
          borderSide: const BorderSide(),
        ),
      ),
    ),
  );
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
