import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/base/controller/base_controller.dart';
import '../../data/repository/notes_repository.dart';

class AddNoteController extends BaseController {
  final NotesRepository repository;

  AddNoteController(this.repository);

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> saveNote() async {
    try {
      showLoading();

      await repository.createNote(titleController.text, contentController.text);

      if (Get.isOverlaysOpen) {
        Get.back(); 
      } else {
        Get.back();
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      hideLoading();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    super.onClose();
  }
}
