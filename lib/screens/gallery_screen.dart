import 'dart:convert';  // Decode base64 strings
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';
import 'edit_image_screen.dart';  // Import EditImageScreen

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: userSettings.imagesWithDescriptions.length,
        itemBuilder: (BuildContext context, int index) {
          final imageWithDescription = userSettings.imagesWithDescriptions[index];
          final base64Image = imageWithDescription['image']!;
          final description = imageWithDescription['description']!;
          final date = imageWithDescription['date']!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditImageScreen(
                    index: index,
                    base64Image: base64Image,
                    description: description,
                    date: date,
                  ),
                ),
              );
            },
            child: BackGroundTile(
              base64Image: base64Image,
              description: description,
              date: date,
            ),
          );
        },
      ),
    );
  }
}

class BackGroundTile extends StatelessWidget {
  final String base64Image;
  final String description;
  final String date;

  const BackGroundTile({
    super.key,
    required this.base64Image,
    required this.description,
    required this.date,
  });

  String formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    final date = '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    final time = dateTime.hour > 12
        ? '${dateTime.hour - 12}:${dateTime.minute.toString().padLeft(2, '0')} PM'
        : '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} AM';
    return '$date, $time';
  }

  @override
  Widget build(BuildContext context) {
    final imageBytes = base64Decode(base64Image);  // Decode base64 image data

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Add margin around the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the column contents
        children: [
          Container(
            height: 150, // Set a fixed height for the image container
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(imageBytes),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center text contents
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold, // Optional: Make text bold
                  ),
                  textAlign: TextAlign.center, // Center text horizontally
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Date: ${formatDateTime(date)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold, // Optional: Make text bold
                  ),
                  textAlign: TextAlign.center, // Center text horizontally
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
