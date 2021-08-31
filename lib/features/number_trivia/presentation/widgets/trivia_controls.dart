import 'package:clean_architecture_tdd/features/number_trivia/presentation/controller/number_trivia_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'widgets.dart';

class TriviaControls extends GetView<NumberTriviaController> {
  TriviaControls({
    Key? key,
  }) : super(key: key);

  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: TextField(
            onSubmitted: (_) => getConcreteNumberTrivia(),
            controller: textEditingController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Type your number here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ControlButton(
            onPressed: getConcreteNumberTrivia,
            child: Icon(Icons.search, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ControlButton(
            onPressed: () => controller.getRandomNumberTrivia(),
            child: Text(
              "RAN\nDOM",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void getConcreteNumberTrivia() => controller.getConcreteNumberTrivia(
        textEditingController.text,
      );
}
