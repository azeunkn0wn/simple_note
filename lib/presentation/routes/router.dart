import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_note/domain/notes/note.dart';
import 'package:simple_note/presentation/pages/notes/note_editor/note_editor_page.dart';
import 'package:simple_note/presentation/pages/notes/notes_list/notes_list_page.dart';

part 'router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => RouteType.custom(
        transitionsBuilder: TransitionsBuilders.fadeIn,
        durationInMilliseconds: 100,
        reverseDurationInMilliseconds: 100,
      );
  @override
  List<AutoRoute> get routes => [
        AutoRoute(path: '/notesList', page: NotesListRoute.page, initial: true),
        AutoRoute(
          path: '/noteEditor',
          page: NoteEditorRoute.page,
        ),
      ];
}
