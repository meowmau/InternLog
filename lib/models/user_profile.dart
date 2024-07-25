import 'package:flutter/material.dart';
import 'history_entry.dart';

class UserProfile with ChangeNotifier {
  final String name;
  double _goalHours = 0.0;
  double _workedHours = 0.0;
  final List<HistoryEntry> _history = [];

  UserProfile({required this.name});

  double get goalHours => _goalHours;
  double get workedHours => _workedHours;
  List<HistoryEntry> get history => _history;

  void setGoalHours(double hours) {
    _goalHours = hours;
    notifyListeners();
  }

  void addWorkedHours(double hours) {
    _workedHours += hours;
    notifyListeners();
  }
  
  void updateGoalHours(double newGoalHours) {
    _goalHours = newGoalHours;
    notifyListeners();
  }

  void addHistory(HistoryEntry entry) {
    _history.add(entry);
    addWorkedHours(entry.workedHours);
    notifyListeners();
  }
}
