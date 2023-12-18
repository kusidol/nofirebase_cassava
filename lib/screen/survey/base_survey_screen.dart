import 'dart:convert';
import 'dart:developer';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/survey_target_point.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/field_dropdown_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/login/app_styles.dart';
import 'package:mun_bot/screen/survey/survey_target/create_survey_target.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_newui.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/widget/card_list_view.dart';
import 'package:mun_bot/screen/survey/survey_more_detail.dart';
import 'package:mun_bot/util/ui/calendar_popup_view.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/change_date_time.dart';
//import 'package:mun_bot/screen/size_config.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';

import 'package:mun_bot/screen/survey/create_survey_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:shimmer/shimmer.dart';

class SurveyTable extends StatefulWidget {
  TabController? mainTapController;
  SurveyProvider surveyProvider;
  //SurveyTable(this.mainTapController,this.surveyProvider);

  SurveyTable(this.mainTapController,this.surveyProvider);
 
  @override
  State<StatefulWidget> createState() => _SurveyTable();
}

class _SurveyTable extends State<SurveyTable>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;
  //AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _inerscrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  bool _isLoading = true;
  bool _isLoadMore = false;

  int check = 0;

  //------------- for search
  bool isSearching = false;
  TextEditingController codeNameController = TextEditingController();
  TextEditingController ownerController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cultivationController = TextEditingController();
  TextEditingController startDatePlantingController = TextEditingController();
  TextEditingController endDatePlantingController = TextEditingController();
  TextEditingController startDateSurveyController = TextEditingController();
  TextEditingController endDateSurveyController = TextEditingController();
  String shortCutValue = '';
  String addressValue = '';
  String fieldNameValue = '';
  String ownerNameValue = '';
  String plantingNameValue = '';
  int startDatePlantingSelect = 0;
  int endDatePlantingSelect = 0;
  int startDateSurveySelect = 0;
  int endDateSurveySelect = 0;

   bool? IsCheckTarget;
  DateTime _startDatePlanting = DateTime.now();
  DateTime _endDatePlanting = DateTime.now().add(const Duration(days: 5));
  DateTime _startDateSurvey = DateTime.now();
  DateTime _endDateSurvey = DateTime.now().add(const Duration(days: 5));
  TabController? _mainTapController;
  bool isShowbasicSearch = true;
  GlobalKey expansionTileKey = GlobalKey();

 void showToastMessage(String msg) {
    FlutterToastr.show(msg, context,
        duration: 2,
        position: FlutterToastr.bottom,
        backgroundColor: theme_color,
        textStyle: TextStyle(fontSize: 15, color: Colors.black));
  }
  @override
  void dispose() {

    //animationController?.dispose();
    codeNameController.dispose();
    ownerController.dispose();
    locationController.dispose();
    cultivationController.dispose();
    widget.surveyProvider.isSearch=false;
    widget.surveyProvider.resetPlantingID();
    widget.surveyProvider.reset();
    super.dispose();
  }

  @override
  void initState() {

   //widget.surveyProvider.reset();
    widget.surveyProvider.reset();
    _scrollController.addListener(_scrollListener);
   /* animationController = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this
    );*/


    asyncFunction();
    super.initState();
   // animation = AnimationController(vsync: this, duration: Duration(seconds: 3),);
   // _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.1).animate(animation);
   
  }


  void asyncFunction() async {

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    SurveyProvider surveyProvider;

    surveyProvider =
       widget.surveyProvider;

    if(!surveyProvider.isSearch /*&& !surveyProvider.isFetch()*/){
      ////print("plantingID =  ${surveyProvider.plantingId}");
      if(!mounted)
        return ;
      //surveyProvider.setFetch(true);
      if(surveyProvider.plantingId != -1) {

        surveyProvider.fetchDataFromPlanting();
      } else {

          surveyProvider.fetchData();
      }

    }



    if (mounted) {
      setState(() {
        _isLoading = false;

      });
    }
  }

  void fetchMoreData() async {
    if (mounted) {
      setState(() {
        _isLoadMore = true;
      });
    }

    SurveyProvider surveyProvider =  widget.surveyProvider;
      if (!isSearching && !widget.surveyProvider.isSearch /*&& !surveyProvider.isFetch()*/ ) {

       // surveyProvider.setFetch(true);

        if(surveyProvider.plantingId != -1) {

        surveyProvider.fetchDataFromPlanting();

        } else {

            surveyProvider.fetchData();
      }

    }

    if (mounted) {
      setState(() {
        _isLoadMore = false;
      });
    }

  }

  Future<void> _pullRefresh() async {}

  void _scrollListener() {
    ////print("scroll listener");

    //if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      //  fetchMoreData();

      // //print("call");
    } else {
      // //print("don't call");
    }
  }




  alert(Survey survey) =>
      showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
           'alert'.i18n(),
          ),
          content: Column(
            children: [
              Text(
                'survey-point-delete'.i18n(),
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
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
                  Navigator.of(context).pop();
              Navigator.push(
               context,
                  MaterialPageRoute(
                      maintainState: false,
                      builder: (context) =>
                          new BaseSurveyDetailInfo(survey, false))).then((value) {
            if (value == true) {
              asyncFunction();
             
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurveyTable(_mainTapController!,widget.surveyProvider)));
            }
          });
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
                       'survey-label'.i18n(),
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
                color: theme_color2,
                borderRadius: BorderRadius.all(
                  Radius.circular(sizeHeight(38, context)),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      offset: const Offset(0, 2),
                      blurRadius: 8.0),
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

  Widget getSearchBarUI(context, SurveyProvider surveyProvider) {
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
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
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
                              shortCutValue = txt;
                            });
                          },
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.023,
                          ),
                          cursorColor:
                              theme_color2,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'searchPlanting'.i18n() + "...",
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
                    color: theme_color2,
                    borderRadius: BorderRadius.all(
                      Radius.circular(sizeHeight(38, context)),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 8.0),
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
                        surveyProvider.reset();
                        if (shortCutValue == null || shortCutValue == "") {
                          ////print("-----------------");
                        //  isSearching = false;

                          asyncFunction();
                        }
                        else {
                         // surveyProvider.reset();
                          _handleSearchByKeyButton(surveyProvider);

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

  void _handleSearchByKeyButton(SurveyProvider provider) async {

  /* if(provider.isFetch()){
     return ;
   }*/

    Map<String, dynamic> jsonData = {
      "key": shortCutValue,
    };

    if(provider.plantingId != -1){
      jsonData['plantingId'] = provider.plantingId;
    }

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    ////print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    provider.searchByKey(jsonData);
    isSearching = true;
  }

  Widget ExpantionSearch() {
    return ExpansionTile(
        textColor: Colors.black,
        iconColor: theme_color2,
        title: Text('ค้นหาเพิ่มเติม',
            style: TextStyle(
              fontSize: sizeHeight(18, context),
            )),
        onExpansionChanged: (bool isExpanded) {
          if (!isExpanded) {
            //print('Hello World');
            // dropdownfield.resetItemsAfterSearch();
          } else {
            //print('Save Value');
          }
        },
        leading: Icon(Icons.perm_contact_calendar_outlined),
        // subtitle: Text(selectedAddress +
        //     " " +
        //     selectedFieldName +
        //     " " +
        //     selectedOwnerName),
        children: [
          Container(
            color: Colors.tealAccent[50],
            padding:  EdgeInsets.all(sizeHeight(20, context)),
            child: Column(
              children: [
                TextFormField(
                  // controller: codeNameController,
                  decoration: InputDecoration(
                    labelText: 'ที่อยู่แปลง',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      addressValue = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: ownerController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อแปลง',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fieldNameValue = value;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  // controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'เจ้าของแปลง',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      ownerNameValue = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ]);
  }
Widget getFilterBarUI(int numItemFounded) {
      SurveyProvider surveyProvider = widget.surveyProvider;
    String plantingName = surveyProvider.plantingName;
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
                               plantingName == "" ?
                               'surveys-founded-label'.i18n()+' ${numItemFounded} ' + 'item-label'.i18n(): 'surveys-founded-id-label'.i18n() + " ${plantingName} " + 'surveys-founded-label'.i18n() + ' ${numItemFounded} ' + 'item-label'.i18n(),
                               expandText:  plantingName == "" ?
                               'surveys-founded-label'.i18n() + ' ${numItemFounded}' : 'surveys-founded-id-label'.i18n() + ' (${numItemFounded})',
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
  

  Widget _createSurveybutton(SurveyProvider surveyProvider) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.01,
      right: MediaQuery.of(context).size.width * 0.01,
      child: GestureDetector(
          child: Container(
        decoration: BoxDecoration(
          color: theme_color2.withOpacity(0.75),
          borderRadius: BorderRadius.all(
            Radius.circular(MediaQuery.of(context).size.height * 0.048),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                offset: Offset(0, 2),
                blurRadius: MediaQuery.of(context).size.height * 0.0102),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(MediaQuery.of(context).size.height * 0.0409),
            ),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       maintainState: false,
              //       builder: (context) => new NewSurveyScreen(null)),
              // );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => Provider(
                    create: (context) => Dropdownfield(),
                    builder: (context, child) => NewSurveyScreen(null, surveyProvider),
                  ),
                ),
              );
            },
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.0204),
              child: Icon(FontAwesomeIcons.add,
                  size: MediaQuery.of(context).size.height * 0.0256,
                  color: HotelAppTheme.buildLightTheme().backgroundColor),
            ),
          ),
        ),
      )),
    );
  }

  //bool _isExpanded = false ;
  Widget searchMore1(SurveyProvider provider) {
    var _startDateUserNameColor = Colors.black;
    String _startDateTimeText = " Start Date";
    // for search
    void _startDateTFToggle(e) {
      setState(() {

        //_isExpanded = !_isExpanded ;
        //size = _isExpanded ? 0.70 : 0.35 ;
        //_rqVisible = !_rqVisible;
        _startDateTimeText = "Start Date";
        _startDateUserNameColor = Colors.black;
      });
    }

    TextField startDatePlanting = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newStartDate = await showDatePicker(
          context: context,
          initialDate: _startDatePlanting,
          firstDate: DateTime(1900),
          lastDate: _endDatePlanting,
        );
        if (newStartDate == null) return;
        setState(() {
          _startDatePlanting = newStartDate;
        });
        startDatePlantingController.text = _startDatePlanting.toIso8601String();
        startDatePlantingSelect = _startDatePlanting.millisecondsSinceEpoch;
        startDatePlantingController.text =
            DateFormat("dd-MM-yyyy").format(_startDatePlanting);
      },
      controller: startDatePlantingController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white),
        
        hintText: 'pick-start-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField endDatePlanting = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newEndDate = await showDatePicker(
          context: context,
          initialDate: _endDatePlanting,
          firstDate: _startDatePlanting,
          lastDate: DateTime(2100),
        );
        if (newEndDate == null) return;
        setState(() {
          _endDatePlanting = newEndDate;
        });
        endDatePlantingController.text = _endDatePlanting.toIso8601String();
        endDatePlantingSelect = _endDatePlanting.millisecondsSinceEpoch;
        endDatePlantingController.text =
            DateFormat("dd-MM-yyyy").format(_endDatePlanting);
      },
      controller: endDatePlantingController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(
          Icons.calendar_today_rounded,
          color: Colors.white,
        ),
        hintText: 'pick-end-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField startDateSurvey = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newStartDate = await showDatePicker(
          context: context,
          initialDate: _startDateSurvey,
          firstDate: DateTime(1900),
          lastDate: _endDateSurvey,
        );
        if (newStartDate == null) return;
        setState(() {
          _startDateSurvey = newStartDate;
        });
        startDateSurveyController.text = _startDateSurvey.toIso8601String();
        startDateSurveySelect = _startDateSurvey.millisecondsSinceEpoch;
        startDateSurveyController.text =
            DateFormat("dd-MM-yyyy").format(_startDateSurvey);
      },
      controller: startDateSurveyController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white),
        hintText: 'pick-start-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

    TextField endDateSurvey = TextField(
      onTap: () async {
        DateTime date = DateTime(1900);
        FocusScope.of(context).requestFocus(new FocusNode());
        DateTime? newEndDate = await showDatePicker(
          context: context,
          initialDate: _endDateSurvey
          firstDate: _startDateSurvey,
          lastDate: DateTime(2100),
        );
        if (newEndDate == null) return;
        setState(() {
          _endDateSurvey = newEndDate;
        });
        endDateSurveyController.text = _endDateSurvey.toIso8601String();
        endDateSurveySelect = _endDateSurvey.millisecondsSinceEpoch;
        endDateSurveyController.text =
            DateFormat("dd-MM-yyyy").format(_endDateSurvey);
      },
      controller: endDateSurveyController,
      onChanged: (e) => _startDateTFToggle(e),
      keyboardType: TextInputType.datetime,
      style:
          TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: sizeWidth(14, context)),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top: sizeHeight(14, context)),
        prefixIcon: Icon(Icons.calendar_today_rounded, color: Colors.white),
        hintText: 'pick-end-date'.i18n(),
        hintStyle: kHintTextStyle,
      ),
    );

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
            padding:  EdgeInsets.symmetric(horizontal: sizeHeight(16, context)),
            child: Column(
              children: [
                Container(
                  color: Colors.tealAccent[50],
                  padding:  EdgeInsets.all(sizeHeight(20, context)),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: codeNameController,
                        decoration: InputDecoration(
                          labelText: 'field-address'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
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
                          labelText: 'name-field-label'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
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
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            ownerNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      TextFormField(
                        controller: cultivationController,
                        decoration: InputDecoration(
                          labelText: 'name-planting-label'.i18n(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(sizeHeight(10, context)),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            plantingNameValue = value;
                          });
                        },
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "plant-start-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: startDatePlanting,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: sizeWidth(8, context))),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                   "plant-end-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: endDatePlanting,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: sizeHeight(16, context)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                   "survey-start-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: startDateSurvey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: sizeWidth(8, context))),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "survey-end-date".i18n(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: sizeHeight(15, context)),
                                ),
                                SizedBox(height: sizeHeight(20, context)),
                                Container(
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: kBoxDecorationStyle,
                                    height: sizeHeight(60, context),
                                    child: endDateSurvey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(
                      top: sizeHeight(2, context),
                      left: sizeWidth(20, context),
                      right: sizeWidth(20, context),
                      bottom: sizeHeight(20, context)),
                  height: 50.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(sizeHeight(18, context)),
                      //side: BorderSide(color: Color.fromRGBO(0, 160, 227, 1))
                    ),
                    onPressed: () {
                      provider.reset();
                       if (addressValue == "" && fieldNameValue == "" && ownerNameValue == "" && plantingNameValue == "" && startDateSurveySelect == 0 && endDateSurveySelect == 0 && startDatePlantingSelect == 0 && endDatePlantingSelect == 0) {
                        asyncFunction();
                      }
                      else {
                        shortCutValue="";
                        _handleSearchButton(provider);

                      }
                    },
                    padding: EdgeInsets.all(sizeHeight(10, context)),
                    color: theme_color2,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "search".i18n(),
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

  void _handleSearchButton(SurveyProvider provider) async {

  /* if(provider.isFetch()){
     return ;
   }*/

    //call Service
    Map<String, dynamic> jsonData = {
      "address": addressValue,
      "endDate": endDatePlantingSelect,
      "fieldName": fieldNameValue,
      "ownerName": ownerNameValue,
      "plantingName": plantingNameValue,
      "startDate": startDatePlantingSelect,
      "surveyEndDate": endDateSurveySelect,
      "surveyStartDate": startDateSurveySelect,
    };

    jsonData.removeWhere(
        (key, value) => value == null || value == '' || value == 0);

    String jsonString = jsonEncode(jsonData);
    ////print(jsonString);

    setState(() {
      isShowbasicSearch = true;
    });
    ////print("-------------------------");
    provider.search(jsonData);
    isSearching = true;
  }
 // AnimationController  animation  ;
 // Animation<double> _fadeInFadeOut;
  @override
  Widget build(BuildContext context) {
        
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child:
       Consumer<SurveyProvider>(
         builder: (context, surveyProvider, index) {
         //  List<Survey> surveyList = surveyProvider.surveys;
        //List<Planting> plantings = surveyProvider.plantings;
          /*  List<String> list_plantingName = surveyProvider.list_plantingName;
            List<String> list_fieldName = surveyProvider.list_fieldName;
            List<String> list_substrict = surveyProvider.list_substrict;
            List<String> list_district = surveyProvider.list_district;
            List<String> list_province = surveyProvider.list_province;
            List<String> list_title = surveyProvider.list_title;
            List<String> list_firstName = surveyProvider.list_firstName;
            List<String> list_lastName = surveyProvider.list_lastName;
            List<bool>list_check_target=surveyProvider.list_check_target;*/
           return WillPopScope(
                onWillPop: () => onBackButtonPressed(context),
                  child: Scaffold(
                  //  resizeToAvoidBottomInset: false,
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
                                  height:  isShowbasicSearch ? MediaQuery.of(context).size.height *0.175: MediaQuery.of(context).size.height * 0.475,
                                  child:

                                  CustomScrollView(

                                    slivers: [
                                      SliverList(

                                        delegate:
                                        SliverChildBuilderDelegate(

                                                (BuildContext context,
                                                int index) {
                                              return Column(
                                                children: <Widget>[
                                                  getSearchBarUI(context, surveyProvider),
                                                  searchMore1(surveyProvider),
                                                  // getTimeDateUI(),

                                                ],
                                              );
                                            }, childCount: 1),
                                      )
                                    ],
                                  )
                                  ,
                                ),
                                getFilterBarUI(surveyProvider.numberAllSurveys),


                                _isLoading
                                    ? Container()
                                    : Expanded(
                                        flex: 1,
                                       child: NotificationListener<
                                           ScrollEndNotification>(
                                           onNotification:
                                               (ScrollEndNotification scrollInfo) {
                                             if (surveyProvider.surveyData.isNotEmpty) {
                                               if (scrollInfo.depth == 0) {
                                                 if (scrollInfo.metrics.pixels <
                                                     scrollInfo
                                                         .metrics.maxScrollExtent) {
                                                   check = 0;
                                                 } else if (check == 0) {

                                                   fetchMoreData();

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
                                                   fetchMoreData();

                                                   check = 1;
                                                 }
                                               }
                                             }
                                             if (check == 1) {
                                               if (surveyProvider.surveyData.length ==
                                                   surveyProvider.numberAllSurveys) {
                                                 showToastMessage(
                                                     "ข้อมูลแสดงครบทั้งหมดเป็นที่เรียบร้อยแล้ว");
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
                                                                SizedBox(height: 1,)
                                                               // getTimeDateUI(),

                                                             ],
                                                           );
                                                         }, childCount: 1),
                                                   )
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
                                                 child: surveyProvider.surveyData.isNotEmpty ? ListView.builder(
                                                   padding: EdgeInsets.only(
                                                       top: sizeHeight(8, context)),
                                                   //physics: NeverScrollableScrollPhysics(),
                                                   shrinkWrap: false,
                                                   controller: _inerscrollController,
                                                   itemCount: surveyProvider.surveyData.length,

                                                   scrollDirection:
                                                   Axis.vertical,
                                                   itemBuilder:
                                                       (BuildContext context,
                                                       int index) {

                                                     ////print(index);
                                                     // //print("surveyList length : ${surveyList.length} index :${index}");
                                                     //IsCheckTarget=surveyProvider.surveyData[index].checkTarget;
                                                     //Planting planting = surveyProvider.surveyData[index].planting ;
                                                     //     plantings[index];
                                                     // Adding new
                                                     String plantingName =surveyProvider.surveyData[index].plantingName ;
                                                     /* list_plantingName[
                                                                  index];*/
                                                     //String fieldName = surveyProvider.surveyData[index].fieldName ;
                                                     String substrict = surveyProvider.surveyData[index].substrict ;
                                                     String district = surveyProvider.surveyData[index].district ;
                                                     String province = surveyProvider.surveyData[index].province ;
                                                     String title = surveyProvider.surveyData[index].title ;

                                                     String firstName = surveyProvider.surveyData[index].firstName ;

                                                     String lastName = surveyProvider.surveyData[index].lastName ;


                                                     //final int count =  surveyProvider.surveyData.length > 10  ? 10 : surveyProvider.surveyData.length;
                                                     /*final Animation <double> animation = Tween<double>(begin: 0.0,end: 1.0).animate(CurvedAnimation(parent:animationController!, curve: Interval( (1 / count) *  index,   1.0, curve: Curves
                                                                          .fastOutSlowIn)));
                                                          animationController ?.forward();*/


                                                     return surveyProvider.surveyData[index].isLoading &&  surveyProvider.surveyData[index].isLoading? mockShimmer():

                                                     AnimatedListItem( callback: () {
                                                       if (surveyProvider.surveyData[index].checkTarget == false) {
                                                         //alert(surveyList[index]);
                                                       } else {
                                                         Navigator.push(
                                                           context,
                                                           MaterialPageRoute(
                                                             builder: (context) =>
                                                                 BaseSurveyPoint(surveyProvider.surveyData[index].survey, surveyProvider.surveyData[index].code),
                                                           ),
                                                         );
                                                       }
                                                     },
                                                       callback2: () {

                                                         Navigator.push(
                                                             context,
                                                             MaterialPageRoute(
                                                                 maintainState: false,
                                                                 builder: (context) =>
                                                                     SurveyMoreDetailScreen( surveyProvider.surveyData[index].survey,
                                                                         surveyProvider.surveyData[index].code, surveyProvider))).then((value) {
                                                           if (value == true) {
                                                             asyncFunction();
                                                             //print("value${value}");

                                                           }
                                                         });

                                                       },

                                                       itemName: plantingName,
                                                       itemID:
                                                       "${surveyProvider.surveyData[index].code}",
                                                       city: "อ." +
                                                           "${district}," +
                                                           " จ." +
                                                           "${province}",
                                                       district:
                                                       "ต." + "${substrict}",
                                                       itemOwnerName:
                                                       "${title} ${firstName}",
                                                       itemOwnerLastName:
                                                       "${lastName}",
                                                       date: ChangeDateTime(surveyProvider.surveyData[index].survey.date),);
                                                     // FadeTransition(opacity: animation)
                                                     /*CardItemWithOutImage(
                                                            callback: () {
                                                             if (surveyProvider.surveyData[index].checkTarget == false) {
                                                              //alert(surveyList[index]);
                                                                  } else {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            BaseSurveyPoint(surveyProvider.surveyData[index].survey, surveyProvider.surveyData[index].code),
                                                                      ),
                                                                    );
                                                                  }
                                                            },
                                                            callback2: () {

                                                                 Navigator.push(
                                                                  context,
                                                                      MaterialPageRoute(
                                                                          maintainState: false,
                                                                          builder: (context) =>
                                                                              SurveyMoreDetailScreen( surveyProvider.surveyData[index].survey,
                                                                                  surveyProvider.surveyData[index].code, surveyProvider))).then((value) {
                                                                    if (value == true) {
                                                                      asyncFunction();
                                                                      ////print("value${value}");

                                                                    }
                                                                  });

                                                              },

                                                            itemName: plantingName,
                                                            itemID:
                                                                "${surveyProvider.surveyData[index].code}",
                                                            city: "อ." +
                                                                "${district}," +
                                                                " จ." +
                                                                "${province}",
                                                            district:
                                                                "ต." + "${substrict}",
                                                            itemOwnerName:
                                                                "${title} ${firstName}",
                                                            itemOwnerLastName:
                                                                "${lastName}",
                                                            animation: animation,
                                                            animationController:
                                                                animationController!,
                                                            date: ChangeDateTime(surveyProvider.surveyData[index].survey.date),
                                                          );*/
                                                   },
                                                 ):   !surveyProvider.isSearch ? Container() : NoData().showNoData(context),
                                               )
                                               ,
                                             ),
                                           ))
                                ) ,

                              ],
                            
                          ) ,
                        ),
                         surveyProvider.isHavePlanting && surveyProvider.isLoading ? _createSurveybutton(surveyProvider) : Container(),
                      ],
                    ),
                  ),
                );
         }
       ),
         
      ),
    );
  }

  Widget _buildMultiSearchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.07,
      //height:SizeConfig.screenheight*0.05,
      child: new TextFormField(
        decoration: new InputDecoration(
          labelText: 'search'.i18n(),
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
          //fillColor: Colors.green
        ),
      ),
    );
  }

  Shimmer mockShimmer() {
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
                                  Icons.date_range,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' วันที่',
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
                                        borderRadius: BorderRadius.circular(
                                            sizeHeight(50, context)), // Set the border radius here
                                      ),
                                    ),
                                    onPressed: () {
                                      // Button press logic goes here
                                      //print('Button Pressed');
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
                                  padding:  EdgeInsets.only(
                                      left: sizeWidth(16, context), top: sizeHeight(8, context), bottom: sizeHeight(8, context)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: sizeHeight(4, context))),
                                      Row(
                                        children: [
                                          Text(
                                            ' การเพาะปลูก : ชื่อการเพาะปลูก',
                                            style: TextStyle(
                                              fontSize: sizeHeight(14, context),
                                            ),
                                          ),
                                          Text(
                                            '',
                                            style: TextStyle(
                                                fontSize:
                                                    sizeHeight(16, context),
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
                                            'อำเภอ, จังหวัด',
                                            style: TextStyle(
                                              fontSize: sizeHeight(14, context),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
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

  /*Widget shimmerLoading() {
    return Container(
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
      child: ListView.builder(
        itemCount: 5,
        padding: EdgeInsets.only(top: sizeHeight(8, context)),
        itemBuilder: (context, index) {
          return mockShimmer();
        },
      ),
    );
  }*/

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
            child: Text('no'.i18n(), style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
            ),),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop(true);
              SystemNavigator.pop();
            },
            child: Text('yes'.i18n(), style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),),
          ),
        ],
      ),
    );

    return exitApp ?? false;
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
