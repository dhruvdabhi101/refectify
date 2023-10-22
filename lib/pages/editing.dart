/// FILEPATH: /D:/Sem5/refectify/lib/pages/editing.dart
///
/// This file contains the implementation of the [EditorPage] widget, which is a stateful widget that
/// displays a Quill editor for creating and editing notes. The widget allows the user to enter a title
/// and content for the note, and save it to the device's local storage using [SharedPreferences].
///
/// The [EditorPage] widget uses the [quill.QuillController] to manage the state of the Quill editor,
/// and the [quill.QuillToolbar] and [quill.QuillEditor] widgets to display the editor UI.
///
/// The [EditorPage] widget also uses the [NoteManager] class to save the note to local storage, and
/// the [Note] class to represent the note data.
///
/// To use this widget, simply create an instance of [EditorPage] and add it to your widget tree.
/// You can also pass in an optional [key] parameter to uniquely identify the widget.
///
/// Example:
///
/// ```dart
/// EditorPage(key: UniqueKey())
/// ```

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
