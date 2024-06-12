import 'package:flutter/material.dart';
import 'package:notesjot_app/src/constants/route_names.dart';
import 'package:notesjot_app/src/models/notes_model.dart';
import 'package:notesjot_app/src/screens/create_note_screen.dart';
import 'package:notesjot_app/src/services/storage_service.dart';
import 'package:notesjot_app/src/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Datum>> notesFuture = getNotesData();

  void initState() {
    getNotesData();
  }

  static Future<List<Datum>> getNotesData() async {
    var tokenValue = await StorageService().getFromLocal('token');

    Map<String, dynamic> notesData =
        await ApiService().fetchData('notes/getAll', token: tokenValue);

    Note note = Note.fromJson(notesData);

    if (note.success) {
      return note.data;
    } else {
      throw Exception(note.message);
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
      body: Center(
        child: FutureBuilder<List<Datum>>(
          future: notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              final notes = snapshot.data;
              return buildNotes(notes);
            } else {
              return const Text('No Data Available');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateNoteScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

Widget buildNotes(List<Datum>? notes) {
  return ListView.builder(
    itemCount: notes?.length,
    itemBuilder: (context, index) {
      final note = notes?[index];
      return ListTile(
        title: Text(note!.title),
        subtitle: Text(note!.content),
      );
    },
  );
}
