import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_note/application/notes/note_list/notes_list_bloc.dart';
import 'package:simple_note/domain/notes/note.dart';
import 'package:simple_note/injection.dart';
import 'package:simple_note/presentation/routes/router.dart';

@RoutePage()
class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  late List<Note> _notes;
  late bool isLoading;
  final _notesListBloc = getIt<NotesListBloc>();
  @override
  void initState() {
    _notes = [];
    isLoading = true;
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    _notesListBloc.add(NotesListEvent.fetchStarted());
  }

  Future<void> openNoteView(Note? note) async {
    final shouldUpdate = await context.pushRoute(NoteEditorRoute(note: note));

    if (shouldUpdate is bool && shouldUpdate) {
      _notesListBloc.add(NotesListEvent.fetchStarted());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Note",
        onPressed: () {
          openNoteView(null);
        },
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: Text("Notes"),
      ),
      body: BlocProvider(
        create: (_) => _notesListBloc,
        child: BlocConsumer<NotesListBloc, NotesListState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              failure: (failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                        content: Text(failure.errorMessage ?? "Unknown Error")),
                  );
                isLoading = false;
              },
              loading: () {
                isLoading = true;
              },
              loaded: (notes) {
                _notes = notes;
                isLoading = false;
              },
              cacheLoaded: (notes) {
                _notes = notes;
                isLoading = false;
              },
            );
          },
          builder: (context, state) {
            return Stack(
              children: [
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: fetchData,
                    child: BlocBuilder<NotesListBloc, NotesListState>(
                      builder: (context, state) {
                        if (_notes.isEmpty && !isLoading) {
                          return SizedBox.expand(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                alignment: Alignment.center,
                                height: MediaQuery.sizeOf(context).height -
                                    kToolbarHeight,
                                child: Text("Nothing to see here"),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: _notes.length,
                          itemBuilder: (context, index) {
                            final note = _notes[index];
                            return ListTile(
                              onTap: () {
                                openNoteView(note);
                              },
                              title: Text(note.title ?? ''),
                              subtitle: Text(note.content ?? ''),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: isLoading,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
