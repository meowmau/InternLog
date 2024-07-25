import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';
import Lottie.asset('assets/animations/Congratulations.json')


  void _showGoalDialog(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    final TextEditingController controller = TextEditingController();

    final currentProfile = userSettings.currentProfileData;
    if (currentProfile != null && currentProfile.goalHours == 0) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Set Your Goal Hours'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter your goal hours',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final goalHours = double.tryParse(controller.text);
                  if (goalHours != null && goalHours > 0) {
                    currentProfile.setGoalHours(goalHours);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Set Goal'),
              ),
            ],
          );
        },
      );
    }
  }