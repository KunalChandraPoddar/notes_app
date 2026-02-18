import 'package:get/get.dart';
import 'package:notes_app/data/constants/app_strings.dart';

abstract class BaseController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = RxnString();

  void showLoading() => isLoading.value = true;

  void hideLoading() => isLoading.value = false;

  void setError(String message) {
    errorMessage.value = message;
    Get.snackbar(AppStrings.error, message);
  }

  void clearError() {
    errorMessage.value = null;
  }
}