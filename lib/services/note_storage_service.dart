import 'package:hive/hive.dart';
import 'package:photo_safe/models/note.dart';

class NoteStorageService {

  Future<void> saveNoteInStorage(Note note) async {
    Box<Note> box = await Hive.openBox<Note>("notes");
    box.add(note);
  }

  Future<void> updateNoteInStorage(Note note) async {
    Box<Note> box = await Hive.openBox<Note>("notes");
    final List<Note> boxNotes = box.values.toList();
    for (int i = 0; i < boxNotes.length; i++) {
      if(boxNotes[i].title == note.title){
        box.putAt(i, note);
      }
    }
  }

  Future<void> deleteNoteInStorage(Note note) async {
    final Box<Note> box = Hive.box<Note>("notes");
    final List<Note> boxNotes = box.values.toList();
    for (final Note noteInBox in boxNotes) {
      if(noteInBox.title == note.title){
        box.deleteAt(boxNotes.indexOf(noteInBox));
      }
    }
  }

  Future<List<Note>> getAllNotesInStorage() async {
    Box<Note> box = await Hive.openBox<Note>("notes");
    return box.values.toList();
  }

  static final NoteStorageService _noteStorageService = NoteStorageService._internal();
  factory NoteStorageService() {
    return _noteStorageService;
  }
  NoteStorageService._internal();

}

final NoteStorageService noteStorageService = NoteStorageService();
