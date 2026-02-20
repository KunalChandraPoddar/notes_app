import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:notes_app/data/constants/app_strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Notes extends Table {
  IntColumn get id => integer()();

  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get noteId => integer()();
  TextColumn get operationType => text()();
  IntColumn get timestamp => integer()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
}

@DriftDatabase(tables: [Notes, SyncQueue])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Stream<List<Note>> watchNotes() =>
      (select(notes)..where((t) => t.isDeleted.equals(false))).watch();

  Future<void> insertNote(NotesCompanion note) => into(notes).insert(note);

  Future<void> addToQueue(String id, String type) => into(syncQueue).insert(
        SyncQueueCompanion.insert(
          noteId: int.parse(id),
          operationType: type,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );

  Future<List<SyncQueueData>> getQueueItems() => select(syncQueue).get();

  Future<void> removeQueueItem(int id) =>
      (delete(syncQueue)..where((t) => t.id.equals(id))).go();

  Future<Note?> getNoteById(int id) {
    return (select(notes)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> markNoteSynced(int id) {
    return (update(notes)..where((t) => t.id.equals(id))).write(
      const NotesCompanion(
        isSynced: Value(true),
      ),
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, AppStrings.notesDatabaseName));
    return NativeDatabase(file);
  });
}
