import 'package:dio/dio.dart';
import 'package:notes_app/data/constants/app_strings.dart';
import 'package:notes_app/data/remote/notes_api_client.dart';
import '../model/note_model.dart';

class NoteRemoteDataSource {
  final NotesApiClient apiClient;

  NoteRemoteDataSource(this.apiClient);

  Future<T> _callApi<T>(Future<T> request) async {
    try {
      return await request;
    } on DioException catch (e) {
      final message =
          e.response?.data?[AppStrings.messageKey] ??
          e.response?.statusMessage ??
          AppStrings.errorMessage;

      throw Exception(message);
    } catch (e) {
      throw Exception("Unexpected error");
    }
  }

  Future<List<NoteModel>> fetchNotes() {
    return _callApi(apiClient.getNotes());
  }

  Future<NoteModel> addNote(NoteModel note) {
    return _callApi(apiClient.addNote(note));
  }

  Future<NoteModel> updateNote(int id, NoteModel note) {
    return _callApi(apiClient.updateNote(id, note));
  }
}
