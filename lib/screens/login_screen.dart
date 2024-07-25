import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String _hardcodedUsername = '1';
  final String _hardcodedPassword = '1';

  void _login() {
    // Check if the username and password match the hardcoded values
    if (_usernameController.text == _hardcodedUsername &&
        _passwordController.text == _hardcodedPassword) {
      Provider.of<UserSettings>(context, listen: false).login();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show an error message if the username or password is incorrect
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Incorrect username or password.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/images/bg.jpg', // Adjust path as per your asset location
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      'assets/images/logo.jpg', // Replace with your logo asset
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Internship Time Tracker\nLogin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'CaladeaBold',
                      fontSize: 30,
                      color: Color.fromARGB(
                          0, 0, 150, 135), // Text color adjusted for contrast
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _usernameController,
                    style: const TextStyle(
                        color:
                            Colors.black), // Text color adjusted for contrast
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                          color:
                              Colors.teal), // Label color adjusted for contrast
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      fillColor: Colors.white, // Background color for text box
                      filled: true, // Enable background color
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    style: const TextStyle(
                        color:
                            Colors.black), // Text color adjusted for contrast
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color:
                              Colors.teal), // Label color adjusted for contrast
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      fillColor: Colors.white, // Background color for text box
                      filled: true, // Enable background color
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor: Colors.teal, // Text color
                      side:
                          const BorderSide(color: Colors.teal), // Border color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50, // Increased padding for larger button
                        vertical: 20, // Increased padding for larger button
                      ),
                    ),
                    onPressed: _login,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Bold text
                        fontSize: 18, // Increased font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
