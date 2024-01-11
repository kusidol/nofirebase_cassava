import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mun_bot/controller/calendar_service.dart';
import 'package:mun_bot/controller/field_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/controller/user_service.dart';
import 'package:mun_bot/entities/field.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/entities/user.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/main.dart';
import 'package:mun_bot/providers/planting_provider.dart';
import 'package:mun_bot/providers/survey_provider.dart';
import 'package:mun_bot/screen/cultivation/planting_more_detail.dart';
import 'package:mun_bot/screen/login/login_screen.dart';
import 'package:mun_bot/screen/survey/survey_more_detail.dart';
import 'package:mun_bot/screen/survey/survey_target/survey_target_point/stp_point_newui.dart';
import 'package:mun_bot/screen/widget/card_list_view.dart';
import 'package:mun_bot/screen/widget/no_data.dart';
import 'package:mun_bot/util/change_date_time.dart';
import 'package:mun_bot/util/const.dart';
import 'package:mun_bot/util/ui/multi_search_flutter.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:localization/localization.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:provider/provider.dart';

import '../../util/size_config.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

class BaseHomeScreen extends StatefulWidget {
  PlantingProvider plantingProvider;
  SurveyProvider surveyProvider;

  BaseHomeScreen(this.plantingProvider, this.surveyProvider);

  @override
  State<StatefulWidget> createState() => _BaseHomeScreen();
}

