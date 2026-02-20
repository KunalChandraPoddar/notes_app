import '../local/database/app_database.dart';
import '../model/note_model.dart';

extension DriftToModel on Note {
  NoteModel toModel() {
    return NoteModel(
      id: id,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}