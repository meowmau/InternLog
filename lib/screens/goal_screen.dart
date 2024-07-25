// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';
import '../models/history_entry.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({Key? key});

  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  TimeOfDay? _timeIn;
  TimeOfDay? _timeOut;
  bool _entrySaved = false; // Flag to track if the entry is saved

  Future<void> _pickTime(BuildContext context, bool isTimeIn) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isTimeIn) {
          _timeIn = pickedTime;
        } else {
          _timeOut = pickedTime;
        }
      });
    }
  }

  void _saveEntry() {
    if (_timeIn != null && _timeOut != null) {
      final now = DateTime.now();
      final timeInDateTime = DateTime(now.year, now.month, now.day, _timeIn!.hour, _timeIn!.minute);
      var timeOutDateTime = DateTime(now.year, now.month, now.day, _timeOut!.hour, _timeOut!.minute);

      if (timeOutDateTime.isBefore(timeInDateTime)) {
        timeOutDateTime = timeOutDateTime.add(const Duration(days: 1));
      }

      double durationHours = timeOutDateTime.difference(timeInDateTime).inHours.toDouble();

      if (durationHours < 0) {
        durationHours += 24.0;
      }

      final entry = HistoryEntry(
        timeIn: TimeOfDay.fromDateTime(timeInDateTime),
        timeOut: TimeOfDay.fromDateTime(timeOutDateTime),
        date: now,
      );

      final userSettings = Provider.of<UserSettings>(context, listen: false);
      final currentProfile = userSettings.currentProfileData;

      if (currentProfile != null) {
        currentProfile.addHistory(entry);
      }

      setState(() {
        _timeIn = null;
        _timeOut = null;
        _entrySaved = true; // Set the flag to true after saving the entry
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<UserSettings>(
          builder: (context, userSettings, child) {
            final currentProfile = userSettings.currentProfileData;
            return Text(currentProfile != null ? "${currentProfile.name}'s Goal" : 'Goal');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<UserSettings>(
              builder: (context, userSettings, child) {
                final currentProfile = userSettings.currentProfileData;

                if (currentProfile == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No profile selected.',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Positioned(
                          bottom: 16.0,
                          right: 16.0,
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProfileScreen()),
                              );
                            },
                            tooltip: 'Add Profile',
                            child: const Icon(Icons.person_add_alt_1),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final goalHours = currentProfile.goalHours;
                final workedHours = currentProfile.workedHours;
                final progress = goalHours > 0 ? (workedHours / goalHours) : 0.0;
                final progressColor = progress <= 1.0 ? Colors.green : Colors.red; // Determine color based on progress

                // Calculate hours left
                final hoursLeft = goalHours - workedHours;

                return Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                            backgroundColor: Colors.grey[300]!,
                          ),
                          Center(
                            child: Text(
                              '${(progress * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: progressColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Hours left: ${hoursLeft.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'CaladeaItalic',
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Check if goal is achieved
                    if (progress >= 1.0) ...[
                      Text(
                        'Congratulations! You have achieved your goal!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontFamily: 'CaladeaItalic',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            if (Provider.of<UserSettings>(context).currentProfileData != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.green : Colors.green[700]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () => _pickTime(context, true),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.access_time, color: Colors.green),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _timeIn != null ? 'Time In: ${_timeIn!.format(context)}' : 'Set Time In',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.light ? Colors.red : Colors.red[700]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () => _pickTime(context, false),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(Icons.access_time, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _timeOut != null ? 'Time Out: ${_timeOut!.format(context)}' : 'Set Time Out',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFff8fa0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontFamily: 'CaladeaBold',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add spacing between the buttons
              if (_entrySaved) // Conditionally display the Add Image button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/add_image');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add Image and Description',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'CaladeaItalic',
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
