import 'package:notes_app/data/constants/app_strings.dart';
import '../local/database/app_database.dart';
import '../remote/note_remote_data_source.dart';
import 'package:drift/drift.dart' as drift;
import '../mappers/drift_to_model.dart';

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
        isSynced: const drift.Value(false),
      ),
    );

    await database.addToQueue(id.toString(), AppStrings.createOperation);
  }

  Future<void> updateNote(int id, String title, String content) async {
    await (database.update(database.notes)..where((tbl) => tbl.id.equals(id)))
        .write(
      NotesCompanion(
        title: drift.Value(title),
        content: drift.Value(content),
        updatedAt: drift.Value(DateTime.now()),
        isSynced: const drift.Value(false),
      ),
    );

    await database.addToQueue(id.toString(), AppStrings.updateOperation);
  }

  Future<void> sync() async {
    final queueItems = await database.getQueueItems();

    for (final item in queueItems) {
      final noteId = item.noteId;
      final note = await database.getNoteById(noteId);

      if (note == null) continue;

      if (item.operationType == AppStrings.createOperation) {
        await remote.addNote(note.toModel());
      } else if (item.operationType == AppStrings.updateOperation) {
        await remote.updateNote(note.id, note.toModel());
      }

      await database.markNoteSynced(note.id);
      await database.removeQueueItem(item.id);
    }

    final remoteNotes = await remote.fetchNotes();

    for (var note in remoteNotes) {
      if (note.id == null) continue;

      await database.into(database.notes).insertOnConflictUpdate(
        NotesCompanion(
          id: drift.Value(note.id!),
          title: drift.Value(note.title),
          content: drift.Value(note.content),
          createdAt: drift.Value(DateTime.now()),
          isSynced: const drift.Value(true),
        ),
      );
    }
  }
}
