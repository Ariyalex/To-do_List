import 'package:flutter/material.dart';
import 'package:to_do_list/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.grey[800],
      ),
      home: const HomeScreen(),
    );
  }
}

