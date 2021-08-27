import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  /// cache NumberTriviaModel
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) async {
    // TODO: implement cacheNumberTrivia
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    // TODO: implement getLastNumberTrivia
    throw UnimplementedError();
  }
}
