import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesjot_app/src/models/notes_model.dart';
import 'package:notesjot_app/src/arguments/note_data.dart';
import 'package:notesjot_app/src/models/single_note_model.dart';
import 'package:notesjot_app/src/screens/home_screen.dart';
import 'package:notesjot_app/src/services/api_service.dart';
import 'package:notesjot_app/src/services/storage_service.dart';

class NoteDetailScreen extends StatefulWidget {
  var noteId;

  NoteDetailScreen({super.key, this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Future<SingleNote> _noteFuture;
  final DateFormat formatter = DateFormat('EEEE, d MMMM y, hh:mm a');

  @override
  void initState() {
    super.initState();
    _noteFuture = _fetchNoteDetails();
  }

  Future<SingleNote> _fetchNoteDetails() async {
    try {
      var tokenValue = await StorageService().getFromLocal('token');

      final response = await ApiService()
          .fetchData('notes/getSingle/${widget.noteId}', token: tokenValue);

      return SingleNote.fromJson(response);
    } catch (error) {
      throw Exception('Error fetching note details: $error');
    }
  }

  Future<void> onDeletePress() async {
    try {
      var tokenValue = await StorageService().getFromLocal('token');

      final response = await ApiService()
          .deleteData('notes/delete/${widget.noteId}', token: tokenValue);

      print('response data deleteNote ==>> $response');

      if (response != null) {
        final responseStatus = response['success'];

        if (responseStatus == true) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${response['message']}')));
          Navigator.pop(context);

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen()));
        }
      }
    } catch (error) {
      throw Exception('Error deleting note: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    String noteId = widget.noteId.toString();

    return Scaffold(
        appBar: AppBar(
            title: const Center(
                child: Text(
          'Note Detail',
          style: TextStyle(color: Colors.white),
        ))),
        body: FutureBuilder<SingleNote>(
          future: _noteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            }

            final noteData = snapshot.data!.data;

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return SimpleDialog(
                                  title: const Center(
                                      child: Text('Delete Note',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold))),
                                  children: [
                                    Center(
                                      child: const Text(
                                          'Are you sure you want to delete this note?',
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                        Color(0xff597cff))),
                                            onPressed: () {
                                              onDeletePress();
                                            },
                                            child: const Text('Yes',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white))),
                                        SizedBox(width: 15),
                                        ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('No',
                                                style: TextStyle(fontSize: 18)))
                                      ],
                                    )
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete),
                        tooltip: 'Delete',
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit',
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    noteData.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    formatter.format(noteData.createdAt),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    noteData.content,
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          },
        ));
  }
}
