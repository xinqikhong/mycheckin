
import 'package:flutter/material.dart';
import 'package:mycheckin/view/splashscreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCheckIn',
      theme: ThemeData(
        brightness: Brightness.light),
      // ignore: prefer_const_constructors
      home: Scaffold(
        // ignore: prefer_const_constructors
        body: SplashScreen(),
      ),
    );
  }
}