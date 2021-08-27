// @GenerateMocks([SharedPreferences])
import 'dart:convert';

import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'shared_preferences.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('getLastNumberTrivia', () {
    final jsonString = fixture("trivia_cached.json");
    final tNumberTriviaModel = NumberTriviaModel.fromRawJson(jsonString);
    test(
      'should return NumberTriviaModel from SharedPreferences when there is one cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(jsonString);
        // act
        final result = await dataSource.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString(CACHED_TRIVIA_KEY));
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      'should throw CacheException when there is no cache value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        // act
        final call = dataSource.getLastNumberTrivia;
        // assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      text: "test trivia",
      number: 1,
    );
    test(
      'should call SharedPreferences to cache the data',
      () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        // act
        await dataSource.cacheNumberTrivia(tNumberTriviaModel);
        // assert
        final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
          CACHED_TRIVIA_KEY,
          expectedJsonString,
        ));
      },
    );
  });
}
