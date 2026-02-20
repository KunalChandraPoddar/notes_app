import 'package:notes_app/data/constants/app_strings.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../model/note_model.dart';

part 'notes_api_client.g.dart';

@RestApi()
abstract class NotesApiClient {
  factory NotesApiClient(Dio dio, {String baseUrl}) = _NotesApiClient;

  @GET(AppStrings.postsEndpoint)
  Future<List<NoteModel>> getNotes();

  @POST(AppStrings.postsEndpoint)
  Future<NoteModel> addNote(@Body() NoteModel note);

  @PUT("${AppStrings.postsEndpoint}/{id}")
  Future<NoteModel> updateNote(
    @Path("id") int id,
    @Body() NoteModel note,
  );
}
