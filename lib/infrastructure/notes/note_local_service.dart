import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_note/domain/notes/i_note_local_service.dart';
import 'package:simple_note/infrastructure/notes/note_dto.dart';

@Injectable(as: INoteLocalService, env: ['dev'])
class NoteLocalService extends INoteLocalService {
  final SharedPreferences prefs;
  NoteLocalService(this.prefs);
  static const _notesKey = 'notes';

  @override
  Future<List<NoteDto>> fetch() async {
    final String? notesJson = prefs.getString(_notesKey);

    if (notesJson == null) return [];
    final decoded = List<Map<String, dynamic>>.from(jsonDecode(notesJson));

    return decoded.map(
      (e) {
        return NoteDto.fromJson(e);
      },
    ).toList();
  }

  @override
  Future<NoteDto?> fetchOne(String id) async {
    final notes = await fetch();
    return notes.firstWhereOrNull(
      (element) {
        return element.id == id;
      },
    );
  }

  @override
  Future<void> add(NoteDto note) async {
    final notes = await fetch();
    notes.add(note);
    await saveNotes(notes);
  }

  @override
  Future<void> delete(String id) async {
    final notes = await fetch();
    notes.removeWhere((note) => note.id == id);
    await saveNotes(notes);
  }

  @override
  Future<void> update(NoteDto updatedNote) async {
    final notes = await fetch();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);

    if (index != -1) {
      notes[index] = updatedNote;
      await saveNotes(notes);
    }
    // just append if it doesn't exist for some reason
    add(updatedNote);
  }

  @override
  Future<void> saveNotes(List<NoteDto> notes) async {
    final notesJson = jsonEncode(notes);

    await prefs.setString(_notesKey, notesJson);
  }
}
