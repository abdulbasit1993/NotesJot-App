import 'package:flutter/material.dart';
import 'package:notesjot_app/src/models/notes_model.dart';
import 'package:notesjot_app/src/screens/create_note_screen.dart';
import 'package:notesjot_app/src/screens/note_detail_screen.dart';
import 'package:notesjot_app/src/services/storage_service.dart';
import 'package:notesjot_app/src/services/api_service.dart';
import 'package:intl/intl.dart';

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

    print('response data getNotes ==>> $notesData');

    Note note = Note.fromJson(notesData);

    if (note.success) {
      return note.data;
    } else {
      throw Exception(note.message);
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      notesFuture = getNotesData();
    });
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: FutureBuilder<List<Datum>>(
          future: notesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              final notes = snapshot.data;
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  itemCount: notes?.length,
                  itemBuilder: (context, index) {
                    final note = notes?[index];
                    final noteId = note?.id;

                    final DateFormat formatter =
                        DateFormat('MMM d, y - h:mm a');
                    final formattedDate = formatter.format(note!.createdAt);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NoteDetailScreen(
                                      noteId: noteId,
                                    )));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                note!.title,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(note!.content,
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
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
                      builder: (context) => const CreateNoteScreen()))
              .then((value) {
            setState(() {
              getNotesData();
            });
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff597cff),
      ),
    );
  }
}
