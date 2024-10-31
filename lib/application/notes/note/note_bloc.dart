import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:simple_note/domain/core/failure.dart';
import 'package:simple_note/domain/notes/i_note_repository.dart';
import 'package:simple_note/domain/notes/note.dart';

part 'note_bloc.freezed.dart';
part 'note_event.dart';
part 'note_state.dart';

@injectable
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final INoteRepository _repository;
  NoteBloc(this._repository) : super(_Initial()) {
    on<_CreatingNote>(_creatingNote);
    on<_UpdatingNote>(_updatingNote);
    on<_DeletingNote>(_deletingNote);
  }
  Future<void> _creatingNote(NoteEvent event, Emitter<NoteState> emit) async {
    emit(NoteState.loading());
    final failureOrSuccess = await _repository.create(event.note);

    failureOrSuccess.fold(
      (l) async {
        emit(NoteState.failure(l, event.note));
      },
      (r) {
        emit(NoteState.saved(r));
      },
    );
  }

  Future<void> _updatingNote(NoteEvent event, Emitter<NoteState> emit) async {
    emit(NoteState.loading());
    final failureOrSuccess = await _repository.update(event.note);

    failureOrSuccess.fold(
      (l) async {
        emit(NoteState.failure(l, event.note));
      },
      (r) {
        emit(NoteState.saved(r));
      },
    );
  }

  Future<void> _deletingNote(NoteEvent event, Emitter<NoteState> emit) async {
    emit(NoteState.loading());
    final failureOrSuccess = await _repository.delete(event.note);

    failureOrSuccess.fold(
      (l) async {
        emit(NoteState.failure(l, event.note));
      },
      (r) {
        emit(NoteState.deleted(r));
      },
    );
  }
}
