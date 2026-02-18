import 'package:get/get.dart';
import '../presentation/controller/notes_controller.dart';

class NotesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotesController(Get.find()));
  }
}