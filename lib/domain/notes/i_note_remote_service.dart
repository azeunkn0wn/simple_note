import 'package:simple_note/infrastructure/notes/note_dto.dart';

abstract class INoteRemoteService {
  Future<List<NoteDto>> fetch([String? id]);
  Future<NoteDto> create(NoteDto note);
  Future<NoteDto> update(NoteDto note);
  Future<NoteDto> delete(String id);
}
