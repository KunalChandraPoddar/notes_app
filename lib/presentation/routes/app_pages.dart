import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:notes_app/bindings/add_note_bindings.dart';
import 'package:notes_app/bindings/notes_binding.dart';
import 'package:notes_app/presentation/pages/add_note_page.dart';
import 'package:notes_app/presentation/pages/notes_page.dart';
import 'package:notes_app/presentation/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.notes,
      page: () => NotesPage(),
      binding: NotesBinding(),
    ),
    GetPage(
      name: AppRoutes.addNote,
      page: () => AddNotePage(),
      binding: AddNoteBinding(),
    ),
  ];
}