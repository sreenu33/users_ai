import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../entities/user_entity.dart';

/// Abstract repository for user operations
abstract class UserRepository {
  /// Fetches all users from the API
  ///
  /// Returns a [List<UserEntity>] on success or [AppException] on failure
  Future<Either<AppException, List<UserEntity>>> getUsers();

  /// Fetches a single user by ID
  ///
  /// Returns a [UserEntity] on success or [AppException] on failure
  Future<Either<AppException, UserEntity>> getUserById(int id);

  /// Searches users by name
  ///
  /// Returns a [List<UserEntity>] matching the query on success or [AppException] on failure
  Future<Either<AppException, List<UserEntity>>> searchUsers(String query);
}
