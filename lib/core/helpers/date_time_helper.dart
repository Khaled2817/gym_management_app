import 'package:gym_management_app/core/helpers/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  int getEndDate(DateTime date) {
    return date.add(const Duration(hours: 5)).millisecondsSinceEpoch +
        1000 * 30;
  }

  String timeToString(TimeOfDay time) {
    final hour12 = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // 0 AM → 12
    final hourStr = hour12.toString().padLeft(2, '0'); // يخلي 07 بدل 7 لو حبيت
    final minuteStr = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";

    return "$hourStr:$minuteStr $period";
  }

  String timeFromDate(DateTime date) {
    String isPm = "am";
    String hour = date.hour.toString();
    String minute = date.minute.toString();
    if (date.hour > 11) {
      isPm = "pm";
    }
    if (hour.length == 1) {
      hour = "0$hour";
    }

    if (minute.length == 1) {
      minute = "0$minute";
    }

    return "${date.hour}:${date.minute} $isPm";
  }

  String timeFromTimeOfDay(TimeOfDay? time) {
    int hour = time!.hour;
    String minute = time.minute.toString().padLeft(2, '0');
    String second = '00'; // لأن TimeOfDay ما فيه ثواني
    return "$hour h $minute m $second s";
  }

  TimeOfDay timeOfFromString(String time) {
    return TimeOfDay(
      hour: int.parse(time.split(":")[0]),
      minute: int.parse(time.split(":")[1]),
    );
  }

  DateTime? dateTimeFromString(String? date) {
    try {
      return DateTime.parse(date ?? "");
    } catch (E) {
      return null;
    }
  }

  String dateToString(DateTime? date) {
    return "${date?.year}/${date?.month}/${date?.day}";
  }

  String dateToDayMonthYear(DateTime? date, {bool? showTime}) {
    return "${date?.day} ${getMonthName(date)} ${date?.year} ${showTime == true ? getTimeFromDateTime(date) : ""}";
  }

  String getMonthName(DateTime? dT) {
    List months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    int currentMonth = dT?.month ?? 1;
    return '${months[currentMonth - 1]}';
  }

  String getDayName(DateTime? dT) {
    return DateFormat('EEEE').format(dT ?? DateTime.now());
  }

  int getDayNumber(DateTime? dT) {
    return dT?.day ?? 0;
  }

  String? getListOfExpiredDate(DateTime? dateTime) {
    try {
      List<Map<String, dynamic>> list = [];
      DateTime now = DateTime.now();
      int differenceInMinutes = dateTime!.difference(now).inMinutes;
      int years = (differenceInMinutes ~/ (525600));
      list.add({"name": "Year", "val": years});

      differenceInMinutes = (differenceInMinutes - (years * 525600));
      int months = (differenceInMinutes ~/ 43800);
      list.add({"name": "M", "val": months});

      differenceInMinutes = (differenceInMinutes - (months * 43800));
      int days = (differenceInMinutes ~/ 1436);
      list.add({"name": "D", "val": days});

      differenceInMinutes = (differenceInMinutes - (days * 1436));
      int hours = (differenceInMinutes ~/ 60);
      list.add({"name": "H", "val": hours});

      differenceInMinutes = (differenceInMinutes - (hours * 60));
      list.add({"name": "Min", "val": differenceInMinutes});
      return getStringFromExpiredList(list);
    } catch (E) {
      return null;
    }
  }

  String? getStringFromExpiredList(List<Map<String, dynamic>>? list) {
    String data = "";

    if (list == null) {
      return null;
    } else {
      for (Map<String, dynamic> x in list) {
        if (x["val"] != 0) {
          data = "$data  ${x["val"]?.toString()}${x["name"]} ";
        }
      }
      return data;
    }
  }

  String getTimeFromDateTime(DateTime? dT) {
    String value = DateFormat.Hms().format(dT ?? DateTime.now());
    return value.substring(0, 5);
  }

  String getDayAndMonth(DateTime dT) {
    List months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec',
    ];
    int currentMonth = dT.month;
    return '${dT.day} ${months[currentMonth - 1]}';
  }

  String getYear(DateTime dT) {
    return dT.year.toString();
  }

  String getDatesDiff(DateTime target, DateTime now) {
    int difference = now.difference(target).inMinutes;

    if (difference < 60) {
      int diff = (difference).round();
      return "${target.year}/ ${target.month} /${target.day} ";
    } else if ((difference / 60).round() < 24) {
      int diff = (difference / 60).round();
      return " $diff Hour ago";
    } else if (now.difference(target).inDays > 30 &&
        now.difference(target).inDays < 356) {
      int diff = (now.difference(target).inDays / 30).round();
      return " $diff Month ago";
    }
    return "${getYear(target)} , ${getDayAndMonth(target)}";
  }

  String getDatesDiffTime(DateTime target) {
    int difference = target.difference(DateTime.now()).inSeconds;
    int min = 0;
    int seconds = 0;

    min = (difference / 60).round().abs();
    seconds = difference - (min * 60);
    seconds = seconds.abs();
    return "( ${min > 9 ? "$min" : "0$min"}${seconds > 9 ? " : $seconds" : ": 0$seconds"} )";
  }
}

extension CustomDateFormat on DateTime? {
  String? toDayMonthYear() {
    if (this == null) return null;
    return DateFormat(
      'd MMMM yyyy - hh:mm:ss a',
      navigatorKey.currentContext?.locale.languageCode ?? 'en',
    ).format(this!);
  }

  String? toDaynameMonthYear() {
    if (this == null) return null;
    return DateFormat(
      'EEEE d MMMM yyyy',
      navigatorKey.currentContext?.locale.languageCode ?? 'en',
    ).format(this!);
  }

  String? toDayAndMonthYear() {
    if (this == null) return null;
    return DateFormat(
      'd MMMM yyyy',
      navigatorKey.currentContext?.locale.languageCode ?? 'en',
    ).format(this!);
  }
}
