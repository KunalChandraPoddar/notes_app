import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/data/constants/app_strings.dart';
import 'package:notes_app/presentation/controller/add_note_controller.dart';

class AddNotePage extends StatelessWidget{
  AddNotePage({super.key});

  final AddNoteController addNoteController = Get.find<AddNoteController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.addNoteTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: addNoteController.titleController,
              decoration: const InputDecoration(labelText: AppStrings.titleLabel),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addNoteController.contentController,
              decoration: const InputDecoration(labelText: AppStrings.contentLabel),
            ),
            const SizedBox(height: 24),
            Obx(() => addNoteController.isLoading.value
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: addNoteController.saveNote,
                    child: const Text(AppStrings.saveNoteButton),
                  )),
          ],
        ),
      ),
    );
  }
}
