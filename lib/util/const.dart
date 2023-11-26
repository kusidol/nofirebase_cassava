import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mun_bot/controller/calendar_service.dart';
import 'package:mun_bot/controller/planting_service.dart';
import 'package:mun_bot/controller/survey_service.dart';
import 'package:mun_bot/entities/planting.dart';
import 'package:mun_bot/entities/survey.dart';
import 'package:mun_bot/env.dart';
import 'package:mun_bot/screen/login/login_screen.dart';

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

import '../main.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

class TempEvent {
  final int date;
  final int num_events;

  const TempEvent(this.date, this.num_events);
}

// Varieble for create Event
final daysDifference = kLastDay.difference(kFirstDay).inDays;

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
LinkedHashMap<DateTime, List<Event>> kEvents =
    LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);
List<DateTime> generateDaysInMonth(DateTime targetDate) {
  int year = targetDate.year;
  int month = targetDate.month;

  // Find the first day of the month
  DateTime firstDay = DateTime(year, month, 1);

  // Find the last day of the month
  DateTime lastDay = DateTime(year, month + 1, 0);

  // Generate a list of all days in the month
  List<DateTime> daysInMonth = [];
  for (int day = 1; day <= lastDay.day; day++) {
    daysInMonth.add(DateTime(year, month, day));
  }

  return daysInMonth;
}

Future<void> calendarFunction(DateTime date) async {
  int date_int = date.millisecondsSinceEpoch;
  String? token = tokenFromLogin?.token;
  CalendarService calendarService = CalendarService();

  List<DateTime> dates = generateDaysInMonth(date);
  List<int> counts = await calendarService.getNumberEvents(
      token.toString(), date.millisecondsSinceEpoch);
  int length = counts.length;

  List<TempEvent> tempEvents = [];
  for (int i = 0; i < length; i++) {
    TempEvent tempEvent = TempEvent(dates[i].millisecondsSinceEpoch, counts[i]);
    tempEvents.add(tempEvent);
  }
  final _kEventTest = Map.fromIterable(tempEvents,
      key: (item) => DateTime.fromMillisecondsSinceEpoch(item.date),
      value: (item) =>
          List.generate(item.num_events, (index) => Event('Event : ${index}')));
  kEvents = kEvents..addAll(_kEventTest);
}

testFunction(List<DateTime> dates) async {
  List<TempEvent> tempEvents = [];

  String? token = tokenFromLogin?.token;

  List<Survey> surveys = [];
  SurveyService surveyService = SurveyService();
  List<Planting> plantings = [];
  PlantingService plantingService = PlantingService();

  // List<DateTime> dateList = dates;

  for (int i = 0; i < dates.length; i++) {
    int date_int = dates[i].millisecondsSinceEpoch;
    int count = 0;
    List<String> temp = [];

    surveys =
        await surveyService.getSurveysByCreateDate(date_int, token.toString());
    for (int y = 0; y < surveys.length; y++) {
      temp.add(surveys[y].firstName);
    }
    plantings = await plantingService.getPlantingByCreateDate(
        date_int, token.toString());
    for (int y = 0; y < plantings.length; y++) {
      temp.add(plantings[y].name);
    }
    count = temp.length;
    TempEvent tempEvent = TempEvent(date_int, count);
    tempEvents.add(tempEvent);
  }
  final _kEventTest = Map.fromIterable(tempEvents,
      key: (item) => DateTime.fromMillisecondsSinceEpoch(item.date),
      value: (item) =>
          List.generate(item.num_events, (index) => Event('Event : ${index}')));
  kEvents = kEvents..addAll(_kEventTest);
}

final _kEventSource = Map.fromIterable(
  List.generate(50, (index) => index),
  key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
  value: (item) => List.generate(
    item % 4 + 1,
    (index) => Event('Event $item | ${index + 1}'),
  ),
);

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
final kHintTextStyle = TextStyle(
  color: Colors.black87,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  border: Border.all(width: 2, color: theme_color),
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.0),
  boxShadow: [
    //BoxShadow(
    // color: Colors.black12,
    //blurRadius: 6.0,
    //offset: Offset(0, 2),
    //),
  ],
);
