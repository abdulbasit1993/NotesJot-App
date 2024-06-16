import 'package:flutter/material.dart';
import 'package:notesjot_app/src/screens/home_screen.dart';
import 'package:notesjot_app/src/screens/login_screen.dart';
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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()));
      });
    } else {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()));
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
