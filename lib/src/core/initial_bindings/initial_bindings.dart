import 'package:family_bazar_admin_panel/src/core/network/network_manager.dart';
import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    try {
      // This ensures that the app will not proceed until Storage is loaded into memory.
      Get.putAsync<StorageService>(() async => await StorageService().init(), permanent: true);
      Get.put<NetworkManager>(NetworkManager(), permanent: true); // Global Network Monitoring: Locked permanently.
    } catch (error, stackTrace) {
      debugPrint('==================================================');
      debugPrint('--- [CRITICAL FATAL] BINDING INJECTION FAILED ---');
      debugPrint('Exception: ${error.toString()}');
      debugPrint('StackTrace: ${stackTrace.toString()}');
      debugPrint('==================================================');
    }
  }
}
