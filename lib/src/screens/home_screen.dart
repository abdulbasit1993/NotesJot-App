import 'package:flutter/material.dart';
import 'package:notesjot_app/src/services/storage_service.dart';
import 'package:notesjot_app/src/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> userNotesData = [];

  void initState() {
    print('userNotesData ==>> $userNotesData');
    getToken();
  }

  void getToken() async {
    var tokenValue = await StorageService().getFromLocal('token');

    getNotesData(tokenValue);
  }

  void getNotesData(token) async {
    dynamic notesData =
        await ApiService().fetchData('notes/getAll', token: token);

    bool successStatus = notesData['success'];

    if (successStatus == true) {
      List<dynamic> finalData = notesData['data'];
      setState(() {
        userNotesData = finalData;
      });
    }
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
      body: ListView.builder(
        itemCount: userNotesData.length,
        itemBuilder: (context, index) {
          final item = userNotesData[index];

          return ListTile(
            title: Text(item['title']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
