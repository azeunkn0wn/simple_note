import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:simple_note/domain/core/failure.dart';
import 'package:simple_note/domain/notes/i_note_repository.dart';
import 'package:simple_note/domain/notes/note.dart';

part 'notes_list_bloc.freezed.dart';
part 'notes_list_event.dart';
part 'notes_list_state.dart';

@injectable
class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  final INoteRepository _repository;

  NotesListBloc(this._repository) : super(NotesListState.initial()) {
    on<_FetchStarted>(_fetchNotes);
    on<_FetchCachedStarted>(_fetchCachedNotes);
  }

  Future<void> _fetchNotes(
      NotesListEvent event, Emitter<NotesListState> emit) async {
    emit(NotesListState.loading());
    final failureOrSuccess = await _repository.fetch();

    failureOrSuccess.fold(
      (l) async {
        emit(NotesListState.failure(l));
        add(NotesListEvent.fetchCachedStarted());
      },
      (r) {
        emit(NotesListState.loaded(r));
      },
    );
  }

  Future<void> _fetchCachedNotes(
      NotesListEvent event, Emitter<NotesListState> emit) async {
    emit(NotesListState.loading());
    final failureOrSuccess = await _repository.fetchCached();

    failureOrSuccess.fold(
      (l) {
        emit(NotesListState.failure(l));
      },
      (r) {
        emit(NotesListState.loaded(r));
      },
    );
  }
}
