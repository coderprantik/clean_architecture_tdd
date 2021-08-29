import 'package:clean_architecture_tdd/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'connection_checker.mocks.dart';

// @GenerateMocks([DataConnectionChecker])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test(
      'should forward the call to ConnectionChecker.hasConnection',
      () async {
        // arrange
        when(mockDataConnectionChecker.hasConnection)
            .thenAnswer((_) async => true);
        // act
        final result = await networkInfoImpl.isConnected;
        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, true);
      },
    );
  });
}
