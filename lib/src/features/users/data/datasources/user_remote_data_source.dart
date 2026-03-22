import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

/// Remote data source for user API operations
abstract class UserRemoteDataSource {
  /// Fetches all users from the API
  Future<List<UserModel>> getUsers();

  /// Fetches a single user by ID
  Future<UserModel> getUserById(int id);

  /// Searches users by name (client-side filtering)
  Future<List<UserModel>> searchUsers(String query);
}

/// Implementation of UserRemoteDataSource
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await _apiClient.get<List<dynamic>>(ApiConstants.users);

    if (response.data == null) {
      return [];
    }

    return (response.data as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserModel> getUserById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '${ApiConstants.users}/$id',
    );

    if (response.data == null) {
      throw Exception('User not found');
    }

    return UserModel.fromJson(response.data!);
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    // Get all users and filter client-side (JSONPlaceholder doesn't support search)
    final allUsers = await getUsers();

    if (query.isEmpty) {
      return allUsers;
    }

    final lowerQuery = query.toLowerCase();
    return allUsers.where((user) {
      return user.name.toLowerCase().contains(lowerQuery) ||
          user.username.toLowerCase().contains(lowerQuery) ||
          user.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
