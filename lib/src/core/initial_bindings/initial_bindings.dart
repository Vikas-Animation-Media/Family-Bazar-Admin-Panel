import 'package:family_bazar_admin_panel/src/core/network/network_manager.dart';
import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    try {
      // This ensures that the app will not proceed until Storage is loaded into memory.
      Get.putAsync<StorageService>(() async => await StorageService().init(), permanent: true);
      Get.put<NetworkManager>(NetworkManager(), permanent: true); // Global Network Monitoring: Locked permanently.
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: 'Global Dependencies Injected Successfully',
          category: 'system.bindings',
          level: SentryLevel.info,
        )
      );
    } catch (error, stackTrace) {
      // Capture critical DI failures before they cause silent app deaths
      Sentry.captureException(
        Exception('CRITICAL FATAL: Binding Injection Failed - $error'),
        stackTrace: stackTrace,
        withScope: (scope) => scope.setTag('layer', 'initial_bindings'),
      );
      debugPrint('==================================================');
      debugPrint('--- [CRITICAL FATAL] BINDING INJECTION FAILED ---');
      debugPrint('Exception: ${error.toString()}');
      debugPrint('StackTrace: ${stackTrace.toString()}');
      debugPrint('==================================================');
    }
  }
}
