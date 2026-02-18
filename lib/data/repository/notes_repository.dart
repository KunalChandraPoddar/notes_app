import 'package:notes_app/data/constants/app_strings.dart';

import '../local/database/app_database.dart';
import '../remote/note_remote_data_source.dart';
import 'package:drift/drift.dart' as drift;

class NotesRepository {
  final AppDatabase database;
  final NoteRemoteDataSource remote;

  NotesRepository(this.database, this.remote);

  Stream<List<Note>> watchNotes() {
    return database.select(database.notes).watch();
  }

  Future<void> createNote(String title, String content) async {
    final id = DateTime.now().millisecondsSinceEpoch;

    await database.into(database.notes).insert(
          NotesCompanion(
            id: drift.Value(id),
            title: drift.Value(title),
            content: drift.Value(content),
            createdAt: drift.Value(DateTime.now()),
          ),
        );

    await database.addToQueue(id.toString(), AppStrings.createOperation);
  }

  Future<void> sync() async {
    final remoteNotes = await remote.fetchNotes();

    for (var note in remoteNotes) {
      if (note.id == null) continue;

      await database.into(database.notes).insertOnConflictUpdate(
            NotesCompanion(
              id: drift.Value(note.id!),
              title: drift.Value(note.title),
              content: drift.Value(note.content),
              createdAt: drift.Value(DateTime.now()),
            ),
          );
    }
  }
}