class _BaseHomeScreen extends State<BaseHomeScreen>
    with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  int _selectedView = 1;

  late final ValueNotifier<List<Event>> _selectedEvents;

  bool _istLoading = true;
  bool _isLoadMore = false;

  //New Calendars
  List<Planting> plantings_new = [];
  List<String> list_fieldName_planting = [];
  List<String> list_substrict_planting = [];
  List<String> list_district_planting = [];
  List<String> list_province_planting = [];
  List<String> list_title_planting = [];
  List<String> list_firstName_planting = [];
  List<String> list_lastName_planting = [];

  List<Survey> surveys_new = [];
  List<String> list_plantingName_survey = [];
  List<String> list_plantingCode_survey = [];
  List<int> list_date_survey = [];
  List<String> list_substrict_survey = [];
  List<String> list_district_survey = [];
  List<String> list_province_survey = [];
  List<String> list_title_survey = [];
  List<String> list_firstName_survey = [];
  List<String> list_lastName_survey = [];

  List<Object> allItem_new = [];
  List<String> allItem_fieldName_planting = [];
  List<String> allItem_plantingName_survey = [];
  List<String> allItem_plantingCode_survey = [];
  List<int> allItem_date_survey = [];
  List<String> allItem_substrict = [];
  List<String> allItem_district = [];
  List<String> allItem_province = [];
  List<String> allItem_title = [];
  List<String> allItem_firstName = [];
  List<String> allItem_lastName = [];
  List<Planting> allItem_plantings = [];
  List<Survey> allItem_surveys = [];

  int page = 1;
  late String? menuText = "ดูทั้งหมด";
  AnimationController? animationController;
  TabController? _tabController;
  int check = 0;
  final ScrollController _scrollController = ScrollController();
  Future<void> _pullRefresh() async {
    //print("123");
  }

  @override
  void initState() {
    calendarFunction(_focusedDay);
    for (int i = 3; i > 0; i--) {
      Duration months = Duration(days: 30 * i);
      DateTime newDateTime = _focusedDay.subtract(months);
      calendarFunction(newDateTime);
    }
    for (int i = 1; i < 13; i++) {
      Duration months = Duration(days: 30 * i);
      DateTime newDateTime = _focusedDay.add(months);
      calendarFunction(newDateTime);
    }
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    super.initState();
    onfirst();

    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

//Checking Object is a Planting or Survey
  checkingObject(Object item) {
    String covertItem = jsonEncode(item);
    Map<String, dynamic> temp = jsonDecode(covertItem);
    int result = 0;
    if (item is Planting) {
      Planting data = Planting.fromJson(temp);
      result = data.createDate;
    } else {
      Survey data = Survey.fromJson(temp);
      result = data.createDate;
    }
    return result;
  }

  sortAllList(List<Object> list) {
    List<Object> result = [];
    int first_date = 0;
    int last_date = 0;
    bool swapped = false;
    for (int i = 0; i < list.length - 1; i++) {
      swapped = false;
      for (int j = 0; j < list.length - i - 1; j++) {
        if (checkingObject(list[j]) > checkingObject(list[j + 1])) {
          Object temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
          swapped = true;
        }
      }

      if (swapped == false) {
        break;
      }
    }
    result = list;
    return result;
  }

  loadNewDataBySelectDate(int date) async {
    if (mounted) {
      setState(() {
        _istLoading = true;
      });
    }
    // NEW Calendar Reset Value
    // Planting
    plantings_new = [];
    list_fieldName_planting = [];
    list_substrict_planting = [];
    list_district_planting = [];
    list_province_planting = [];
    list_title_planting = [];
    list_firstName_planting = [];
    list_lastName_planting = [];
    //Survey
    surveys_new = [];
    list_plantingName_survey = [];
    list_plantingCode_survey = [];
    list_date_survey = [];
    list_substrict_survey = [];
    list_district_survey = [];
    list_province_survey = [];
    list_title_survey = [];
    list_firstName_survey = [];
    list_lastName_survey = [];
    //AllItem
    allItem_new = [];
    allItem_fieldName_planting = [];
    allItem_plantingName_survey = [];
    allItem_plantingCode_survey = [];
    allItem_substrict = [];
    allItem_district = [];
    allItem_province = [];
    allItem_title = [];
    allItem_firstName = [];
    allItem_lastName = [];
    allItem_date_survey = [];
    allItem_plantings = [];
    allItem_surveys = [];

    String? token = tokenFromLogin?.token;

    List<Object> objects = [];
    CalendarService calendarService = CalendarService();
    objects =
        await calendarService.getPlantingsAndSurveys(token.toString(), date);
    List<Planting> planting__List = [];
    List<Survey> survey__List = [];

    planting__List =
        await calendarService.getPlantingsByCreateDate(token.toString(), date);
    survey__List =
        await calendarService.getSurveysByCreateDate(token.toString(), date);

    for (int i = 0; i < planting__List.length; i++) {
      Planting plant = planting__List[i];
      plantings_new.add(plant);
    }
    for (int i = 0; i < survey__List.length; i++) {
      Survey sur = survey__List[i];
      list_date_survey.add(sur.date);
      surveys_new.add(sur);
    }

    for (int i = 0; i < objects.length; i++) {
      String convertObject = jsonEncode(objects[i]);
      Map<String, dynamic> item = jsonDecode(convertObject);
      String type = item["type"];
      //It's Planting
      if (type == "planting") {
        String fieldName = item["fieldName"];
        String name = item["name"];
        String substrict = item["substrict"];
        String district = item["district"];
        String province = item["province"];
        String title = item["title"];
        String firstName = item["firstName"];
        String lastName = item["lastName"];
        for (int y = 0; y < planting__List.length; y++) {
          int plantingId = planting__List[y].plantingId;
          if (item["id"] == plantingId) {
            allItem_new.add(planting__List[y]);
            allItem_fieldName_planting.add(fieldName);
            allItem_plantingName_survey.add("");
            allItem_plantingCode_survey.add("");
            allItem_date_survey.add(0);
            allItem_substrict.add(substrict);
            allItem_district.add(district);
            allItem_province.add(province);
            allItem_title.add(title);
            allItem_firstName.add(firstName);
            allItem_lastName.add(lastName);
            allItem_plantings.add(planting__List[y]);
            allItem_surveys.add(Survey(
                0,
                0,
                0,
                "",
                "",
                0,
                0,
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                0,
                0,
                0,
                "",
                0,
                "",
                "",
                0,
                0,
                0,
                0,
                "",
                "",
                ""));
          }
        }

        list_fieldName_planting.add(fieldName);
        list_substrict_planting.add(substrict);
        list_district_planting.add(district);
        list_province_planting.add(province);
        list_title_planting.add(title);
        list_firstName_planting.add(firstName);
        list_lastName_planting.add(lastName);
      }
      //It's Survey
      else {
        String plantingName = item["plantingName"];
        String plantingCode = item["plantingCode"];
        String substrict = item["substrict"];
        String district = item["district"];
        String province = item["province"];
        String title = item["title"];
        String firstName = item["firstName"];
        String lastName = item["lastName"];
        for (int y = 0; y < survey__List.length; y++) {
          int surveyId = survey__List[y].surveyID;
          if (item["id"] == surveyId) {
            allItem_new.add(survey__List[y]);
            allItem_fieldName_planting.add("");
            allItem_plantingName_survey.add(plantingName);
            allItem_plantingCode_survey.add(plantingCode);
            allItem_date_survey.add(survey__List[y].date);
            allItem_substrict.add(substrict);
            allItem_district.add(district);
            allItem_province.add(province);
            allItem_title.add(title);
            allItem_firstName.add(firstName);
            allItem_lastName.add(lastName);

            allItem_plantings.add(Planting(
                0,
                "",
                "",
                0,
                "",
                "",
                "",
                "",
                "",
                "",
                0,
                0,
                "",
                "",
                0,
                0,
                "",
                "",
                "",
                "",
                "",
                0,
                "",
                0,
                "",
                0,
                "",
                "",
                "",
                0,
                0,
                "",
                0,
                0,
                "",
                0,
                0,
                "",
                "",
                0,
                0,
                0,
                0,
                0,
                0));
            allItem_surveys.add(survey__List[y]);
          }
        }

        list_plantingName_survey.add(plantingName);
        list_plantingCode_survey.add(plantingCode);
        list_substrict_survey.add(substrict);
        list_district_survey.add(district);
        list_province_survey.add(province);
        list_title_survey.add(title);
        list_firstName_survey.add(firstName);
        list_lastName_survey.add(lastName);
      }
    }
    if (mounted) {
      setState(() {
        _istLoading = false;
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        loadNewDataBySelectDate(selectedDay.millisecondsSinceEpoch);
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  onfirst() async {
    if (mounted) {
      setState(() {
        _istLoading = true;
      });
    }
    String? token = tokenFromLogin?.token;

    List<Object> objects = [];
    CalendarService calendarService = CalendarService();
    objects = await calendarService.getPlantingsAndSurveys(
        token.toString(), _focusedDay.millisecondsSinceEpoch);
    List<Planting> planting__List = [];
    List<Survey> survey__List = [];

    planting__List = await calendarService.getPlantingsByCreateDate(
        token.toString(), _focusedDay.millisecondsSinceEpoch);
    survey__List = await calendarService.getSurveysByCreateDate(
        token.toString(), _focusedDay.millisecondsSinceEpoch);

    for (int i = 0; i < planting__List.length; i++) {
      Planting plant = planting__List[i];
      plantings_new.add(plant);
    }
    for (int i = 0; i < survey__List.length; i++) {
      Survey sur = survey__List[i];
      list_date_survey.add(sur.date);
      surveys_new.add(sur);
    }

    for (int i = 0; i < objects.length; i++) {
      String convertObject = jsonEncode(objects[i]);
      Map<String, dynamic> item = jsonDecode(convertObject);
      String type = item["type"];
      //It's Planting
      if (type == "planting") {
        String fieldName = item["fieldName"];
        String name = item["name"];
        String substrict = item["substrict"];
        String district = item["district"];
        String province = item["province"];
        String title = item["title"];
        String firstName = item["firstName"];
        String lastName = item["lastName"];
        for (int y = 0; y < planting__List.length; y++) {
          int plantingId = planting__List[y].plantingId;
          if (item["id"] == plantingId) {
            allItem_new.add(planting__List[y]);
            allItem_fieldName_planting.add(fieldName);
            allItem_plantingName_survey.add("");
            allItem_plantingCode_survey.add("");
            allItem_date_survey.add(0);
            allItem_substrict.add(substrict);
            allItem_district.add(district);
            allItem_province.add(province);
            allItem_title.add(title);
            allItem_firstName.add(firstName);
            allItem_lastName.add(lastName);
            allItem_plantings.add(planting__List[y]);
            allItem_surveys.add(Survey(
                0,
                0,
                0,
                "",
                "",
                0,
                0,
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                0,
                0,
                0,
                "",
                0,
                "",
                "",
                0,
                0,
                0,
                0,
                "",
                "",
                ""));
          }
        }

        list_fieldName_planting.add(fieldName);
        list_substrict_planting.add(substrict);
        list_district_planting.add(district);
        list_province_planting.add(province);
        list_title_planting.add(title);
        list_firstName_planting.add(firstName);
        list_lastName_planting.add(lastName);
      }
      //It's Survey
      else {
        String plantingName = item["plantingName"];
        String plantingCode = item["plantingCode"];
        String substrict = item["substrict"];
        String district = item["district"];
        String province = item["province"];
        String title = item["title"];
        String firstName = item["firstName"];
        String lastName = item["lastName"];
        for (int y = 0; y < survey__List.length; y++) {
          int surveyId = survey__List[y].surveyID;
          if (item["id"] == surveyId) {
            allItem_new.add(survey__List[y]);
            allItem_fieldName_planting.add("");
            allItem_plantingName_survey.add(plantingName);
            allItem_plantingCode_survey.add(plantingCode);
            allItem_date_survey.add(survey__List[y].date);
            allItem_substrict.add(substrict);
            allItem_district.add(district);
            allItem_province.add(province);
            allItem_title.add(title);
            allItem_firstName.add(firstName);
            allItem_lastName.add(lastName);

            allItem_plantings.add(Planting(
                0,
                "",
                "",
                0,
                "",
                "",
                "",
                "",
                "",
                "",
                0,
                0,
                "",
                "",
                0,
                0,
                "",
                "",
                "",
                "",
                "",
                0,
                "",
                0,
                "",
                0,
                "",
                "",
                "",
                0,
                0,
                "",
                0,
                0,
                "",
                0,
                0,
                "",
                "",
                0,
                0,
                0,
                0,
                0,
                0));
            allItem_surveys.add(survey__List[y]);
          }
        }

        list_plantingName_survey.add(plantingName);
        list_plantingCode_survey.add(plantingCode);
        list_substrict_survey.add(substrict);
        list_district_survey.add(district);
        list_province_survey.add(province);
        list_title_survey.add(title);
        list_firstName_survey.add(firstName);
        list_lastName_survey.add(lastName);
      }
    }

    page++;

    if (mounted) {
      setState(() {
        _istLoading = false;
      });
    }
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue[400],
      ),
      width: sizeWidth(16, context),
      height: sizeHeight(16, context),
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: sizeHeight(12, context),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      //width: 500,
      height: sizeHeight(416.2, context),
      child: Column(
        children: [
          TableCalendar<Event>(
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, day, events) {
                if (events.isNotEmpty)
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(day, events),
                  );
              }, dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday ||
                    day.weekday == DateTime.saturday) {
                  final text = DateFormat.E().format(day);

                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              }),
              calendarStyle: CalendarStyle(
                todayTextStyle: TextStyle(fontSize: sizeHeight(16, context)),
                outsideTextStyle: TextStyle(
                  fontSize: sizeHeight(16, context),
                  color: Colors.grey,
                ),
                defaultTextStyle: TextStyle(fontSize: sizeHeight(16, context)),
                weekendTextStyle: TextStyle(
                    color: Colors.red, fontSize: sizeHeight(16, context)),
              ),
              onHeaderTapped: (e) async {
                final DateTime? selected = await showDatePicker(
                  context: context,
                  //initialDate: selectedDate,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2025), initialDate: _focusedDay,
                );

                if (selected != null && selected != _selectedDay)
                  setState(() {
                    ////print(selected);
                    _selectedDay = selected;
                    _focusedDay = selected;
                    // selectedDate = selected;
                  });
              },
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay,
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) async {
                // No need to call `setState()` here
                _focusedDay = focusedDay;
                // //print("_focusedDay : ${focusedDay}");
                await calendarFunction(_focusedDay);
              }),
        ],
      ),
    );
  }

  Widget _buildPlanting() {
    if (_istLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (plantings_new.length == 0) {
      return NoData().showNoData(context);
    }
    return ListView.builder(
      //controller: _inerscrollController,
      itemCount: plantings_new.length,
      padding: EdgeInsets.only(top: sizeHeight(8, context)),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final int count = plantings_new.length;
        Planting planting = plantings_new[index];
        String fieldName = list_fieldName_planting[index];
        String name = planting.name;
        String substrict = list_substrict_planting[index];
        String district = list_district_planting[index];
        String province = list_province_planting[index];
        String title = list_title_planting[index];
        String firstName = list_firstName_planting[index];
        String lastName = list_lastName_planting[index];

        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController?.forward();
        return CardItemWithOutImage_Planting_Calendar(
          plantings: planting,
          provider: widget.plantingProvider,
          callback: () {
            // //print("test inkwell");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       maintainState: false,
            //       builder: (context) =>
            //           PlantingMoreDetailScreen(plantingList[index])),
            // );
          },
          itemName: "${fieldName}",
          itemID: "${name}",
          city: "อ." + "${district}," + " จ." + "${province}",
          district: "ต." + "${substrict}",
          itemOwnerName: "${title} ${firstName}",
          itemOwnerLastName: "${lastName}",
          animation: animation,
          animationController: animationController!,
          // date: ChangeDateTime(
          // planting.createDate),
        );
      },
    );
  }

  Widget _buildSurvey() {
    if (_istLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (surveys_new.length == 0) {
      return NoData().showNoData(context);
    }
    return ListView.builder(
      //controller: _inerscrollController,
      itemCount: surveys_new.length,
      padding: EdgeInsets.only(top: sizeHeight(8, context)),

      itemBuilder: (BuildContext context, int index) {
        final int count = surveys_new.length;
        Survey survey = surveys_new[index];
        String plantingName = list_plantingName_survey[index];
        String plantingCode = list_plantingCode_survey[index];
        String substrict = list_substrict_survey[index];
        String district = list_district_survey[index];
        String province = list_province_survey[index];
        String title = list_title_survey[index];
        String firstName = list_firstName_survey[index];
        String lastName = list_lastName_survey[index];

        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController?.forward();
        return CardItemWithOutImage_Calendar(
          callback: () {
            //print("test inkwell");
            Navigator.push(
              context,
              MaterialPageRoute(
                  maintainState: false,
                  builder: (context) =>
                      BaseSurveyPoint(surveys_new[index], plantingCode)),
            );
          },
          callback2: () {
            //print("test inkwell");
            Navigator.push(
              context,
              MaterialPageRoute(
                  maintainState: false,
                  builder: (context) => SurveyMoreDetailScreen(
                      surveys_new[index], plantingCode, widget.surveyProvider)),
            );
          },
          itemID: plantingCode,
          itemName: plantingName,
          city: "อ." + "${district}," + "จ." + "${province}",
          district: "ต." + "${substrict}",
          itemOwnerName: "${title} ${firstName}",
          itemOwnerLastName: lastName,
          animation: animation,
          animationController: animationController!,
          date: ChangeDateTime(survey.date),
        );
      },
    );
  }

  Widget _buildAll() {
    if (_istLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (allItem_new.length == 0) {
      return NoData().showNoData(context);
    }
    return ListView.builder(
      //controller: _inerscrollController,
      itemCount: allItem_new.length,
      padding: EdgeInsets.only(top: sizeHeight(8, context)),

      itemBuilder: (BuildContext context, int index) {
        final int count = allItem_new.length;
        Object item = allItem_new[index];
        String fieldName = allItem_fieldName_planting[index];
        String plantingName = allItem_plantingName_survey[index];
        String plantingCode = allItem_plantingCode_survey[index];

        int date = allItem_date_survey[index];
        String substrict = allItem_substrict[index];
        String district = allItem_district[index];
        String province = allItem_province[index];
        String title = allItem_title[index];
        String firstName = allItem_firstName[index];
        String lastName = allItem_lastName[index];

        Survey survey = allItem_surveys[index];
        Planting planting = allItem_plantings[index];
        String name = planting.name;

        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController!,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController?.forward();
        return (item is Planting)
            ? CardItemWithOutImage_Planting_Calendar(
                plantings: planting,
                provider: widget.plantingProvider,
                callback: () {
                  // //print("test inkwell");
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       maintainState: false,
                  //       builder: (context) =>
                  //           PlantingMoreDetailScreen(plantingList[index])),
                  // );
                },
                itemName: "${fieldName}",
                itemID: "${name}",
                city: "อ." + "${district}," + " จ." + "${province}",
                district: "ต." + "${substrict}",
                itemOwnerName: "${title} ${firstName}",
                itemOwnerLastName: "${lastName}",
                animation: animation,
                animationController: animationController!,
                // date: ChangeDateTime(
                // planting.createDate),
              )
            : CardItemWithOutImage_Calendar(
                callback: () {
                  //print("test inkwell");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        maintainState: false,
                        builder: (context) =>
                            BaseSurveyPoint(survey, plantingCode)),
                  );
                },
                callback2: () {
                  //print("test inkwell");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        maintainState: false,
                        builder: (context) => SurveyMoreDetailScreen(
                            survey, plantingCode, widget.surveyProvider)),
                  );
                },
                itemID: plantingCode,
                itemName: plantingName,
                city: "อ." + "${district}," + "จ." + "${province}",
                district: "ต." + "${substrict}",
                itemOwnerName: "${title} ${firstName}",
                itemOwnerLastName: lastName,
                animation: animation,
                animationController: animationController!,
                date: ChangeDateTime(date),
              );
        ;
      },
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
              blurRadius: sizeWidth(8, context)),
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
                    Radius.circular(sizeWidth(32, context)),
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
                  "calendar-label".i18n(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeHeight(22, context),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + sizeHeight(40, context),
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeWidth(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeHeight(8, context)),
                        // child: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(sizeWidth(32, context)),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: EdgeInsets.all(sizeHeight(8, context)),
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(SizeConfig.screenHeight! * 0.08),
            child: getAppBarUI()),
        body: Column(
          children: <Widget>[
            // construct the profile details widget here
            SizedBox(
              height: SizeConfig.screenHeight! * 0.42,
              child: Container(
                height: SizeConfig.screenHeight,
                child: ListView(
                  children: [_buildCalendar()],
                ),
              ),
            ),

            // the tab bar with two items
            SizedBox(
              height: SizeConfig.screenHeight! * 0.5,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: sizeHeight(0, context)),
                      child: PreferredSize(
                          preferredSize:
                              Size.fromHeight(AppBar().preferredSize.height),
                          child: Container(
                            height: sizeHeight(50, context),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 5,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  sizeHeight(8, context),
                                ),
                                border: Border.all(
                                  color: theme_color,
                                  width: sizeWidth(1, context),
                                ),
                                color: Colors.white,
                              ),
                              child: TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                labelStyle: TextStyle(
                                    fontSize: sizeHeight(18, context)),
                                indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      sizeHeight(8, context),
                                    ),
                                    color: theme_color2),
                                tabs: [
                                  Tab(
                                    // icon: Icon(Icons.inbox),
                                    text: ('All'.i18n()),
                                  ),
                                  Tab(
                                    // icon: Icon(
                                    //   Icons.image,
                                    // ),
                                    text: ('planting-label'.i18n()),
                                  ),
                                  Tab(
                                    // icon: Icon(
                                    //   Icons.description,
                                    // ),
                                    text: ('survey-label'.i18n()),
                                  ),
                                ],
                              ),
                            ),
                          ))),

                  // create widgets for each tab bar here
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.5,
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        Container(
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
                          child: Center(child: _buildAll()),
                        ),

                        Container(
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
                          child: Center(child: _buildPlanting()),
                        ),
                        // second tab bar viiew widget
                        Container(
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
                            child: _buildSurvey()),
                      ],
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
