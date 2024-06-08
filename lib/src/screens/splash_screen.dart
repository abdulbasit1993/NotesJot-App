import 'package:flutter/material.dart';
import 'package:notesjot_app/src/constants/route_names.dart';
import 'package:notesjot_app/src/services/storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    isAuthenticated();
  }

  void isAuthenticated() async {
    var tokenValue = await StorageService().getFromLocal('token');

    if (tokenValue.isEmpty) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed(loginRoute);
      });
    } else {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.of(context).pushReplacementNamed(homeRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff597cff),
        body:
            Center(child: Image.asset('lib/assets/images/NotesJot-Logo.png')));
  }
}
