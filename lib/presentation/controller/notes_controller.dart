import 'package:get/get.dart';
import 'package:notes_app/base/controller/base_controller.dart';
import 'package:notes_app/data/local/database/app_database.dart';
import 'package:notes_app/data/repository/notes_repository.dart';

class NotesController extends BaseController {
  final NotesRepository repository;

  NotesController(this.repository);

  final notes = <Note>[].obs;
  final isSyncing = false.obs;

  @override
  void onInit() {
    super.onInit();
    repository.watchNotes().listen((data) {
      notes.value = data;
    });
  }

  Future<void> addNote(String title, String content) async {
    try {
      showLoading();
      clearError();

      await repository.createNote(title, content);

    } catch (e) {
      setError(e.toString());
    } finally {
      hideLoading();
    }
  }

  Future<void> syncNow() async {
    try {
      isSyncing.value = true;
      await repository.sync();
    } catch (e) {
      setError(e.toString());
    } finally {
      isSyncing.value = false;
    }
  }
}
