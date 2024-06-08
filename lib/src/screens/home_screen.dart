import 'package:flutter/material.dart';
import 'package:notesjot_app/src/services/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    getToken();
  }

  void getToken() async {
    var tokenValue = await StorageService().getFromLocal('token');

    print('Token (HomeScreen) : $tokenValue');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text(
        'Home',
        style: TextStyle(color: Colors.white),
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
