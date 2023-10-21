/// A page that displays a single note with its title, creation date, and content.
/// Allows the user to delete the note and share its content as a PDF.
/// Uses [quill.QuillEditor] to display the note's content.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:refectify/pages/components/note_manager.dart';
import 'package:refectify/pages/components/pdftool.dart';
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

  /// Deletes the current note from the [SharedPreferences] and navigates back to the home page.
  deleteNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(prefs);
    noteManager.deleteNote(note);
    if (!mounted) return;
    Navigator.popAndPushNamed(context, '/home');
  }

  /// Generates a PDF file with the note's title, creation date, and content and shares it.
  shareNote() async {
    String noteContent =
        quill.Document.fromJson(jsonDecode(note.content)).toPlainText();
    PDFTools.generateCenteredText(
        '${note.title}\nCreated at:${note.content}\n$noteContent\n\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteNote();
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              shareNote();
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
