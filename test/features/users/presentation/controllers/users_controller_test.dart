import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_app/src/core/errors/exceptions.dart';
import 'package:movie_app/src/features/users/domain/entities/user_entity.dart';
import 'package:movie_app/src/features/users/domain/repositories/user_repository.dart';
import 'package:movie_app/src/features/users/presentation/controllers/users_controller.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late UsersController controller;
  late MockUserRepository mockRepository;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockUserRepository();
    controller = UsersController(userRepository: mockRepository);
  });

  tearDown(() {
    controller.dispose();
    Get.reset();
  });

  group('fetchUsers', () {
    final tUsers = [
      const UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      ),
      const UserEntity(
        id: 2,
        name: 'Jane Doe',
        username: 'janedoe',
        email: 'jane@example.com',
      ),
    ];

    test('should load users successfully', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => Right(tUsers));

      // act
      await controller.fetchUsers();

      // assert
      expect(controller.hasData, true);
      expect(controller.users.length, 2);
      expect(controller.users.first.name, 'John Doe');
      expect(controller.errorMessage, '');
    });

    test('should handle empty list', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => const Right(<UserEntity>[]));

      // act
      await controller.fetchUsers();

      // assert
      expect(controller.isEmpty, true);
      expect(controller.users.isEmpty, true);
    });

    test('should handle error state', () async {
      // arrange
      when(() => mockRepository.getUsers()).thenAnswer(
        (_) async => const Left(ServerException(message: 'Server error')),
      );

      // act
      await controller.fetchUsers();

      // assert
      expect(controller.hasError, true);
      expect(controller.errorMessage, 'Server error');
    });

    test('should set loading state during fetch', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => Right(tUsers));

      // act
      final future = controller.fetchUsers();

      // assert - loading should be true immediately
      expect(controller.isLoading, true);

      // wait for completion
      await future;

      // assert - loading should be false after completion
      expect(controller.isLoading, false);
    });
  });

  group('refreshUsers', () {
    final tUsers = [
      const UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      ),
    ];

    test('should refresh users list', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => Right(tUsers));

      // act
      await controller.refreshUsers();

      // assert
      expect(controller.users.length, 1);
    });
  });

  group('searchUsers', () {
    final tUsers = [
      const UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      ),
    ];

    test('should search users successfully', () async {
      // arrange
      when(
        () => mockRepository.searchUsers('john'),
      ).thenAnswer((_) async => Right(tUsers));

      // act
      await controller.searchUsers('john');

      // assert
      expect(controller.filteredUsers.length, 1);
      expect(controller.searchQuery, 'john');
    });

    test(
      'should clear search and show all users when query is empty',
      () async {
        // arrange - first load users
        when(
          () => mockRepository.getUsers(),
        ).thenAnswer((_) async => Right(tUsers));
        await controller.fetchUsers();

        // act - clear search
        controller.clearSearch();

        // assert
        expect(controller.searchQuery, '');
        expect(controller.filteredUsers.length, 1);
      },
    );
  });

  group('getUserById', () {
    final tUsers = [
      const UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      ),
    ];

    test('should return user when found', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => Right(tUsers));
      await controller.fetchUsers();

      // act
      final result = controller.getUserById(1);

      // assert
      expect(result, isNotNull);
      expect(result!.id, 1);
      expect(result.name, 'John Doe');
    });

    test('should return null when user not found', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => Right(tUsers));
      await controller.fetchUsers();

      // act
      final result = controller.getUserById(999);

      // assert
      expect(result, isNull);
    });
  });

  group('clearSearch', () {
    final tUsers = [
      const UserEntity(
        id: 1,
        name: 'John Doe',
        username: 'johndoe',
        email: 'john@example.com',
      ),
    ];

    test('should reset search query and filtered users', () async {
      // arrange
      when(
        () => mockRepository.getUsers(),
      ).thenAnswer((_) async => Right(tUsers));
      when(
        () => mockRepository.searchUsers(any()),
      ).thenAnswer((_) async => const Right(<UserEntity>[]));

      await controller.fetchUsers();
      await controller.searchUsers('nonexistent');

      // act
      controller.clearSearch();

      // assert
      expect(controller.searchQuery, '');
      expect(controller.filteredUsers.length, 1);
    });
  });
}
