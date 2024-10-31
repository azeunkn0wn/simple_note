import 'package:simple_note/infrastructure/notes/note_dto.dart';

abstract class INoteLocalService {
  Future<List<NoteDto>> fetch();
  Future<NoteDto?> fetchOne(String id);
  Future<void> saveNotes(List<NoteDto> notes);
  Future<void> add(NoteDto note);
  Future<void> update(NoteDto updatedNote);
  Future<void> delete(String id);
}
