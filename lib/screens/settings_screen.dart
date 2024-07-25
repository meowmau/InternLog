import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<UserSettings>(
        builder: (context, userSettings, child) {
          return ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: userSettings.darkMode,
              onChanged: (value) {
                userSettings.toggleDarkMode();
              },
            ),
          );
        },
      ),
    );
  }
}