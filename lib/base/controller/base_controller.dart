import 'package:get/get.dart';
import 'package:notes_app/data/constants/app_strings.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = RxnString();

  Future<T?> runWithHandling<T>(
    Future<T> Function() action,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      return await action();
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void handleError(Object error) {
    errorMessage.value = error.toString();
    Get.snackbar(AppStrings.error, error.toString());
  }
}