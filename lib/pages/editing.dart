import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:refectify/pages/components/note.dart';
import 'package:refectify/pages/components/note_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final quill.QuillController _controller = quill.QuillController.basic();

  addNote(String title, String noteText) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(sharedPreferences);
    Note note = Note(
      title: title,
      content: noteText,
      creationDate: DateTime.now(),
    );
    noteManager.saveNote(note);
    if (!mounted) return;
    Navigator.popAndPushNamed(context, '/home');
  }

  Future<void> saveClick(BuildContext context, String noteText) async {
    String title = '';
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Title'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: const InputDecoration(hintText: "Enter title..."),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('Save'),
                onPressed: () {
                  setState(() {
                    addNote(title, noteText);
                    Navigator.popAndPushNamed(context, '/home');
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              final noteText = jsonEncode( _controller.document.toDelta().toJson());
              saveClick(context, noteText);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              quill.QuillToolbar.basic(
                controller: _controller,
              ),
              Expanded(
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  readOnly: false,
                  autoFocus: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
