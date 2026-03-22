import 'package:get/get.dart';

import '../../features/users/presentation/pages/user_detail_page.dart';
import '../../features/users/presentation/pages/users_page.dart';

/// App routes
class AppPages {
  AppPages._();

  static const String initial = Routes.users;

  static final routes = [
    GetPage(name: Routes.users, page: () => const UsersPage()),
    GetPage(name: Routes.userDetail, page: () => const UserDetailPage()),
  ];
}

/// Route names
abstract class Routes {
  Routes._();

  static const String users = '/';
  static const String userDetail = '/user/:id';
}
