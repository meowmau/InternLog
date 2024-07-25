import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();

  void _addProfile(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Profile Name'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the name dialog
                  _promptForGoalHours(context, name); // Prompt for goal hours
                }
              },
              child: const Text('Next'),
            ),
          ],
        );
      },
    );
  }

  void _promptForGoalHours(BuildContext context, String name) {
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    final TextEditingController goalController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Goal Hours for $name'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter goal hours',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                final goalHours = double.tryParse(goalController.text);
                if (goalHours != null && goalHours > 0) {
                  userSettings.addProfile(name);
                  userSettings.switchProfile(name);
                  userSettings.currentProfileData!.setGoalHours(goalHours);
                  _controller.clear();
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

  void _editGoalHours(BuildContext context, UserProfile profile) {
    final TextEditingController goalController =
        TextEditingController(text: profile.goalHours.toString());

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Goal Hours for ${profile.name}'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter new goal hours',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
            TextButton(
              onPressed: () {
                final newGoalHours = double.tryParse(goalController.text);
                if (newGoalHours != null && newGoalHours > 0) {
                  profile.updateGoalHours(newGoalHours);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update Goal'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProfile(BuildContext context, String profileName) {
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Profile'),
          content: Text('Are you sure you want to delete $profileName?'),
          actions: [
            TextButton(
              onPressed: () {
                userSettings.removeProfile(profileName);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/bg1.jpg'), // Replace with your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Consumer<UserSettings>(
          builder: (context, userSettings, child) {
            final profiles = userSettings.profiles.keys.toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, index) {
                      final profileName = profiles[index];
                      final profile = userSettings.profiles[profileName]!;

                      return ListTile(
                        title: Text(profileName),
                        subtitle: Text(
                            'Goal: ${profile.goalHours.toStringAsFixed(2)} hours'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _editGoalHours(context, profile),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProfile(context, profileName),
                            ),
                          ],
                        ),
                        onTap: () {
                          userSettings.switchProfile(profileName);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProfile(context),
        tooltip: 'Add Profile',
        child: const Icon(Icons.add),
      ),
    );
  }
}
