import 'package:flutter/material.dart';
import 'screen/login.dart'; // Import the LoginPage widget from login.dart
// Make sure the path and file name are correct and that LoginPage is defined in login.dart


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      home:loginpage(),
    );
  }
}
