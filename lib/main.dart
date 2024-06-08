import 'package:flutter/material.dart';
import 'package:notesjot_app/src/routes/route_generator.dart';
import 'package:notesjot_app/src/constants/route_names.dart';

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
            appBarTheme: AppBarTheme(color: Color(0xff597cff))),
        title: 'NotesJot',
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: splashRoute);
  }
}
