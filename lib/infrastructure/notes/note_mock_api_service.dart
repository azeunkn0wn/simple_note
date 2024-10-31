import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:simple_note/domain/core/endpoints.dart';
import 'package:simple_note/domain/notes/i_note_remote_service.dart';
import 'package:simple_note/infrastructure/core/network_exception.dart';
import 'package:simple_note/infrastructure/core/utilities/api_url_builder.dart';
import 'package:simple_note/infrastructure/core/utilities/date_time_format.dart';
import 'package:simple_note/infrastructure/notes/note_dto.dart';

@Injectable(as: INoteRemoteService, env: ['dev'])
class NoteMockApiRemoteService extends EndpointBuilder
    implements INoteRemoteService {
  final http.Client _client;

  NoteMockApiRemoteService(this._client);

  @override
  String get endpoint => Endpoints.notes;

  @override
  Future<List<NoteDto>> fetch([String? id]) async {
    final response = await _client.get(apiUrl(id));

    if (response.statusCode != 200) {
      throw RestApiException(response.statusCode, "Failed to fetch notes");
    }

    final decodedResponse =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));

    final notes = decodedResponse.map(
      (e) {
        return NoteDto.fromJson(e);
      },
    ).toList();
    // simulating server excluding soft deleted notes
    notes.removeWhere(
      (e) {
        return e.isDeleted ?? false;
      },
    );
    // simulating server sorting notes by last modified datetime
    notes.sort(
      (a, b) {
        if (a.lastModifiedAt == null || b.lastModifiedAt == null) return 0;
        return b.lastModifiedAt!.compareTo(a.lastModifiedAt!);
      },
    );
    return notes;
  }

  @override
  Future<NoteDto> create(NoteDto note) async {
    note = note.copyWith(
      // simulate server timestamp
      createdAt: DateTime.now(),
      lastModifiedAt: DateTime.now(),
      isDeleted: false,
    );
    final body = note.toJson();
    final response = await http.post(
      apiUrl(),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 201) {
      throw RestApiException(response.statusCode, "Failed to save");
    }
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return NoteDto.fromJson(decodedResponse);
  }

  @override
  Future<NoteDto> update(NoteDto note) async {
    final body = {
      "id": "1",
      "title": note.title,
      "content": note.content,
      "lastModifiedAt":
          DateTime.now().toUtcIso8601String(), // simulate server timestamp
    };
    final response = await http.put(
      apiUrl(note.id),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw RestApiException(response.statusCode, "Failed to update");
    }
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return NoteDto.fromJson(decodedResponse);
  }

  @override
  Future<NoteDto> delete(String id) async {
    final response = await http.put(
      apiUrl(id),
      body: jsonEncode({"isDeleted": true}),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode != 200) {
      throw RestApiException(response.statusCode, "Failed to delete");
    }
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    return NoteDto.fromJson(decodedResponse);
  }
}
