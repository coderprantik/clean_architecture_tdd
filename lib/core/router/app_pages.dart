import 'package:get/get.dart';

import '../../features/number_trivia/presentation/pages/number_trivia_page.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.TRIVIA,
      page: () => NumberTriviaPage(),
    )
  ];
}
