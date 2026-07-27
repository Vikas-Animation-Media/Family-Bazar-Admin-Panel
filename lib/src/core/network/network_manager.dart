import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:family_bazar_admin_panel/src/core/utils/helpers/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class NetworkManager extends GetxController {
  final RxInt connectionType = 0.obs; // (0 = None, 1 = Wifi, 2 = Mobile/Ethernet)

  // Hardware connectivity instance and background listener
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();

    // Listen with error handling to prevent stream crashes
    _streamSubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (Object error, StackTrace stackTrace) {
        Sentry.captureException(
          Exception('Network Stream Error: $error'),
          stackTrace: stackTrace,
          withScope: (scope) => scope.setTag('layer', 'network_manager'),
        );
        debugPrint('--- [CRITICAL] Network Stream Error ---');
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      },
    );
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (e, stackTrace) {
      Sentry.captureException(
        Exception('PlatformException: Network Check Failed: $e'),
        stackTrace: stackTrace,
        withScope: (scope) => scope.setTag('layer', 'network_manager'),
      );
      debugPrint('--- [CRITICAL] PlatformException: Network Check Failed ---');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
    } catch (e, stackTrace) {
      Sentry.captureException(
        Exception('Unknown Error: Network Check Failed: $e'),
        stackTrace: stackTrace,
        withScope: (scope) => scope.setTag('layer', 'network_manager'),
      );
      debugPrint('--- [CRITICAL] Unknown Error: Network Check Failed ---');
      debugPrint(e.toString());
      debugPrint(stackTrace.toString());
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResultList) {
    if (isClosed) return; // Abort immediately if the controller is already destroyed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isClosed) return;

      if (connectivityResultList.contains(ConnectivityResult.none)) {
        connectionType.value = 0;
        DialogHelper.showOfflineDialog(); // Global alert when offline
      } else {
        // User is back online
        if (connectivityResultList.contains(ConnectivityResult.wifi)) {
          connectionType.value = 1;
        } else if (connectivityResultList.contains(ConnectivityResult.mobile) ||
            connectivityResultList.contains(ConnectivityResult.ethernet) ||
            connectivityResultList.contains(ConnectivityResult.vpn) ||
            connectivityResultList.contains(ConnectivityResult.other)) {
          connectionType.value = 2;
        }
        DialogHelper.dismissOfflineDialog(); // Dismiss the Alert Box if it's currently showing
      }
    });
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }
}
