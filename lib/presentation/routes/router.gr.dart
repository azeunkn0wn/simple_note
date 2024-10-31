// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

/// generated route for
/// [NoteEditorPage]
class NoteEditorRoute extends PageRouteInfo<NoteEditorRouteArgs> {
  NoteEditorRoute({
    Key? key,
    required Note? note,
    List<PageRouteInfo>? children,
  }) : super(
          NoteEditorRoute.name,
          args: NoteEditorRouteArgs(
            key: key,
            note: note,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteEditorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<NoteEditorRouteArgs>();
      return NoteEditorPage(
        key: args.key,
        note: args.note,
      );
    },
  );
}

class NoteEditorRouteArgs {
  const NoteEditorRouteArgs({
    this.key,
    required this.note,
  });

  final Key? key;

  final Note? note;

  @override
  String toString() {
    return 'NoteEditorRouteArgs{key: $key, note: $note}';
  }
}

/// generated route for
/// [NotesListPage]
class NotesListRoute extends PageRouteInfo<void> {
  const NotesListRoute({List<PageRouteInfo>? children})
      : super(
          NotesListRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotesListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NotesListPage();
    },
  );
}
