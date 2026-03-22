import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource _remoteDataSource;

  UserRepositoryImpl({required UserRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<AppException, List<UserEntity>>> getUsers() async {
    try {
      final users = await _remoteDataSource.getUsers();
      return Right(users.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(e);
    } on NetworkException catch (e) {
      return Left(e);
    } on TimeoutException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(
        UnknownException(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Either<AppException, UserEntity>> getUserById(int id) async {
    try {
      final user = await _remoteDataSource.getUserById(id);
      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(e);
    } on NetworkException catch (e) {
      return Left(e);
    } on TimeoutException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(
        UnknownException(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }

  @override
  Future<Either<AppException, List<UserEntity>>> searchUsers(
    String query,
  ) async {
    try {
      final users = await _remoteDataSource.searchUsers(query);
      return Right(users.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(e);
    } on NetworkException catch (e) {
      return Left(e);
    } on TimeoutException catch (e) {
      return Left(e);
    } catch (e, stackTrace) {
      return Left(
        UnknownException(message: e.toString(), stackTrace: stackTrace),
      );
    }
  }
}
