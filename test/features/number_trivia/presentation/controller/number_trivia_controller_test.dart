import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/controller/number_trivia_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_controller.mocks.dart';

/* @GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter
]) */
void main() {
  late NumberTriviaController controller;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    // Setting up NumberTriviaController
    Get.lazyPut(() => NumberTriviaController());
    controller = Get.find<NumberTriviaController>();
    controller.init(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test(
    'should intial state is Empty',
    () async {
      // assert
      expect(controller.state.value, equals(Empty()));
    },
  );

  group('getConcreteNumberTrivia', () {
    final int tNumberParsed = 1;
    final String tNumberString = '1';
    final tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and convert the string to unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        // when(mockGetConcreteNumberTrivia(any))
        //     .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        await controller.getConcreteNumberTrivia(tNumberString);
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should show Error state when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        await controller.getConcreteNumberTrivia(tNumberString);
        final result = controller.state.value;
        // assert
        expect(result, Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      },
    );

    test(
      'should get data from concrete usecase',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        await controller.getConcreteNumberTrivia(tNumberString);
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );
  });
}
