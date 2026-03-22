import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'src/core/di/injection.dart';
import 'src/core/routes/app_pages.dart';
import 'src/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Users App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AppBindings(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
