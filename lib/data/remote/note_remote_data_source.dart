import 'package:notes_app/data/remote/notes_api_client.dart';
import '../model/note_model.dart';

class NoteRemoteDataSource {
  final NotesApiClient apiClient;

  NoteRemoteDataSource(this.apiClient);

  Future<List<NoteModel>> fetchNotes() {
    return apiClient.getNotes();
  }

  Future<NoteModel> addNote(NoteModel note) {
    return apiClient.addNote(note);
  }
}
