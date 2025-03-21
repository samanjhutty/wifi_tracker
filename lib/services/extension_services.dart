import 'package:flutter/material.dart';
import 'theme_services.dart';

extension MyContext on BuildContext {
  ThemeServiceState get scheme => MyTheme.of(this);
}

extension MyList on List<String> {
  String get asString => _removeBraces(this);

  String _removeBraces(List<String> list) {
    return list.toString().replaceAll(RegExp(r'[\[\]]'), '');
  }
}

extension MyDuration on Duration {
  String get format => _format(this);
  String get formatRAW => _formatRaw(this);

  String _formatRaw(Duration time) {
    if (time.inMinutes >= 60) {
      final min = time.inMinutes - (time.inHours * 60);
      return '${time.inHours} H, ${_formatInt(min)} min';
    }
    return '${time.inMinutes} min';
  }

  String _format(Duration time) {
    final raw = _formatRaw(time);
    if (raw.split(' ').first == '0') return 'Few seconds';
    return raw;
  }

  String _formatInt(int num) {
    if (num < 10) return '0$num';
    return num.toString();
  }
}

extension MyDateTime on DateTime {
  // String toJson() => _dateTime(this);
  String get formatTime => _formatedTime(this);
  String get formatDate => _formatedDate(this);
  String get format => _format(this);

  // String _dateTime(DateTime now) {
  //   String date = '${now.year}${_format(now.month)}${_format(now.day)}';
  //   String time =
  //       '${_format(now.hour)}${_format(now.minute)}'
  //       '${_format(now.second)}${_formatMili(now.millisecond)}';
  //   return date + time;
  // }

  // String _formatMili(int number) {
  //   String int = number.toString();
  //   switch (int.length) {
  //     case 2:
  //       return '0$int';
  //     case 1:
  //       return '00$int';
  //     default:
  //       return int;
  //   }
  // }

  String _formatedTime(DateTime time) {
    String hour = _formatInt(time.hour);
    String min = _formatInt(time.minute);

    return '$hour:$min';
  }

  String _formatedDate(DateTime time) {
    String day = _formatInt(time.day);

    return '${_formatMonth(time.month)} $day, ${time.year}';
  }

  String _formatInt(int number) {
    String int = number.toString();
    String result = int.length > 1 ? int : '0$int';
    return result;
  }

  String _format(DateTime dateTime) {
    final date = dateTime.formatDate;
    final time = dateTime.formatTime;
    return '$date $time';
  }

  String _formatMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';

      default:
        return '$month';
    }
  }
}

extension MyString on String {
  // DateTime get toDateTime => _formJson(this);
  bool get isStringPass => _passRegExp(this);

  _passRegExp(String text) {
    final passExp = RegExp(r'^(?=.*[A-Z])(?=.*\d).{6,}$');
    return passExp.hasMatch(text);
  }

  // DateTime _formJson(String datetime) {
  //   int year = int.parse(datetime.substring(0, 4));
  //   int month = int.parse(datetime.substring(4, 6));
  //   int day = int.parse(datetime.substring(6, 8));
  //   int hour = int.parse(datetime.substring(8, 10));
  //   int min = int.parse(datetime.substring(10, 12));
  //   int sec = int.parse(datetime.substring(12, 14));
  //   int milli = int.parse(datetime.substring(14, 17));
  //   return DateTime(year, month, day, hour, min, sec, milli);
  // }
}
