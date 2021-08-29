// @GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
import 'package:clean_architecture_tdd/core/error/failure.dart';
import 'package:clean_architecture_tdd/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  Future<List<NumberTriviaState>> states({required Type endState}) async {
    List<NumberTriviaState> _states = [bloc.state];
    await bloc.stream.every((state) {
      _states.add(state);
      return state.runtimeType != endState; // end if false;
    });
    return _states;
  }

  test(
    'should initialState should be Empty',
    () async {
      // assert
      expect(bloc.state, equals(Empty()));
    },
  );

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    void setUpMockInputConverterSuccess() {
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
    }

    void setUpMockGetConcreteNumberTriviaSuccess() {
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    test(
      'should call the InputConverter to validate and convert the string to unsigned integer',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess(); // otherwise won't pass
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        // waiting for emit new state
        await bloc.stream.every((_) => false);
        // assert later
        expect(bloc.state, equals(Error(msg: INVALID_INPUT_FAILURE_MESSAGE)));
      },
    );

    test(
      'should get data from the concrete usecase',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded]  when data is gotten successfully',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        // await bloc.stream.any((_) => false);
        final actual = await states(endState: Loaded);
        // assert
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        // expect(bloc.state, equals(Loaded(trivia: tNumberTrivia)));
        expect(actual, equals(expected));
      },
    );
    test(
      'should emit [Loading, Error] when getting data is failed',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        final actual = [bloc.state];
        await bloc.stream.every((state) {
          actual.add(state);
          return !(state is Error);
        });
        // assert
        final expected = [
          Empty(),
          Loading(),
          Error(msg: SERVER_FAILURE_MESSAGE),
        ];
        // expect(bloc.state, equals(Loaded(trivia: tNumberTrivia)));
        expect(actual, equals(expected));
      },
    );
    test(
      'should emit [Loading, Error] with proper message for ther when getting data is failed',
      () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        final actual = await states(endState: Error);
        // assert
        final expected = [
          Empty(),
          Loading(),
          Error(msg: CACHE_FAILURE_MESSAGE),
        ];
        // expect(bloc.state, equals(Loaded(trivia: tNumberTrivia)));
        expect(actual, equals(expected));
      },
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(text: "test trivia", number: 1);

    void setUpMockGetRandomNumberTriviaSuccess() {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
    }

    test(
      'should get data from the random usecase',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaSuccess();
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      },
    );

    test(
      'should emit [Loading, Loaded]  when data is gotten successfully',
      () async {
        // arrange
        setUpMockGetRandomNumberTriviaSuccess();
        // act
        bloc.add(GetTriviaForRandomNumber());
        // await bloc.stream.any((_) => false);
        final actual = await states(endState: Loaded);
        // assert
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];
        // expect(bloc.state, equals(Loaded(trivia: tNumberTrivia)));
        expect(actual, equals(expected));
      },
    );
    test(
      'should emit [Loading, Error] when getting data is failed',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        bloc.add(GetTriviaForRandomNumber());
        final actual = [bloc.state];
        await bloc.stream.every((state) {
          actual.add(state);
          return !(state is Error);
        });
        // assert
        final expected = [
          Empty(),
          Loading(),
          Error(msg: SERVER_FAILURE_MESSAGE),
        ];
        // expect(bloc.state, equals(Loaded(trivia: tNumberTrivia)));
        expect(actual, equals(expected));
      },
    );
    test(
      'should emit [Loading, Error] with proper message for ther when getting data is failed',
      () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
        // act
        bloc.add(GetTriviaForRandomNumber());
        final actual = await states(endState: Error);
        // assert
        final expected = [
          Empty(),
          Loading(),
          Error(msg: CACHE_FAILURE_MESSAGE),
        ];
        // expect(bloc.state, equals(Loaded(trivia: tNumberTrivia)));
        expect(actual, equals(expected));
      },
    );
  });
}
