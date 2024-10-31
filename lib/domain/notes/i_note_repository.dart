import 'package:dartz/dartz.dart';
import 'package:simple_note/domain/core/failure.dart';
import 'package:simple_note/domain/notes/note.dart';

abstract class INoteRepository {
  Future<Either<Failure, List<Note>>> fetch([String? id]);
  Future<Either<Failure, List<Note>>> fetchCached();
  Future<Either<Failure, Note>> create(Note note);
  Future<Either<Failure, Note>> update(Note note);
  Future<Either<Failure, Note>> delete(Note note);
}
