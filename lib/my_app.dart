import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/bindings/initialize_bindings.dart';
import 'package:notes_app/presentation/routes/app_pages.dart';
import 'package:notes_app/presentation/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitializeBindings(),
      initialRoute: AppRoutes.notes,
      getPages: AppPages.pages,
    );
  }
}
