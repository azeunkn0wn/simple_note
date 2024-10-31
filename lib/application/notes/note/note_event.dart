part of 'note_bloc.dart';

@freezed
class NoteEvent with _$NoteEvent {
  const factory NoteEvent.creatingNote(Note note) = _CreatingNote;
  const factory NoteEvent.updatingNote(Note note) = _UpdatingNote;
  const factory NoteEvent.deletingNote(Note note) = _DeletingNote;
}
