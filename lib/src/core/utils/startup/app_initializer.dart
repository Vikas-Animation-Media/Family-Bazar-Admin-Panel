import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized(); // 1. Mandatory requirement before using SystemChrome or native platform channels
      await GetStorage.init();
      Get.put<StorageService>(StorageService(), permanent: true);
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: 'Web App Core Initialization Completed Safely',
          category: 'system.boot',
          level: SentryLevel.info,
        ),
      );
      debugPrint('--- [SYSTEM] Web App Core Initialization Completed Safely ---');
    } catch (e, stackTrace) {
      // Capture fatal startup crashes instantly before passing to global guard
      Sentry.captureException(
        Exception('CRITICAL FATAL: Web App Initialization Exception - $e'),
        stackTrace: stackTrace,
        withScope: (scope) => scope.setTag('layer', 'app_initializer'),
      );
      debugPrint('==================================================');
      debugPrint('--- [CRITICAL FATAL] WEB APP INITIALIZATION EXCEPTION ---');
      debugPrint('Exception: ${e.toString()}');
      debugPrint('StackTrace: ${stackTrace.toString()}');
      debugPrint('==================================================');

      rethrow; // Rethrow to allow the main.dart runZonedGuarded boundary to catch and log the failure.
    }
  }
}
