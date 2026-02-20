import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/base/controller/base_controller.dart';
import '../../data/local/database/app_database.dart';
import '../../data/repository/notes_repository.dart';

class AddNoteController extends BaseController {
  final NotesRepository repository;

  AddNoteController(this.repository);

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Note? existingNote;

  @override
  void onInit() {
    super.onInit();

    existingNote = Get.arguments as Note?;

    if (existingNote != null) {
      titleController.text = existingNote!.title;
      contentController.text = existingNote!.content;
    }
  }

  bool get isEditMode => existingNote != null;

  Future<void> saveNote() async {
    await runWithHandling(() async {
      if (isEditMode) {
        await repository.updateNote(
          existingNote!.id,
          titleController.text,
          contentController.text,
        );
      } else {
        await repository.createNote(
          titleController.text,
          contentController.text,
        );
      }

      Get.back();
    });
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}