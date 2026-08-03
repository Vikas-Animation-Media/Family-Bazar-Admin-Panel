// import 'package:family_bazar_admin_panel/src/core/network/api_client.dart';
// import 'package:family_bazar_admin_panel/src/core/utils/device/device_meta_service.dart';
// import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
// import 'package:family_bazar_admin_panel/src/modules/login/controller/login_controller.dart';
// import 'package:family_bazar_admin_panel/src/modules/login/repository/login_repository.dart';
// import 'package:get/get.dart';
//
// class LoginBinding extends Bindings {
//   @override
//   void dependencies() {
//     final ApiClient apiClient = ApiClient();
//     final StorageService storageService = Get.find<StorageService>();
//     final DeviceMetaService deviceMetaService = DeviceMetaService(apiClient.dio);
//     final LoginRepository loginRepository = LoginRepository(apiClient);
//
//     Get.lazyPut<LoginController>(() => LoginController(loginRepository, storageService, deviceMetaService));
//   }
// }

// lib/src/modules/login/bindings/login_binding.dart

import 'package:family_bazar_admin_panel/src/core/network/api_client.dart';
import 'package:family_bazar_admin_panel/src/core/utils/device/device_meta_service.dart';
import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:family_bazar_admin_panel/src/modules/login/controller/login_controller.dart';
import 'package:family_bazar_admin_panel/src/modules/login/repository/login_repository.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Zero-Tolerance Observability: Track dependency injection pipeline
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'Initializing LoginBinding dependencies',
        category: 'binding.init',
        level: SentryLevel.info,
      ),
    );

    // 2. Core Services (Singleton Access)
    final ApiClient apiClient = ApiClient();
    final StorageService storageService = Get.find<StorageService>();

    // 3. Strict Separation of Concerns: Network Layer Decoupling
    // SECURITY LOCK: Inject externalDio into DeviceMetaService to prevent leaking internal JWT Bearer tokens to third-party domains (e.g., ipinfo.io).
    final DeviceMetaService deviceMetaService = DeviceMetaService(apiClient.externalDio);

    // Inject internal authenticated dio client strictly for backend repository communication.
    final LoginRepository loginRepository = LoginRepository(apiClient);

    // 4. Proactive Memory Management: Lazy Controller Instantiation
    Get.lazyPut<LoginController>(
          () => LoginController(
        loginRepository,
        storageService,
        deviceMetaService,
      ),
      fenix: true, // Ensures the controller is cleanly recreated if the route is revisited after disposal
    );
  }
}
