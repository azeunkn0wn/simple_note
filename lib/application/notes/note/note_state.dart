part of 'note_bloc.dart';

@freezed
class NoteState with _$NoteState {
  const factory NoteState.initial() = _Initial;
  const factory NoteState.loading() = _Loading;
  const factory NoteState.saved(Note note) = _Saved;
  const factory NoteState.deleted(Note note) = _Deleted;
  const factory NoteState.failure(Failure failure, Note note) = _Failure;
}
