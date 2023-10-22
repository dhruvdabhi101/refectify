/// A widget that displays a note card with a title.
///
/// This widget takes a [Note] object as input and displays its title in a card.
/// When the card is tapped, it navigates to the '/noteHome' route with the [Note] object as an argument.
import 'package:flutter/material.dart';
import 'package:refectify/pages/components/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard(this.note, {super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/noteHome', arguments: note),
      child: Padding(
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
              note.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
