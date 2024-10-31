import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple_note/application/notes/note/note_bloc.dart';
import 'package:simple_note/domain/notes/note.dart';
import 'package:simple_note/injection.dart';

enum _MenuItems {
  delete('Delete');

  final String label;

  const _MenuItems(this.label);
}

@RoutePage()
class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({
    super.key,
    required this.note,
  });
  final Note? note;

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final TextEditingController _noteTitleFieldController =
      TextEditingController();
  final TextEditingController _contentFieldController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _contentFocus = FocusNode();
  late Note? note;
  late bool titleEditMode;
  late bool isNewNote;

  final NoteBloc _noteBloc = getIt<NoteBloc>();

  @override
  void initState() {
    _noteTitleFieldController.text = widget.note?.title ?? "";
    _contentFieldController.text = widget.note?.content ?? "";
    isNewNote = widget.note == null;
    titleEditMode = isNewNote;
    note = widget.note ?? Note();
    super.initState();
  }

  @override
  void dispose() {
    _noteTitleFieldController.dispose();
    _contentFieldController.dispose();

    super.dispose();
  }

  Future<void> saveNote() async {
    if (note == null) return;
    note = note?.copyWith(content: _contentFieldController.text);
    if (isNewNote) {
      _noteBloc.add(NoteEvent.creatingNote(note!));
    } else {
      _noteBloc.add(NoteEvent.updatingNote(note!));
    }
  }

  Future<void> deleteNote() async {
    _noteBloc.add(NoteEvent.deletingNote(note!));
  }

  void updateTitle() {
    setState(() {
      titleEditMode = false;

      if (_noteTitleFieldController.text.isEmpty) {
        _noteTitleFieldController.text =
            DateFormat('yyyy-mm-dd').format(DateTime.now());
      }
      note = note?.copyWith(title: _noteTitleFieldController.text);
    });
  }

  void editTitle() {
    setState(() {
      titleEditMode = true;
      _titleFocus.requestFocus();
      _noteTitleFieldController.selection = TextSelection(
        baseOffset: 0,
        extentOffset: _noteTitleFieldController.text.length,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _noteBloc,
      child: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            saved: (note) {
              context.maybePop(true);
            },
            deleted: (_) {
              context.maybePop(true);
            },
            failure: (failure, note) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                      content: Text(failure.errorMessage ?? "Unknown Error")),
                );
            },
          );
        },
        builder: (context, state) {
          List<Widget> actionButtons;
          if (titleEditMode) {
            actionButtons = [
              IconButton(
                tooltip: "Done",
                onPressed: () {
                  updateTitle();
                },
                icon: Icon(Icons.check),
              ),
              IconButton(
                tooltip: "Cancel",
                onPressed: () {
                  if (_noteTitleFieldController.text.isEmpty) {
                    updateTitle();
                  } else {
                    setState(() {
                      _noteTitleFieldController.text = note?.title ?? '';
                      titleEditMode = false;
                    });
                  }
                },
                icon: Icon(Icons.close),
              )
            ];
          } else {
            actionButtons = [
              IconButton(
                tooltip: "Edit title",
                onPressed: () {
                  editTitle();
                },
                icon: Icon(Icons.edit),
              ),
              state.maybeWhen(
                loading: () => IconButton(
                  onPressed: null,
                  icon: FittedBox(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
                orElse: () => IconButton(
                  tooltip: "Save",
                  onPressed: () {
                    saveNote();
                  },
                  icon: Icon(Icons.save),
                ),
              ),
              PopupMenuButton<_MenuItems>(
                  onSelected: (_MenuItems item) {
                    switch (item) {
                      case _MenuItems.delete:
                        deleteNote();
                        break;
                      default:
                    }
                  },
                  itemBuilder: (BuildContext context) => _MenuItems.values.map(
                        (e) {
                          return PopupMenuItem(value: e, child: Text(e.label));
                        },
                      ).toList()),
            ];
          }
          return Scaffold(
            appBar: AppBar(
                title: titleEditMode
                    ? TextFormField(
                        focusNode: _titleFocus,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                        controller: _noteTitleFieldController,
                        decoration: InputDecoration(
                          hintText: "Note Title",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          updateTitle();
                        },
                      )
                    : Text(note?.title ?? "New Note"),
                actions: actionButtons),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _contentFieldController,
                focusNode: _contentFocus,
                minLines: null,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
