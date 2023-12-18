import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/util/change_date_time.dart';

import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/screen/app_styles.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_newui.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/screen/widget/card_list_view.dart';
import 'package:mun_bot/screen/survey/survey_target/create_survey_target.dart';
import 'package:mun_bot/util/ui/calendar_popup_view.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';

import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_plant.dart';

import 'package:mun_bot/screen/survey/create_survey_screen.dart';
import 'package:intl/intl.dart';

import 'card_survey_more_detail.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class SurveyMoreDetailScreen extends StatefulWidget {
  final Survey surveys;
  final String plantingCode;
  SurveyProvider surveyProvider;

  SurveyMoreDetailScreen(this.surveys, this.plantingCode, this.surveyProvider);

  @override
  State<StatefulWidget> createState() => _SurveyMoreDetailScreen();
}

class _SurveyMoreDetailScreen extends State<SurveyMoreDetailScreen>
    with SingleTickerProviderStateMixin {
  bool isVisible = true;
  String storyImage = 'assets/images/cassava_field.jpg';

  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _inerscrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  List<Survey> surveyList = [];
  bool _istLoading = true;
  bool _isLoadMore = false;
  int page = 1;
  int check = 0;
  SampleItem? selectedMenu;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    //print(SizeConfig.screenHeight);
    super.initState();
    onfirst();
  }

  @override
  void dispose() {
    animationController?.dispose();

    super.dispose();
  }

  onfirst() async {
    if (mounted) {
      setState(() {
        _istLoading = true;
      });
    }

    List<Survey> listData = [];
    SurveyService surveyService = SurveyService();
    String? token = tokenFromLogin?.token;
    listData = await surveyService.getSurvey(token.toString(), page, 5);
    page++;

    if (mounted) {
      setState(() {
        surveyList = listData;
        _istLoading = false;
      });
    }
  }

  fetchMoreData() async {
    if (mounted) {
      setState(() {
        _isLoadMore = true;
      });
    }

    List<Survey> listData = [];
    SurveyService surveyService = SurveyService();
    String? token = tokenFromLogin?.token;
    listData = await surveyService.getSurvey(token.toString(), page, 5);
    List<Survey> mixNewOldSurvey = surveyList;
    for (Survey e in listData) {
      mixNewOldSurvey.add(e);
    }

    if (listData.isEmpty) {
      page++;
    }

    if (mounted) {
      setState(() {
        surveyList = mixNewOldSurvey;
        _isLoadMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
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
                              theme_color3.withOpacity(.2),
                              theme_color3.withOpacity(.4),
                              theme_color4.withOpacity(1),
                            ],
                          ),
                        ),
                        width: SizeConfig.screenWidth,
                        height: MediaQuery.of(context).size.height * 0.88,
                        child: CardSurveyMoreDetail(widget.surveys,
                            widget.plantingCode, widget.surveyProvider),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDeletion() async {
    SurveyService surveyervice = SurveyService();
    String? token = tokenFromLogin?.token;
    ////print("widget.surveyProvider.surveys : ${widget.surveyProvider.surveys}");
    //print("widget.survey : ${widget.surveys}");
    bool isDeleted = await widget.surveyProvider.deleteSurvey(widget.surveys);
    if (isDeleted) {
      //alert
      //print("delete success");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {}
  }

  _deleteConfirmation(context) => showCupertinoDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text("confirm-delete".i18n()),
          content: Column(
            children: [
              Text(
                'Do-you-want-to-delete-this-survey'.i18n(),
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
                _handleDeletion();
                Navigator.of(context).pop();
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
                    Radius.circular(sizeHeight(32, context)),
                  ),
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(sizeWidth(8, context)),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'survey-more-detail-label'.i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
                  ),
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
                        Radius.circular(sizeHeight(32, context)),
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: new Icon(
                                    Icons.edit,
                                    color: HotelAppTheme.buildLightTheme()
                                        .shadowColor,
                                  ),
                                  title: new Text(
                                    "Edit-general".i18n(),
                                    style: TextStyle(
                                      fontSize: 17,
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
                                              new NewSurveyScreen(
                                                  widget.surveys,
                                                  widget.surveyProvider)),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(
                                    Icons.edit_location_alt_rounded,
                                    color: HotelAppTheme.buildLightTheme()
                                        .shadowColor,
                                  ),
                                  title: new Text(
                                    "Edit-survey".i18n(),
                                    style: TextStyle(
                                      fontSize: 17,
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
                                              new BaseSurveyDetailInfo(
                                                  widget.surveys, false)),
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(
                                    Icons.delete,
                                    color: HotelAppTheme.buildLightTheme()
                                        .shadowColor,
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
                                    _deleteConfirmation(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(sizeWidth(8, context)),
                        child: Icon(Icons.edit),
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
