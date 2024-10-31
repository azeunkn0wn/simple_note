import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_note/domain/notes/note.dart';
import 'package:simple_note/infrastructure/core/utilities/date_time_format.dart';

part 'note_dto.freezed.dart';
part 'note_dto.g.dart';

@freezed
class NoteDto with _$NoteDto {
  const NoteDto._();
  @JsonSerializable(explicitToJson: true)
  factory NoteDto({
    final String? id,
    final String? title,
    final String? content,
    @JsonKey(fromJson: dateTimeOrNull, toJson: toUtcIso8601String)
    final DateTime? createdAt,
    // final DateTime? deletedAt, // MockAPI doesn't give an option to make this null
    final bool? isDeleted,
    @JsonKey(fromJson: dateTimeOrNull, toJson: toUtcIso8601String)
    final DateTime? lastModifiedAt,
  }) = _NoteDto;

  factory NoteDto.fromJson(Map<String, dynamic> json) =>
      _$NoteDtoFromJson(json);

  Note toDomain() {
    return Note(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      isDeleted: isDeleted,
      lastModifiedAt: lastModifiedAt,
    );
  }

  factory NoteDto.fromDomain(Note note) {
    return NoteDto(
      id: note.id,
      title: note.title,
      content: note.content,
      createdAt: note.createdAt,
      isDeleted: note.isDeleted,
      lastModifiedAt: note.lastModifiedAt,
    );
  }
}
