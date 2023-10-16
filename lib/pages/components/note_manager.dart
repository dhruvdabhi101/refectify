import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';
import 'dart:convert';

class NoteManager {
  final SharedPreferences _prefs;
  final String notesKey = 'notes';

  NoteManager(this._prefs);

  List<Note> getNotes() {
    final notes = _prefs.getStringList(notesKey);
    if (notes == null) {
      return [];
    }

    return notes.map((noteJson) {
      final noteMap = Map<String, dynamic>.from(json.decode(noteJson));
      return Note.fromMap(noteMap);
    }).toList();
  }

  void saveNote(Note note) {
    final notes = getNotes();
    notes.add(note);
    final noteStrings = notes.map((note) => json.encode(note.toMap())).toList();
    _prefs.setStringList(notesKey, noteStrings);
  }
}
