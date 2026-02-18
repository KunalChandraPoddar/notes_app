import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:notes_app/core/network/dio_client.dart';
import 'package:notes_app/data/remote/notes_api_client.dart';
import 'package:notes_app/sync/sync_service.dart';
import '../data/local/database/app_database.dart';
import '../data/remote/note_remote_data_source.dart';
import '../data/repository/notes_repository.dart';

class InitializeBindings extends Bindings {
  @override
  void dependencies() {
    DioClient.prepareDio();

    Get.put<AppDatabase>(AppDatabase(), permanent: true);

    Get.put<NotesApiClient>(
      NotesApiClient(Get.find<Dio>()),
      permanent: true,
    );

    Get.put<NoteRemoteDataSource>(
      NoteRemoteDataSource(Get.find()),
      permanent: true,
    );

    Get.put<NotesRepository>(
      NotesRepository(Get.find(), Get.find()),
      permanent: true,
    );

    Get.put<SyncService>(
      SyncService(Get.find(), Get.find()),
      permanent: true,
    );
  }
}
