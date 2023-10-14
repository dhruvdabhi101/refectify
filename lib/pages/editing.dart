import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final TextEditingController titleController = TextEditingController();
  final quill.QuillController _controller = quill.QuillController(
    document: quill.Document(),
    selection: const TextSelection.collapsed(offset: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
        ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              final title = titleController.text;
              final noteText = _controller.document.toPlainText();
              print('Title: $title');
              print('Note: $noteText');
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
              'Title',
              style: Theme.of(context).primaryTextTheme.bodyLarge,
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelStyle: Theme.of(context).primaryTextTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: quill.QuillToolbar.basic(controller: _controller),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                ),
                child: quill.QuillEditor.basic(
                  controller: _controller,
                  readOnly: false, 
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
