import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';
import 'widgets.dart';

class TriviaControls extends StatelessWidget {
  TriviaControls({
    Key? key,
  }) : super(key: key);

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: TextField(
            onSubmitted: (_) => addConcrete(context),
            controller: controller,
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
            onPressed: () => addConcrete(context),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ControlButton(
            onPressed: () => addRandom(context),
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

  NumberTriviaBloc bloc(BuildContext context) =>
      BlocProvider.of<NumberTriviaBloc>(context);

  NumberTriviaBloc get _bloc => locator<NumberTriviaBloc>();

  void addConcrete(context) {
    bloc(context).add(GetTriviaForConcreteNumber(controller.text));
    controller.clear();
  }

  void addRandom(context) => bloc(context).add(GetTriviaForRandomNumber());
}
