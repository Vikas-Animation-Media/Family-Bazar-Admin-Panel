import 'package:family_bazar_admin_panel/src/modules/dashboard/controller/dashboard_coontroller.dart';
import 'package:family_bazar_admin_panel/src/modules/dashboard/modules/drawer/controller/drawer_controller.dart';
import 'package:family_bazar_admin_panel/src/modules/dashboard/modules/drawer/model/drawer_menu_model/drawer_menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerView extends GetView<DashboardDrawerController> {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Square edges look premium for Web Admin Panels
      ),
      child: Column(
        children: [
          // 1. Static Header: No need to rebuild this
          _buildDrawerHeader(context),

          // 2. Dynamic List Body
          Expanded(
            child: Obx(() {
              // Show a loader if the menu is still parsing
              if (controller.menuItems.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              // Use Efficient Lists: Lazy loading for performance optimization
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.menuItems.length,
                itemBuilder: (context, index) {
                  final item = controller.menuItems[index];
                  return _buildMenuItem(context, item);
                },
              );
            }),
          ),

          // 3. Static Footer
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  /// Builds the top branding/profile section
  Widget _buildDrawerHeader(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark, // Syncs with your centralized theme
      ),
      accountName: const Text(
        'Family Bazar Admin',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      accountEmail: const Text('Super Admin Role'),
      currentAccountPicture: const CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.admin_panel_settings_rounded, size: 40, color: Colors.blueGrey),
      ),
    );
  }

  /// Evaluates whether to build an ExpansionTile (Master) or a normal ListTile
  Widget _buildMenuItem(BuildContext context, DrawerMenuModel item) {
    if (item.isExpansion && item.subItems != null) {
      return ExpansionTile(
        leading: _buildIcon(item),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        // Recursively build sub-items
        children: item.subItems!.map((subItem) => _buildSubMenuItem(context, subItem)).toList(),
      );
    }

    return ListTile(
      leading: _buildIcon(item),
      title: Text(item.title),
      onTap: () {
        Get.find<DashboardController>().changeActiveMenu(item.identifier);
        if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
          Get.back(); // Automatically close drawer on mobile screens after selection
        }
      },
    );
  }

  /// Builds indented sub-items inside Master categories
  Widget _buildSubMenuItem(BuildContext context, DrawerMenuModel item) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 56.0, right: 16.0), // Indented padding
      leading: _buildIcon(item, size: 20.0),
      title: Text(item.title, style: const TextStyle(fontSize: 13.0)),
      onTap: () {
        Get.find<DashboardController>().changeActiveMenu(item.identifier);
        if (Scaffold.of(context).hasDrawer && Scaffold.of(context).isDrawerOpen) {
          Get.back(); // Automatically close drawer on mobile screens after selection
        }
      },
    );
  }

  /// Zero-Tolerance Crash Handler for Network Images
  Widget _buildIcon(DrawerMenuModel item, {double size = 24.0}) {
    // Attempt to load network image if string exists
    if (item.icon != null && item.icon!.isNotEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Image.network(
          item.icon!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Defensive Tactics: If CORS blocks the image or the URL is dead, fallback silently
            return Icon(item.fallbackIcon ?? Icons.error_outline, size: size, color: Colors.grey);
          },
        ),
      );
    }

    // Default Native Icon Fallback
    return Icon(item.fallbackIcon ?? Icons.circle_outlined, size: size, color: Colors.grey[700]);
  }

  Widget _buildDrawerFooter() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}