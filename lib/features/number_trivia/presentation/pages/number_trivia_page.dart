import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/number_trivia_controller.dart';
import '../widgets/widgets.dart';

class NumberTriviaPage extends GetView<NumberTriviaController> {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Number Trivia"),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      alignment: Alignment.center,
      child: Column(
        children: [
          TriviaControls(),
          const SizedBox(height: 20),
          Expanded(
            child: Obx(() {
              final state = controller.state.value;
              switch (state.runtimeType) {
                case Loading:
                  return Center(child: CircularProgressIndicator());
                case Loaded:
                  return TriviaDisplay(trivia: (state as Loaded).trivia);
                case Error:
                  return MessageDisplay(msg: (state as Error).message);
                default:
                  return MessageDisplay(msg: "Start searching....");
              }
            }),
          ),
        ],
      ),
    );
  }
}
