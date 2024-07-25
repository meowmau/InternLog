import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';

class AddImageScreen extends StatefulWidget {
  const AddImageScreen({super.key});

  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  Uint8List? _imageData;
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsArrayBuffer(files[0]!);
      reader.onLoadEnd.listen((e) {
        setState(() {
          _imageData = reader.result as Uint8List?;
        });
      });
    });
  }

  void _saveImageAndDescription() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_imageData != null) {
        final userSettings = Provider.of<UserSettings>(context, listen: false);

        // Convert Uint8List to base64 string
        final base64Image = base64Encode(_imageData!);  // Remove the data:image/jpeg;base64, prefix
        final description = _descriptionController.text;

        // Save image data and description to UserSettings
        userSettings.addImage(base64Image, description);

        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select an image.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image and Description'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageData == null
                    ? Container(
                        height: 200.0,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Text('Tap to select an image'),
                        ),
                      )
                    : Image.memory(_imageData!),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveImageAndDescription,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
