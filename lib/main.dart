import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_settings.dart';
import 'providers/custom_image_provider.dart'; 
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/add_image_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/edit_image_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserSettings()),
        ChangeNotifierProvider(create: (context) => CustomImageProvider()), // Use CustomImageProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSettings>(
      builder: (context, userSettings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Internship Time Tracker',
          theme: userSettings.darkMode
              ? ThemeData.dark().copyWith(
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(
                      fontFamily: 'CaladeaRegular',
                    ),
                    titleLarge: TextStyle(
                      fontFamily: 'Aclonica',
                    ),
                  ),
                )
              : ThemeData.light().copyWith(
                  textTheme: const TextTheme(
                    bodyMedium: TextStyle(
                      fontFamily: 'CaladeaRegular',
                    ),
                    titleLarge: TextStyle(
                      fontFamily: 'Aclonica',
                    ),
                  ),
                ),
          home: userSettings.isLoggedIn
              ? const MyHomePage(title: 'Internship Time Tracker')
              : const LoginScreen(),
          routes: {
            '/home': (context) =>
                const MyHomePage(title: 'Internship Time Tracker'),
            '/profile': (context) => const ProfileScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/login': (context) => const LoginScreen(),
            '/add_image': (context) => const AddImageScreen(),
            '/gallery': (context) => const GalleryScreen(),
          },
        );
      },
    );
  }
}
