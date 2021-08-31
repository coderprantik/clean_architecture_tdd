import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/core/error/failure.dart';
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

    await failureOrNumber.fold(
      (_) async => state.value = Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      (number) async {
        state.value = Loading();
        final failureOfTrivia = await _concrete(Params(number: number));
        failureOfTrivia.fold(
          (failure) {
            return state.value = Error(message: _getMessage(failure));
          },
          (trivia) => state.value = Loaded(trivia: trivia),
        );
      },
    );
  }

  String _getMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerException:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error!';
    }
  }
}

const INVALID_INPUT_FAILURE_MESSAGE =
    'The number must me a positive integer or zero.';
const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
