import 'package:flutter/material.dart';
import 'package:notesjot_app/src/constants/route_names.dart';
import 'package:notesjot_app/src/screens/splash_screen.dart';
import 'package:notesjot_app/src/screens/login_screen.dart';
import 'package:notesjot_app/src/screens/home_screen.dart';
import 'package:notesjot_app/src/screens/create_note_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case createNoteRoute:
        return MaterialPageRoute(builder: (_) => const CreateNoteScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                    body: Center(
                  child: Text('No route defined for ${settings.name}'),
                )));
    }
  }
}
