import 'dart:convert';

import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group("fromJson", () {
    test(
      "should return a valid model when the JSON number is an integer",
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(fixture("trivia.json"));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
    test(
      "should return a valid model when the JSON number is a double",
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = jsonDecode(
          fixture("trivia_double.json"),
        );
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group("fromRawJson", () {
    test(
      "should return a valid model when by raw JSON",
      () async {
        // arrange
        final String rawJson = fixture("trivia.json");
        // act
        final result = NumberTriviaModel.fromRawJson(rawJson);
        // assert
        expect(result, tNumberTriviaModel);
      },
    );
  });
  group("toJson", () {
    test(
      'should return a JSON Map containing the proper data',
      () async {
        // arrange
        final Map<String, dynamic> expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        expect(result, expectedMap);
      },
    );
  });
}
