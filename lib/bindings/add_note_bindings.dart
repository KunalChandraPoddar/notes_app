import 'package:get/get.dart';
import 'package:notes_app/presentation/controller/add_note_controller.dart';

class AddNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddNoteController(Get.find()));
  }
}
