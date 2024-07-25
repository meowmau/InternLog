// my_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';
import 'goal_screen.dart';
import 'history_screen.dart';
import 'gallery_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showGoalDialog(context);
    });
  }

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

  void _logout(BuildContext context) {
    Provider.of<UserSettings>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFF001c12),
              fontSize: 18,
              fontFamily: 'CaladeaBold',
            ),
          ),
          elevation: 0.0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFff8fa0),
                  Color(0xFFffc7cf),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF001c12)),
          bottom: const TabBar(
            unselectedLabelColor: Color(0xFF282828),
            labelColor: Color(0xFF000e09),
            tabs: [
              Tab(icon: Icon(Icons.hourglass_bottom_rounded)),
              Tab(icon: Icon(Icons.history)),
              Tab(icon: Icon(Icons.image)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GoalScreen(),
            HistoryScreen(),
            GalleryScreen(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFffc7cf),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Color(0xFF001c12),
                    fontFamily: 'Aclonica',
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: 'Aclonica',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  'Settings',
                  style: TextStyle(
                    fontFamily: 'Aclonica',
                    fontSize: 16,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Aclonica',
                    fontSize: 16,
                  ),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
