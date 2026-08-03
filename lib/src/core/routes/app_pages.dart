import 'package:family_bazar_admin_panel/src/core/routes/app_routes.dart';
import 'package:family_bazar_admin_panel/src/modules/login/binding/login_binding.dart';
import 'package:family_bazar_admin_panel/src/modules/login/view/login_view.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();
  static const String initial = AppRoutes.login;
  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: LoginBinding(), transition: Transition.noTransition),
  ];
}
