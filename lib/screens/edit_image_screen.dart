import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';

class EditImageScreen extends StatefulWidget {
  final int index;
  final String base64Image;
  final String description;
  final String date;

  const EditImageScreen({
    required this.index,
    required this.base64Image,
    required this.description,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  _EditImageScreenState createState() => _EditImageScreenState();
}

class _EditImageScreenState extends State<EditImageScreen> {
  late TextEditingController _descriptionController;
  late String _date;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
    _date = widget.date;
  }

  void _saveChanges() {
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    final updatedDescription = _descriptionController.text;

    userSettings.updateImage(
      index: widget.index,
      base64Image: widget.base64Image,
      description: updatedDescription,
      date: _date,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(widget.base64Image);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Display the image in a polaroid-like container
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.memory(
                      imageBytes,
                      fit: BoxFit.cover,
                      height: 250,
                      width: double.infinity,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'CaladeaItalic',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Date: $_date',
              style: TextStyle(
                fontSize: 16, // Adjust the size as needed
                fontFamily: 'CaladeaItalic', // Specify the font family
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
