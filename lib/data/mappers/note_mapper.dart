import '../../domain/entities/note.dart' as domain;
import '../local/database/app_database.dart';
import 'package:drift/drift.dart' as drift;

extension NoteMapper on domain.Note {
  domain.Note toDomain() {
    return domain.Note(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
    );
  }
}

extension NoteCompanionMapper on domain.Note {
  NotesCompanion toCompanion() {
    return NotesCompanion(
      id: id == null ? const drift.Value.absent() : drift.Value(id!),
      title: drift.Value(title),
      content: drift.Value(content),
      createdAt: drift.Value(createdAt),
    );
  }
}
