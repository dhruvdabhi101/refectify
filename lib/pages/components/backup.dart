import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:refectify/pages/components/note.dart';
import 'package:refectify/pages/components/note_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupData{
  static Future<bool> backup() async{
    User? currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser == null){
      return false;
    }
    else{
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference ref = FirebaseDatabase.instance.ref('users/$userId');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Note> notes = NoteManager(prefs).getNotes();

      List<Map<String, dynamic>> notesMap = [];
      for(Note note in notes){
        notesMap.add(note.toMap());
      }
      ref.set(notesMap);
      return true;
    }
  }

  static Future<bool> restore() async{
    User? currentUser = FirebaseAuth.instance.currentUser;
    if(null == currentUser)return false;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    NoteManager noteManager = NoteManager(prefs);
    DatabaseEvent event = await ref.child('users/$userId').once();
    Object? res = event.snapshot.value;
    if(res == null)return false;
    List<dynamic> notesMap = res as List<dynamic>;
    for(Map<String, dynamic> noteMap in notesMap){
      Note note = Note.fromMap(noteMap);
      noteManager.saveNote(note);
    }

    return true;
  }
}