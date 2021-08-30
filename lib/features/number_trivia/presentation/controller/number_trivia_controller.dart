import 'package:equatable/equatable.dart';
import 'package:get/get.dart';

import '../../../../core/util/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_state.dart';

class NumberTriviaController extends GetxController {
  Rx<NumberTriviaState> state = Rx(Empty());

  late GetConcreteNumberTrivia _concrete;
  late GetRandomNumberTrivia _random;
  late InputConverter _inputConverter;

  void init({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required InputConverter inputConverter,
  }) {
    _concrete = concrete;
    _random = random;
    _inputConverter = inputConverter;
  }

  Future<void> getConcreteNumberTrivia(String numberString) async {
    final failureOrNumber = _inputConverter.stringToUnsignedInteger(
      numberString,
    );

    failureOrNumber.fold(
      (f) => state.value = Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      (number) async {
        // state.value = Loading();
        final failureOfTrivia = await _concrete(Params(number: number));
      },
    );
  }
}

const INVALID_INPUT_FAILURE_MESSAGE =
    'The number must me a positive integer or zero.';
const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
