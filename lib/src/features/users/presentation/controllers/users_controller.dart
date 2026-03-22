import 'package:get/get.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

/// Controller state for users
enum UsersState { initial, loading, loaded, error, empty }

/// GetX controller for managing users
class UsersController extends GetxController {
  final UserRepository _userRepository;

  UsersController({required UserRepository userRepository})
    : _userRepository = userRepository;

  // Observable states
  final Rx<UsersState> _state = UsersState.initial.obs;
  final RxList<UserEntity> _users = <UserEntity>[].obs;
  final RxList<UserEntity> _filteredUsers = <UserEntity>[].obs;
  final RxString _errorMessage = ''.obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isSearching = false.obs;

  // Getters
  UsersState get state => _state.value;
  List<UserEntity> get users => _users.toList();
  List<UserEntity> get filteredUsers => _filteredUsers.toList();
  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  bool get isSearching => _isSearching.value;

  // Computed
  bool get isLoading => _state.value == UsersState.loading;
  bool get hasError => _state.value == UsersState.error;
  bool get isEmpty => _state.value == UsersState.empty;
  bool get hasData => _state.value == UsersState.loaded && _users.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  /// Fetches all users from the repository
  Future<void> fetchUsers() async {
    _setLoading();

    final result = await _userRepository.getUsers();

    result.fold((error) => _setError(error), (users) {
      _users.assignAll(users);
      _filteredUsers.assignAll(users);
      _updateState();
    });
  }

  /// Refreshes the users list (for pull-to-refresh)
  Future<void> refreshUsers() async {
    return fetchUsers();
  }

  /// Searches users by query
  Future<void> searchUsers(String query) async {
    _searchQuery.value = query.trim();

    if (_searchQuery.value.isEmpty) {
      _filteredUsers.assignAll(_users);
      _updateState();
      return;
    }

    _isSearching.value = true;

    final result = await _userRepository.searchUsers(_searchQuery.value);

    result.fold((error) => _setError(error), (users) {
      _filteredUsers.assignAll(users);
      _updateState();
    });

    _isSearching.value = false;
  }

  /// Clears the search
  void clearSearch() {
    _searchQuery.value = '';
    _filteredUsers.assignAll(_users);
    _updateState();
  }

  /// Gets a user by ID
  UserEntity? getUserById(int id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Sets the loading state
  void _setLoading() {
    _state.value = UsersState.loading;
    _errorMessage.value = '';
  }

  /// Sets the error state
  void _setError(AppException error) {
    _state.value = UsersState.error;
    _errorMessage.value = error.message;
  }

  /// Updates the state based on data
  void _updateState() {
    if (_filteredUsers.isEmpty) {
      _state.value = UsersState.empty;
    } else {
      _state.value = UsersState.loaded;
    }
  }
}
