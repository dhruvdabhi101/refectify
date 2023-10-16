import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:refectify/pages/components/note_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  Note note = Note(
    title: '',
    content: '[{"insert":"Hello World"}, {"insert":"\\n"}]',
    creationDate: DateTime.now(),
  );

  @override
  initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    note = ModalRoute.of(context)!.settings.arguments as Note;
  }
  deleteNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(prefs);
    noteManager.deleteNote(note);
    if(!mounted) return;
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteNote();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Created on ${note.creationDate.toString()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: quill.QuillEditor.basic(
                controller: quill.QuillController(
                  document: quill.Document.fromJson(jsonDecode(note.content)),
                  selection: const TextSelection.collapsed(offset: 0),
                ),
                readOnly: true,
                expands: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
