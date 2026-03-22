import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/core/constants/api_constants.dart';
import 'package:movie_app/src/core/network/api_client.dart';
import 'package:movie_app/src/features/users/data/datasources/user_remote_data_source.dart';
import 'package:movie_app/src/features/users/data/models/user_model.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late UserRemoteDataSource dataSource;
  late MockApiClient mockApiClient;

  setUp(() {
    mockApiClient = MockApiClient();
    dataSource = UserRemoteDataSourceImpl(apiClient: mockApiClient);
  });

  group('getUsers', () {
    final tResponseData = [
      {
        'id': 1,
        'name': 'John Doe',
        'username': 'johndoe',
        'email': 'john@example.com',
        'phone': '123-456-7890',
      },
      {
        'id': 2,
        'name': 'Jane Doe',
        'username': 'janedoe',
        'email': 'jane@example.com',
      },
    ];

    test(
      'should return list of UserModel when response is successful',
      () async {
        // arrange
        when(
          () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
        ).thenAnswer(
          (_) async => Response(
            data: tResponseData,
            statusCode: 200,
            requestOptions: RequestOptions(),
          ),
        );

        // act
        final result = await dataSource.getUsers();

        // assert
        expect(result, isA<List<UserModel>>());
        expect(result.length, 2);
        expect(result.first.id, 1);
        expect(result.first.name, 'John Doe');
        verify(
          () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
        ).called(1);
      },
    );

    test('should return empty list when response data is null', () async {
      // arrange
      when(
        () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
      ).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act
      final result = await dataSource.getUsers();

      // assert
      expect(result, isEmpty);
    });
  });

  group('getUserById', () {
    const tUserId = 1;
    final tResponseData = {
      'id': 1,
      'name': 'John Doe',
      'username': 'johndoe',
      'email': 'john@example.com',
    };

    test('should return UserModel when response is successful', () async {
      // arrange
      when(
        () => mockApiClient.get<Map<String, dynamic>>(
          '${ApiConstants.users}/$tUserId',
        ),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act
      final result = await dataSource.getUserById(tUserId);

      // assert
      expect(result, isA<UserModel>());
      expect(result.id, 1);
      expect(result.name, 'John Doe');
    });

    test('should throw exception when response data is null', () async {
      // arrange
      when(
        () => mockApiClient.get<Map<String, dynamic>>(
          '${ApiConstants.users}/$tUserId',
        ),
      ).thenAnswer(
        (_) async => Response(
          data: null,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act & assert
      expect(() => dataSource.getUserById(tUserId), throwsA(isA<Exception>()));
    });
  });

  group('searchUsers', () {
    final tResponseData = [
      {
        'id': 1,
        'name': 'John Doe',
        'username': 'johndoe',
        'email': 'john@example.com',
      },
      {
        'id': 2,
        'name': 'Jane Smith',
        'username': 'janesmith',
        'email': 'jane@example.com',
      },
    ];

    test('should return filtered users when query matches', () async {
      // arrange
      when(
        () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act
      final result = await dataSource.searchUsers('john');

      // assert
      expect(result.length, 1);
      expect(result.first.name, 'John Doe');
    });

    test('should return all users when query is empty', () async {
      // arrange
      when(
        () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act
      final result = await dataSource.searchUsers('');

      // assert
      expect(result.length, 2);
    });

    test('should search by username', () async {
      // arrange
      when(
        () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act
      final result = await dataSource.searchUsers('janesmith');

      // assert
      expect(result.length, 1);
      expect(result.first.username, 'janesmith');
    });

    test('should search by email', () async {
      // arrange
      when(
        () => mockApiClient.get<List<dynamic>>(ApiConstants.users),
      ).thenAnswer(
        (_) async => Response(
          data: tResponseData,
          statusCode: 200,
          requestOptions: RequestOptions(),
        ),
      );

      // act
      final result = await dataSource.searchUsers('jane@example.com');

      // assert
      expect(result.length, 1);
      expect(result.first.email, 'jane@example.com');
    });
  });
}
