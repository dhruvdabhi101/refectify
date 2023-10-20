import 'package:flutter/material.dart';
import 'package:refectify/pages/components/note.dart';
import 'package:refectify/pages/components/note_manager.dart';
import 'package:refectify/reuseable_widgets/note_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Note> notes = [
    Note(
      title: 'Meeting Notes',
      creationDate: DateTime.now(),
      content: 'Discuss project timelines and goals.',
    ),
  ];

  TextEditingController searchController = TextEditingController();
  List<Note> filteredNotesList = [];

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  getNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(prefs);
    List<Note> notes = noteManager.getNotes();
    setState(() {
      this.notes = notes;
      filteredNotesList = notes;
    });
  }
  void onSearchTextChanged(String query) {
    List<Note> filteredNotes = [];

    if (query.isEmpty) {
      filteredNotes = notes; // Show all notes if the query is empty.
    } else {
      query = query.toLowerCase();
      filteredNotes = notes.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      filteredNotesList = filteredNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search Notes',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: onSearchTextChanged,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotesList.length,
              itemBuilder: (context, index) {
                return NoteCard(filteredNotesList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
