// @GenerateMocks([SharedPreferences])
import 'package:clean_architecture_tdd/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

import 'shared_preferences.mocks.dart';

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
  });
}
