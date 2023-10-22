/// A class that manages notes using shared preferences.
///
/// This class provides methods to get, delete and save notes.
/// It uses shared preferences to store notes as a list of strings in JSON format.
import 'package:shared_preferences/shared_preferences.dart';
import 'note.dart';
import 'dart:convert';class NoteManager {
  final SharedPreferences _prefs;
  final String notesKey = 'notes';

  NoteManager(this._prefs);

  /// Returns a list of notes.
  ///
  /// If there are no notes, an empty list is returned.
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

  /// Deletes a note.
  ///
  /// The note is identified by its [id].
  void deleteNote(Note note) {
    final notes = getNotes();
    for (int i = 0; i < notes.length; i++) {
      if (notes[i].id == note.id) {
        notes.removeAt(i);
        break;
      }
    }
    final noteStrings = notes.map((note) => json.encode(note.toMap())).toList();
    _prefs.setStringList(notesKey, noteStrings);
  }

  /// Saves a note.
  ///
  /// The [note] is added to the list of notes.
  void saveNote(Note note) {
    final notes = getNotes();
    notes.add(note);
    final noteStrings = notes.map((note) => json.encode(note.toMap())).toList();
    _prefs.setStringList(notesKey, noteStrings);
  }
}
