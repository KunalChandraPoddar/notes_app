import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/data/constants/app_strings.dart';
import 'package:notes_app/presentation/controller/notes_controller.dart';
import 'package:notes_app/presentation/routes/app_routes.dart';

class NotesPage extends StatelessWidget {
  NotesPage({super.key});

  final NotesController notesController = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.notesTitle),
        actions: [
          Obx(() => notesController.isSyncing.value
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.sync),
                  onPressed: notesController.syncNow,
                )),
        ],
      ),
      body: Obx(() {
        if (notesController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (notesController.notes.isEmpty) {
          return const Center(child: Text(AppStrings.noNotesYet));
        }

        return ListView.builder(
          itemCount: notesController.notes.length,
          itemBuilder: (_, index) {
            final note = notesController.notes[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addNote),
        child: const Icon(Icons.add),
      ),
    );
  }
}