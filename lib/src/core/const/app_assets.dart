import 'package:flutter/foundation.dart';

@immutable
abstract final class AppAssets {
  const AppAssets._();

  /// Base paths
  static const String _baseImagePath = 'assets/images';

  /// Branding Assets
  static const String appLogo = '$_baseImagePath/app_logo.png';
}