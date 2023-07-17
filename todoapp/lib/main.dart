import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoapp/HomePage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Taskify",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
