import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:notes_app/base/config/api_config.dart';
import 'package:notes_app/data/constants/app_strings.dart';

class DioClient {
  static void prepareDio() {
    Get.lazyPut<Dio>(() => Dio(BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          headers: {
          AppStrings.contentType: AppStrings.applicationJson,
        },
        )), fenix: true);
  }
}