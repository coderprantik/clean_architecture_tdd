import 'package:clean_architecture_tdd/core/error/exceptions.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'http_client.mocks.dart';

// @GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockClientSuccess200() {
    when(mockClient.get(any, headers: anyNamed("headers"))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),
    );
  }

  void setUpMockClientFailure404() {
    when(mockClient.get(any, headers: anyNamed("headers"))).thenAnswer(
      (_) async => http.Response("Something went wrong!", 404),
    );
  }

  group('getConcreteNumberTrivia', () {
    final jsonString = fixture('trivia.json');
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromRawJson(jsonString);
    test(
      '''should perform a GET request on a URL with number
      being the endpoint and with application/json header''',
      () async {
        // arrange
        setUpMockClientSuccess200();
        // act
        await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        verify(mockClient.get(
          Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'},
        ));
      },
    );
    test(
      'should return NumberTriviaModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockClientSuccess200();
        // act
        final result = await dataSource.getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockClientFailure404();
        // act
        final call = dataSource.getConcreteNumberTrivia;
        // assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
