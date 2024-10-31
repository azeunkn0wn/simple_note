// Create a Note Model: Use Freezed to define a Note model
// with fields like id, title, and content.

import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';

@freezed
class Note with _$Note {
  const Note._();
  const factory Note({
    final String? id,
    final String? title,
    final String? content,
    final DateTime? createdAt,
    final bool? isDeleted,
    final DateTime? lastModifiedAt,
  }) = _Note;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => Object.hashAll([id, title, content]);

  Note difference(Note oldNote) {
    return Note(
      id: id,
      title: title == oldNote.title ? null : title,
      content: content == oldNote.title ? null : title,
    );
  }
}
