import 'package:flutter/material.dart';

class HistoryEntry {
  final TimeOfDay timeIn;
  final TimeOfDay timeOut;
  final DateTime date;

  HistoryEntry({
    required this.timeIn,
    required this.timeOut,
    required this.date,
  });

  double get workedHours {
    final inMinutes = timeIn.hour * 60 + timeIn.minute;
    var outMinutes = timeOut.hour * 60 + timeOut.minute;

    if (outMinutes < inMinutes) {
      outMinutes += 24 * 60;
    }

    return (outMinutes - inMinutes) / 60.0;
  }
}