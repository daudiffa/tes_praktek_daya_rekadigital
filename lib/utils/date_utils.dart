import 'dart:core';

import 'package:intl/intl.dart';

extension DateUtils on DateTime {
  /// Convert the given timestamp in BMKG format to a `DateTime` object
  /// 
  /// The date-time format in the BMKG XML is 'yyyyMMddHHmm'
  static DateTime fromBMKG(String timestamp) {
    return DateTime(
      int.parse(timestamp.substring(0, 4)),
      int.parse(timestamp.substring(4, 6)),
      int.parse(timestamp.substring(6, 8)),
      int.parse(timestamp.substring(8, 10)),
      int.parse(timestamp.substring(10, 12)),
    );
  }

  /// Convert this `DateTime` object to a string with the BMKG format
  /// 
  /// The date-time format in the BMKG XML is 'yyyyMMddHHmm'
  String toBMKG() {
    // ISO-8601 string format is 'yyyy-MM-ddTHH:mm:ss.mmmuuuZ'
    return toIso8601String().substring(0, 16).replaceAll(RegExp(r"^[0-9]"), "");
  }

  /// Convert this `DateTime` object to a string only showing the day and the
  /// month
  String toDayMonth() {
    return DateFormat("d MMMM", "id_ID").format(this);
  }

  /// Convert this `DateTime` object to a string only showing the hour and the
  /// minute
  String toHourMinute() {
    return DateFormat("HH:mm", "id_ID").format(this);
  }
}