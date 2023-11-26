import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mun_bot/util/size_config.dart';
import 'package:mun_bot/util/ui/survey_theme.dart';

class CustomCalendarView extends StatefulWidget {
  const CustomCalendarView(
      {Key? key,
      this.initialStartDate,
      this.initialEndDate,
      this.startEndDateChange,
      this.minimumDate,
      this.maximumDate})
      : super(key: key);

  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  final Function(DateTime, DateTime)? startEndDateChange;

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  List<DateTime> dateList = <DateTime>[];
  DateTime currentMonthDate = DateTime.now();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    setListOfDate(currentMonthDate);
    if (widget.initialStartDate != null) {
      startDate = widget.initialStartDate;
    }
    if (widget.initialEndDate != null) {
      endDate = widget.initialEndDate;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setListOfDate(DateTime monthDate) {
    dateList.clear();
    final DateTime newDate = DateTime(monthDate.year, monthDate.month, 0);
    int previousMothDay = 0;
    if (newDate.weekday < 7) {
      previousMothDay = newDate.weekday;
      for (int i = 1; i <= previousMothDay; i++) {
        dateList.add(newDate.subtract(Duration(days: previousMothDay - i)));
      }
    }
    for (int i = 0; i < (42 - previousMothDay); i++) {
      dateList.add(newDate.add(Duration(days: i + 1)));
    }
    // if (dateList[dateList.length - 7].month != monthDate.month) {
    //   dateList.removeRange(dateList.length - 7, dateList.length);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: sizeWidth(8, context),
                right: sizeWidth(8, context),
                top: sizeHeight(4, context),
                bottom: sizeHeight(4, context)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(sizeHeight(8, context)),
                  child: Container(
                    height: sizeHeight(38, context),
                    width: sizeWidth(38, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(sizeHeight(24, context))),
                      border: Border.all(
                        color: HotelAppTheme.buildLightTheme().dividerColor,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                            Radius.circular(sizeHeight(24, context))),
                        onTap: () {
                          setState(() {
                            currentMonthDate = DateTime(currentMonthDate.year,
                                currentMonthDate.month, 0);
                            setListOfDate(currentMonthDate);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('MMMM, yyyy').format(currentMonthDate),
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: sizeHeight(20, context),
                          color: Colors.black),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(sizeHeight(8, context)),
                  child: Container(
                    height: sizeHeight(38, context),
                    width: sizeWidth(38, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(sizeHeight(24, context))),
                      border: Border.all(
                        color: HotelAppTheme.buildLightTheme().dividerColor,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                            Radius.circular(sizeHeight(24, context))),
                        onTap: () {
                          setState(() {
                            currentMonthDate = DateTime(currentMonthDate.year,
                                currentMonthDate.month + 2, 0);
                            setListOfDate(currentMonthDate);
                          });
                        },
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: sizeWidth(8, context),
                left: sizeWidth(8, context),
                bottom: sizeHeight(8, context)),
            child: Row(
              children: getDaysNameUI(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: sizeWidth(8, context), left: sizeWidth(8, context)),
            child: Column(
              children: getDaysNoUI(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getDaysNameUI() {
    final List<Widget> listUI = <Widget>[];
    for (int i = 0; i < 7; i++) {
      listUI.add(
        Expanded(
          child: Center(
            child: Text(
              DateFormat('EEE').format(dateList[i]),
              style: TextStyle(
                  fontSize: sizeHeight(16, context),
                  fontWeight: FontWeight.w500,
                  color: HotelAppTheme.buildLightTheme().primaryColor),
            ),
          ),
        ),
      );
    }
    return listUI;
  }

  List<Widget> getDaysNoUI() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    for (int i = 0; i < dateList.length / 7; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < 7; i++) {
        final DateTime date = dateList[count];
        listUI.add(
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: sizeHeight(3, context),
                          bottom: sizeHeight(3, context)),
                      child: Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: sizeHeight(2, context),
                              bottom: sizeHeight(2, context),
                              left: isStartDateRadius(date) ? 4 : 0,
                              right: isEndDateRadius(date) ? 4 : 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: startDate != null && endDate != null
                                  ? getIsItStartAndEndDate(date) ||
                                          getIsInRange(date)
                                      ? HotelAppTheme.buildLightTheme()
                                          .primaryColor
                                          .withOpacity(0.4)
                                      : Colors.transparent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.only(
                                bottomLeft: isStartDateRadius(date)
                                    ? Radius.circular(sizeHeight(24, context))
                                    : Radius.circular(0.0),
                                topLeft: isStartDateRadius(date)
                                    ? Radius.circular(sizeHeight(24, context))
                                    : Radius.circular(0.0),
                                topRight: isEndDateRadius(date)
                                    ? Radius.circular(sizeHeight(24, context))
                                    : Radius.circular(0.0),
                                bottomRight: isEndDateRadius(date)
                                    ? Radius.circular(sizeHeight(24, context))
                                    : Radius.circular(0.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                            Radius.circular(sizeHeight(32, context))),
                        onTap: () {
                          if (currentMonthDate.month == date.month) {
                            if (widget.minimumDate != null &&
                                widget.maximumDate != null) {
                              final DateTime newminimumDate = DateTime(
                                  widget.minimumDate!.year,
                                  widget.minimumDate!.month,
                                  widget.minimumDate!.day - 1);
                              final DateTime newmaximumDate = DateTime(
                                  widget.maximumDate!.year,
                                  widget.maximumDate!.month,
                                  widget.maximumDate!.day + 1);
                              if (date.isAfter(newminimumDate) &&
                                  date.isBefore(newmaximumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.minimumDate != null) {
                              final DateTime newminimumDate = DateTime(
                                  widget.minimumDate!.year,
                                  widget.minimumDate!.month,
                                  widget.minimumDate!.day - 1);
                              if (date.isAfter(newminimumDate)) {
                                onDateClick(date);
                              }
                            } else if (widget.maximumDate != null) {
                              final DateTime newmaximumDate = DateTime(
                                  widget.maximumDate!.year,
                                  widget.maximumDate!.month,
                                  widget.maximumDate!.day + 1);
                              if (date.isBefore(newmaximumDate)) {
                                onDateClick(date);
                              }
                            } else {
                              onDateClick(date);
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(sizeHeight(2, context)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: getIsItStartAndEndDate(date)
                                  ? HotelAppTheme.buildLightTheme().primaryColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(sizeHeight(32, context))),
                              border: Border.all(
                                color: getIsItStartAndEndDate(date)
                                    ? Colors.white
                                    : Colors.transparent,
                                width: sizeWidth(2, context),
                              ),
                              boxShadow: getIsItStartAndEndDate(date)
                                  ? <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          blurRadius: 4,
                                          offset: const Offset(0, 0)),
                                    ]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                    color: getIsItStartAndEndDate(date)
                                        ? Colors.white
                                        : currentMonthDate.month == date.month
                                            ? Colors.black
                                            : Colors.grey.withOpacity(0.6),
                                    fontSize:
                                        MediaQuery.of(context).size.width > 360
                                            ? 18
                                            : sizeHeight(16, context),
                                    fontWeight: getIsItStartAndEndDate(date)
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: sizeHeight(9, context),
                      right: 0,
                      left: 0,
                      child: Container(
                        height: sizeHeight(6, context),
                        width: sizeWidth(6, context),
                        decoration: BoxDecoration(
                            color: DateTime.now().day == date.day &&
                                    DateTime.now().month == date.month &&
                                    DateTime.now().year == date.year
                                ? getIsInRange(date)
                                    ? Colors.white
                                    : HotelAppTheme.buildLightTheme()
                                        .primaryColor
                                : Colors.transparent,
                            shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        count += 1;
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  bool getIsInRange(DateTime date) {
    if (startDate != null && endDate != null) {
      if (date.isAfter(startDate!) && date.isBefore(endDate!)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool getIsItStartAndEndDate(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month &&
        startDate!.year == date.year) {
      return true;
    } else if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month &&
        endDate!.year == date.year) {
      return true;
    } else {
      return false;
    }
  }

  bool isStartDateRadius(DateTime date) {
    if (startDate != null &&
        startDate!.day == date.day &&
        startDate!.month == date.month) {
      return true;
    } else if (date.weekday == 1) {
      return true;
    } else {
      return false;
    }
  }

  bool isEndDateRadius(DateTime date) {
    if (endDate != null &&
        endDate!.day == date.day &&
        endDate!.month == date.month) {
      return true;
    } else if (date.weekday == 7) {
      return true;
    } else {
      return false;
    }
  }

  void onDateClick(DateTime date) {
    if (startDate == null) {
      startDate = date;
    } else if (startDate != date && endDate == null) {
      endDate = date;
    } else if (startDate!.day == date.day && startDate!.month == date.month) {
      startDate = null;
    } else if (endDate!.day == date.day && endDate!.month == date.month) {
      endDate = null;
    }
    if (startDate == null && endDate != null) {
      startDate = endDate;
      endDate = null;
    }
    if (startDate != null && endDate != null) {
      if (!endDate!.isAfter(startDate!)) {
        final DateTime d = startDate!;
        startDate = endDate;
        endDate = d;
      }
      if (date.isBefore(startDate!)) {
        startDate = date;
      }
      if (date.isAfter(endDate!)) {
        endDate = date;
      }
    }
    setState(() {
      try {
        widget.startEndDateChange!(startDate!, endDate!);
      } catch (_) {}
    });
  }
}
