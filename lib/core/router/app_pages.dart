import 'package:clean_architecture_tdd/features/number_trivia/presentation/controller/number_trivia_controller.dart';
import 'package:get/get.dart';

import '../../features/number_trivia/presentation/pages/number_trivia_page.dart';
import '../../injection_container.dart';

part './app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
        name: Routes.TRIVIA,
        page: () => NumberTriviaPage(),
        binding: BindingsBuilder(
          () => {
            Get.lazyPut(() => NumberTriviaController()),
            Get.find<NumberTriviaController>().init(
              concrete: locator(),
              random: locator(),
              inputConverter: locator(),
            )
          },
        ))
  ];
}
