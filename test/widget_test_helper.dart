import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_app/src/features/users/domain/repositories/user_repository.dart';
import 'package:movie_app/src/features/users/presentation/controllers/users_controller.dart';

/// Helper class for widget testing with GetX
class TestHelper {
  /// Creates a testable widget with GetX dependencies
  static Widget createTestableWidget({
    required Widget child,
    required UserRepository repository,
  }) {
    Get.testMode = true;

    // Clean up previous registrations
    Get.reset();

    // Register dependencies
    Get.put<UserRepository>(repository);
    Get.put<UsersController>(UsersController(userRepository: repository));

    return GetMaterialApp(home: child);
  }

  /// Clean up after test
  static void tearDown() {
    Get.reset();
  }
}
