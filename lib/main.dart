import 'dart:async';
import 'dart:ui';

import 'package:family_bazar_admin_panel/src/core/const/app_strings.dart';
import 'package:family_bazar_admin_panel/src/core/initial_bindings/initial_bindings.dart';
import 'package:family_bazar_admin_panel/src/core/theme/app_theme.dart';
import 'package:family_bazar_admin_panel/src/core/utils/startup/app_initializer.dart';
import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  runZonedGuarded(
    () async {
      try {
        WidgetsFlutterBinding.ensureInitialized();

        /// Global UI Error Handling
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.presentError(details);
          debugPrint('==================================================');
          debugPrint('--- [CRITICAL FATAL] FLUTTER UI EXCEPTION ---');
          debugPrint(details.exceptionAsString());
          debugPrint(details.stack?.toString());
          debugPrint('==================================================');
        };

        await AppInitializer.init();
        await Get.putAsync<StorageService>(() async => await StorageService().init(), permanent: true);
        runApp(const FamilyBazarAdminApp());
      } catch (e, stackTrace) {
        debugPrint('--- [CRITICAL FATAL] MAIN INITIALIZATION FAILED ---');
        debugPrint(e.toString());
        debugPrint(stackTrace.toString());
      }
    },
    (error, stackTrace) {
      debugPrint('==================================================');
      debugPrint('--- [CRITICAL FATAL] UNHANDLED ASYNC EXCEPTION ---');
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
      debugPrint('==================================================');
    },
  );
}

class FamilyBazarAdminApp extends StatelessWidget {
  const FamilyBazarAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(400, 850), // Mobile baseline (400x850).
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true, // Ensures the app allows proper resizing logic when browser window changes
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: 'AppRoutes.initial',
          initialBinding: InitialBindings(),
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            },
            physics: const BouncingScrollPhysics(),
          ),
          getPages: [],
          defaultTransition: Transition.fadeIn,
        );
      },
    );
  }
}
