import 'dart:ui';
import 'package:intl/intl.dart';

String ChangeDateTime(int input) {
  Locale? _locale;
  String formattedDate;

  if (_locale?.languageCode == 'en') {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(input);

    var localDate = DateFormat.yMMMd('en');

    formattedDate = localDate.format(date);
  } else {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(input);
    int gregorianYear = date.year;
    int buddhistYear = gregorianYear + 543;

    var localDate = DateFormat.yMMMd('th');

    formattedDate = localDate
        .format(date)
        .replaceAll(gregorianYear.toString(), buddhistYear.toString());
  }

  return formattedDate;
}
