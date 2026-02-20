import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:drift/drift.dart' as drift;
import 'package:notes_app/data/constants/app_strings.dart';
import 'package:notes_app/data/local/database/app_database.dart';
import 'package:notes_app/data/model/note_model.dart';
import 'package:notes_app/data/remote/note_remote_data_source.dart';

class SyncService {
  final AppDatabase db;
  final NoteRemoteDataSource remoteDataSource;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  SyncService(this.db, this.remoteDataSource) {
    _listenToConnectivity();
  }

  void _listenToConnectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (result) {
        if (result != ConnectivityResult.none) {
          performSync();
        }
      },
    );
  }

  Future<bool> _hasInternet() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> performSync() async {
    final hasInternet = await _hasInternet();
    if (!hasInternet) return;

    final queueItems = await db.getQueueItems();
    
    for (final item in queueItems) {
      try {
        final note = await (db.select(db.notes)
              ..where((t) => t.id.equals(item.noteId)))
            .getSingle();

        if (item.operationType == AppStrings.createOperation) {
          await remoteDataSource.addNote(
            NoteModel(
              id: note.id,
              title: note.title,
              content: note.content,
            ),
          );
        }

        if (item.operationType == AppStrings.updateOperation) {
          await remoteDataSource.updateNote(
            note.id,
            NoteModel(
              id: note.id,
              title: note.title,
              content: note.content,
            ),
          );
        }

        await db.removeQueueItem(item.id);
      } catch (e) {
        await _incrementRetry(item);
      }
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
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