import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../features/users/data/datasources/user_remote_data_source.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/repositories/user_repository.dart';
import '../../features/users/presentation/controllers/users_controller.dart';
import '../network/api_client.dart';

/// Dependency injection bindings
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core
    Get.lazyPut<Logger>(() => Logger(), fenix: true);

    // API Client
    Get.lazyPut<ApiClient>(
      () => ApiClient(logger: Get.find<Logger>()),
      fenix: true,
    );

    // Data sources
    Get.lazyPut<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(apiClient: Get.find<ApiClient>()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(
        remoteDataSource: Get.find<UserRemoteDataSource>(),
      ),
      fenix: true,
    );

    // Controllers
    Get.lazyPut<UsersController>(
      () => UsersController(userRepository: Get.find<UserRepository>()),
      fenix: true,
    );
  }
}
