import 'dart:convert';
import 'dart:developer' as developer;

import 'package:family_bazar_admin_panel/src/core/base_controller/base_controller.dart';
import 'package:family_bazar_admin_panel/src/core/utils/storage/storage_services.dart';
import 'package:family_bazar_admin_panel/src/modules/dashboard/modules/drawer/model/drawer_menu_model/drawer_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardDrawerController extends BaseController {
  final StorageService _storageService;
  DashboardDrawerController(this._storageService);

  final RxList<DrawerMenuModel> menuItems = <DrawerMenuModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _parseAndBuildMenu();
  }

  void _parseAndBuildMenu() {
    try {
      final String? userDataJson = _storageService.getString('user_data');
      if (userDataJson == null || userDataJson.isEmpty) {
        throw Exception("User data string is null or empty in storage.");
      }

      final Map<String, dynamic> userDataMap = jsonDecode(userDataJson);

      // Extracting the "permissions" block specifically
      final Map<String, dynamic>? apiPermissions = userDataMap['permissions'] as Map<String, dynamic>?;

      if (apiPermissions == null || apiPermissions.isEmpty) {
        throw Exception("Permissions object is missing or empty in user data.");
      }

      List<DrawerMenuModel> builtMenu = [];
      List<DrawerMenuModel> masterSubItems = [];

      builtMenu.add(const DrawerMenuModel(title: 'Dashboard', identifier: 'dashboard', fallbackIcon: Icons.dashboard_rounded));

      apiPermissions.forEach((key, value) {
        // Safe extraction of network image URL (can be null)
        final String? apiIconUrl = value['icon'] as String?;

        if (key.toLowerCase().startsWith('master')) {
          masterSubItems.add(
            DrawerMenuModel(
              title: _formatMasterTitle(key),
              identifier: key,
              icon: apiIconUrl,
              fallbackIcon: Icons.subdirectory_arrow_right_rounded,
            ),
          );
        } else {
          builtMenu.add(DrawerMenuModel(title: key, identifier: key, icon: apiIconUrl, fallbackIcon: _getFallbackIcon(key)));
        }
      });

      // Master Group if it has children
      if (masterSubItems.isNotEmpty) {
        builtMenu.insert(
          1, // Place right after Dashboard
          DrawerMenuModel(
            title: 'Master Settings',
            identifier: 'master_group',
            fallbackIcon: Icons.admin_panel_settings_rounded,
            isExpansion: true,
            subItems: masterSubItems,
          ),
        );
      }

      // 6. Memory Safe Update: Rebuilds UI exactly 1 time
      menuItems.assignAll(builtMenu);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to parse Drawer Menu Permissions from Storage',
        error: e,
        stackTrace: stackTrace,
        name: 'DashboardDrawerController',
      );

      // Fallback UI to prevent blank screen in case of storage corruption
      menuItems.assignAll([
        const DrawerMenuModel(title: 'Dashboard', identifier: 'dashboard', fallbackIcon: Icons.dashboard_rounded),
      ]);
    }
  }

  String _formatMasterTitle(String key) {
    if (key.length > 6) {
      String formatted = key.substring(6);
      return formatted.replaceAll(RegExp(r'(?<!^)(?=[A-Z])'), ' ');
    }
    return key;
  }

  IconData _getFallbackIcon(String key) {
    switch (key.toLowerCase()) {
      case 'store':
        return Icons.storefront_rounded;
      case 'product':
        return Icons.inventory_2_rounded;
      case 'order':
        return Icons.shopping_cart_rounded;
      case 'customer':
        return Icons.people_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'settings':
        return Icons.settings_rounded;
      case 'reports':
        return Icons.analytics_rounded;
      case 'delivery boy':
        return Icons.delivery_dining_rounded;
      case 'policy':
        return Icons.policy_rounded;
      default:
        return Icons.circle_outlined;
    }
  }
}
