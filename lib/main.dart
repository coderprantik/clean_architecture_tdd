import 'package:clean_architecture_tdd/core/router/app_pages.dart';
import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  await setUp();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Trivia',
      initialRoute: Routes.TRIVIA,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
    );
  }
}