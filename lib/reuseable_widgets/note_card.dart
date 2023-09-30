import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final String title;
  const NoteCard(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
            color: Theme.of(context).primaryColor,
          ),
          height: 70.0,
          width: 360.0,
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
