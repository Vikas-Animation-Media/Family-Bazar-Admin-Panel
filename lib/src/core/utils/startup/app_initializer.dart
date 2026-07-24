import 'package:flutter/material.dart';

class AppInitializer {
  AppInitializer._();

  static Future<void> init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized(); // 1. Mandatory requirement before using SystemChrome or native platform channels
      debugPrint('--- [SYSTEM] Web App Core Initialization Completed Safely ---');
    } catch (e, stackTrace) {
      debugPrint('==================================================');
      debugPrint('--- [CRITICAL FATAL] WEB APP INITIALIZATION EXCEPTION ---');
      debugPrint('Exception: ${e.toString()}');
      debugPrint('StackTrace: ${stackTrace.toString()}');
      debugPrint('==================================================');

      // Rethrow to allow the main.dart runZonedGuarded boundary to catch and log the failure.
      rethrow;
    }
  }
}
