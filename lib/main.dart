import 'package:flutter/material.dart';
import 'package:notesjot_app/src/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.blue,
            appBarTheme: AppBarTheme(color: Colors.blue)),
        title: 'NotesJot',
        home: LoginScreen());
  }
}
