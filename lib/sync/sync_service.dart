import 'package:notes_app/data/local/database/app_database.dart';
import 'package:notes_app/data/model/note_model.dart';
import 'package:notes_app/data/remote/notes_api_client.dart';
import 'package:drift/drift.dart' as drift;

class SyncService {
  final AppDatabase db;
  final NotesApiClient api;

  SyncService(this.db, this.api);

  Future<void> performSync() async {
    final queueItems = await db.getQueueItems();

    for (final item in queueItems) {
      try {

        final note = await (db.select(db.notes)
              ..where((t) => t.id.equals(int.parse(item.noteId))))
            .getSingle();

        await api.addNote(
          NoteModel(
            id: note.id,
            title: note.title,
            content: note.content,
          ),
        );

        await db.removeQueueItem(item.id);
      } catch (e) {
        await _incrementRetry(item);
      }
    }
  }

  Future<void> _incrementRetry(SyncQueueData item) async {
    final retry = item.retryCount + 1;

    if (retry > 5) return;

    final delay = Duration(seconds: 2 * (1 << retry));
    await Future.delayed(delay);

    await (db.update(db.syncQueue)..where((t) => t.id.equals(item.id))).write(
      SyncQueueCompanion(
        retryCount: drift.Value(retry),
      ),
    );
  }
}
