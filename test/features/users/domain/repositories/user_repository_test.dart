import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/core/errors/exceptions.dart';
import 'package:movie_app/src/features/users/data/datasources/user_remote_data_source.dart';
import 'package:movie_app/src/features/users/data/models/user_model.dart';
import 'package:movie_app/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:movie_app/src/features/users/domain/entities/user_entity.dart';
import 'package:movie_app/src/features/users/domain/repositories/user_repository.dart';

class MockUserRemoteDataSource extends Mock implements UserRemoteDataSource {}

void main() {
  late UserRepository repository;
  late MockUserRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getUsers', () {
    final tUserModels = [
      const UserModel(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
        phoneNumber: '123-456-7890',
      ),
      const UserModel(
        id: 2,
        name: 'Jane Doe',
        username: 'janedoe',
        email: 'jane@example.com',
      ),
    ];

    test(
      'should return list of users when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getUsers(),
        ).thenAnswer((_) async => tUserModels);

        // act
        final result = await repository.getUsers();

        // assert
        expect(result, isA<Right<AppException, List<UserEntity>>>());
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r.length, 2);
          expect(r.first.id, 1);
          expect(r.first.name, 'John Doe');
        });
        verify(() => mockRemoteDataSource.getUsers()).called(1);
      },
    );

    test(
      'should return ServerException when the call to remote data source throws ServerException',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getUsers(),
        ).thenThrow(const ServerException(message: 'Server error'));

        // act
        final result = await repository.getUsers();

        // assert
        expect(result, isA<Left<AppException, List<UserEntity>>>());
        result.fold((l) {
          expect(l, isA<ServerException>());
          expect(l.message, 'Server error');
        }, (r) => fail('Should return Left'));
      },
    );

    test(
      'should return NetworkException when the call throws NetworkException',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getUsers(),
        ).thenThrow(const NetworkException(message: 'No connection'));

        // act
        final result = await repository.getUsers();

        // assert
        result.fold((l) {
          expect(l, isA<NetworkException>());
          expect(l.message, 'No connection');
        }, (r) => fail('Should return Left'));
      },
    );

    test(
      'should return UnknownException when unexpected error occurs',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getUsers(),
        ).thenThrow(Exception('Unexpected'));

        // act
        final result = await repository.getUsers();

        // assert
        result.fold((l) {
          expect(l, isA<UnknownException>());
        }, (r) => fail('Should return Left'));
      },
    );
  });

  group('getUserById', () {
    const tUserId = 1;
    const tUserModel = UserModel(
      id: 1,
      name: 'John Doe',
      username: 'johndoe',
      email: 'john@example.com',
    );

    test(
      'should return user when the call to remote data source is successful',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getUserById(tUserId),
        ).thenAnswer((_) async => tUserModel);

        // act
        final result = await repository.getUserById(tUserId);

        // assert
        expect(result, isA<Right<AppException, UserEntity>>());
        result.fold((l) => fail('Should return Right'), (r) {
          expect(r.id, 1);
          expect(r.name, 'John Doe');
        });
      },
    );

    test(
      'should return error when the call to remote data source fails',
      () async {
        // arrange
        when(
          () => mockRemoteDataSource.getUserById(tUserId),
        ).thenThrow(const ServerException(message: 'User not found'));

        // act
        final result = await repository.getUserById(tUserId);

        // assert
        expect(result, isA<Left<AppException, UserEntity>>());
      },
    );
  });

  group('searchUsers', () {
    const tQuery = 'john';
    final tUserModels = [
      const UserModel(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      ),
    ];

    test('should return filtered users when search is successful', () async {
      // arrange
      when(
        () => mockRemoteDataSource.searchUsers(tQuery),
      ).thenAnswer((_) async => tUserModels);

      // act
      final result = await repository.searchUsers(tQuery);

      // assert
      expect(result, isA<Right<AppException, List<UserEntity>>>());
      result.fold((l) => fail('Should return Right'), (r) {
        expect(r.length, 1);
        expect(r.first.name, 'John Doe');
      });
      verify(() => mockRemoteDataSource.searchUsers(tQuery)).called(1);
    });
  });
}
