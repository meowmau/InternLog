import 'dart:convert';  // For base64 encoding/decoding
import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class UserSettings with ChangeNotifier {
  bool _darkMode = false;
  final Map<String, UserProfile> _profiles = {};
  String? _currentProfile;
  bool _isLoggedIn = false;
  final List<Map<String, String>> _imagesWithDescriptions = [];  // Store images with descriptions

  bool get darkMode => _darkMode;
  Map<String, UserProfile> get profiles => _profiles;
  String? get currentProfile => _currentProfile;
  bool get isLoggedIn => _isLoggedIn;
  List<Map<String, String>> get imagesWithDescriptions => _imagesWithDescriptions;  // Getter for images with descriptions

  void toggleDarkMode() {
    _darkMode = !_darkMode;
    notifyListeners();
  }

  void addProfile(String name) {
    _profiles[name] = UserProfile(name: name);
    _currentProfile ??= name;
    notifyListeners();
  }

  void removeProfile(String name) {
    _profiles.remove(name);
    if (_currentProfile == name) {
      _currentProfile = _profiles.keys.isNotEmpty ? _profiles.keys.first : null;
    }
    notifyListeners();
  }

  void switchProfile(String name) {
    if (_profiles.containsKey(name)) {
      _currentProfile = name;
      notifyListeners();
    }
  }

  UserProfile? get currentProfileData {
    return _profiles[_currentProfile];
  }

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void addImage(String base64Image, String description) {
    final date = DateTime.now().toString(); // Store the current date
    _imagesWithDescriptions.add({
      'image': base64Image,
      'description': description,
      'date': date,
    });
    notifyListeners();
  }

   void updateImage({
    required int index,
    required String base64Image,
    required String description,
    required String date,
  }) {
    if (index >= 0 && index < _imagesWithDescriptions.length) {
      _imagesWithDescriptions[index] = {
        'image': base64Image,
        'description': description,
        'date': date,
      };
      notifyListeners();
    }
  }
}