part of 'notes_list_bloc.dart';

@freezed
class NotesListState with _$NotesListState {
  const factory NotesListState.initial() = _Initial;
  const factory NotesListState.loading() = _Loading;
  const factory NotesListState.loaded(List<Note> notes) = _Loaded;
  const factory NotesListState.cacheLoaded(List<Note> notes) = _CacheLoaded;
  const factory NotesListState.failure(Failure failure) = _Failure;
}
