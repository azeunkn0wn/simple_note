part of 'notes_list_bloc.dart';

@freezed
class NotesListEvent with _$NotesListEvent {
  const factory NotesListEvent.fetchStarted() = _FetchStarted;
  const factory NotesListEvent.fetchCachedStarted() = _FetchCachedStarted;
}
