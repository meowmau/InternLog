import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Consumer<UserSettings>(
        builder: (context, userSettings, child) {
          final currentProfile = userSettings.currentProfileData;

          if (currentProfile == null) {
            return const Center(
              child: Text(
                'No profile selected.',
                style: TextStyle(fontFamily: 'CaladeaRegular'),
              ),
            );
          }

          final history = currentProfile.history;

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return ListTile(
                title: Text(
                  'Date: ${entry.date.toLocal().toShortDateString()}',
                  style: const TextStyle(fontFamily: 'CaladeaRegular'),
                ),
                subtitle: Text(
                  'Time In: ${entry.timeIn.format(context)} - Time Out: ${entry.timeOut.format(context)}',
                  style: const TextStyle(fontFamily: 'CaladeaRegular'),
                ),
                trailing: Text(
                  'Worked: ${entry.workedHours.toStringAsFixed(2)} hours',
                  style: const TextStyle(fontFamily: 'CaladeaRegular'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension DateTimeExtension on DateTime {
  String toShortDateString() {
    return '$month/$day/$year';
  }
}
