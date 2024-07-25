import 'package:flutter/material.dart';
import '../models/image_entry.dart'; // Ensure correct import

class CustomImageProvider with ChangeNotifier {
  final List<ImageEntry> _imagesWithDescriptions = [];

  List<ImageEntry> get imagesWithDescriptions => _imagesWithDescriptions;

  void addImage(String base64Image, String description) {
    _imagesWithDescriptions.add(ImageEntry(base64Image: base64Image, description: description));
    notifyListeners();
  }
}
