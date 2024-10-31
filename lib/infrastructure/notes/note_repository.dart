import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:simple_note/domain/core/failure.dart';
import 'package:simple_note/domain/notes/i_note_local_service.dart';
import 'package:simple_note/domain/notes/i_note_remote_service.dart';
import 'package:simple_note/domain/notes/i_note_repository.dart';
import 'package:simple_note/domain/notes/note.dart';
import 'package:simple_note/infrastructure/core/common_api_error_handler.dart';
import 'package:simple_note/infrastructure/notes/note_dto.dart';

@Injectable(
  as: INoteRepository,
  env: ['dev'],
)
class NoteRepository implements INoteRepository {
  final INoteRemoteService _remoteService;
  final INoteLocalService _localService;

  NoteRepository(
    this._remoteService,
    this._localService,
  );

  @override
  Future<Either<Failure, List<Note>>> fetch([String? id]) async {
    try {
      final data = await _remoteService.fetch(id);
      // cache notes
      _localService.saveNotes(data);

      final notes = data.map(
        (noteDto) {
          return noteDto.toDomain();
        },
      ).toList();

      return right(notes);
    } catch (e) {
      return left(commonErrorHandler(e));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> fetchCached() async {
    try {
      final data = await _localService.fetch();
      final notes = data.map(
        (noteDto) {
          return noteDto.toDomain();
        },
      ).toList();

      return right(notes);
    } catch (e) {
      return left(Failure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Note>> create(Note note) async {
    try {
      final data = await _remoteService.create(NoteDto.fromDomain(note));
      // cache
      await _localService.add(data);
      return right(data.toDomain());
    } catch (e) {
      return left(commonErrorHandler(e));
    }
  }

  @override
  Future<Either<Failure, Note>> delete(Note note) async {
    try {
      final data = await _remoteService.delete(note.id!);
      // cache
      await _localService.delete(note.id!);
      return right(data.toDomain());
    } catch (e) {
      return left(commonErrorHandler(e));
    }
  }

  @override
  Future<Either<Failure, Note>> update(Note note) async {
    try {
      final data = await _remoteService.update(NoteDto.fromDomain(note));
      // cache
      await _localService.update(data);
      return right(data.toDomain());
    } catch (e) {
      return left(commonErrorHandler(e));
    }
  }
}
