import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notesjot_app/src/constants/route_names.dart';
import 'package:notesjot_app/src/models/notes_model.dart';
import 'package:notesjot_app/src/services/api_service.dart';
import 'package:notesjot_app/src/services/storage_service.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  void initState() {
    isLoading = false;
  }

  Future<void> onSubmitPress() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (_formKey.currentState!.validate()) {
        var tokenValue = await StorageService().getFromLocal('token');

        String title = titleController.text;
        String content = contentController.text;

        Map<String, dynamic> payload = {"title": title, "content": content};

        final responseData =
            await apiService.postData('notes/add', payload, token: tokenValue);

        print('response data add note ==>> $responseData');

        final responseSuccess = responseData['success'];

        if (responseSuccess == true && responseData != null) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${responseData['message']}')));

          Navigator.pop(context);

          Navigator.pushReplacementNamed(context, homeRoute);
        } else {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${responseData['message']}')));
        }
      } else {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Please fill all inputs")));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error $e');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
              child: Text(
        'Create Note',
        style: TextStyle(color: Colors.white),
      ))),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: "Title"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter title";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: SizedBox(
                    height: 200,
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      controller: contentController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Content",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter content";
                        }
                        return null;
                      },
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmitPress();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(Color(0xff597cff))),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
