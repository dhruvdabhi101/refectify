import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  QuillController _controller = QuillController.basic();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child:
                    QuillEditor.basic(controller: _controller, readOnly: false),
              ),
            ),
            QuillToolbar.basic(
              controller: _controller,
            ),
          ],
        ),
      ),
    );
  }
}
