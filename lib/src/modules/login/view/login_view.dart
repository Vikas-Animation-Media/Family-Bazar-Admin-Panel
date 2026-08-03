import 'package:family_bazar_admin_panel/src/core/const/app_strings.dart';
import 'package:family_bazar_admin_panel/src/core/utils/extensions/style_extensions.dart';
import 'package:family_bazar_admin_panel/src/modules/login/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.responsiveWidth(50, 0), vertical: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.responsiveWidth(context.screenWidth * 2.5, 450)),
            child: Container(
              decoration: context.defaultDecoration,
              padding: EdgeInsets.all(context.responsiveSize(50, 40)),
              child: AutofillGroup(
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .stretch,
                    children: [
                      // LOGO & TITLE
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        size: context.responsiveSize(160, 80),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: context.responsiveHeight(16, 24)),
                      Text(AppStrings.adminLogin, textAlign: TextAlign.center, style: context.mainHeadingTextStyle),
                      SizedBox(height: context.responsiveHeight(32, 40)),
                
                      // USERNAME FIELD
                      TextFormField(
                        controller: controller.userNameController,
                        style: context.bodyTextStyle,
                        textInputAction: .next,
                        autofillHints: const [AutofillHints.username],
                        decoration: InputDecoration(
                          labelText: AppStrings.username,
                          labelStyle: context.bodyTextStyle,
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(borderRadius: context.responsiveRadius(10, 10)),
                        ),
                        validator: (value) => (value == null || value.trim().isEmpty) ? AppStrings.requiredField : null,
                      ),
                      SizedBox(height: context.responsiveHeight(24, 24)),
                
                      // PASSWORD FIELD
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          style: context.bodyTextStyle,
                          textInputAction: .done,
                          autofillHints: const [AutofillHints.password],
                          onFieldSubmitted: (_) => controller.login(),
                          decoration: InputDecoration(
                            labelText: AppStrings.password,
                            labelStyle: context.bodyTextStyle,
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: context.responsiveRadius(10, 10)),
                            suffixIcon: IconButton(
                              icon: Icon(controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off),
                              onPressed: controller.togglePasswordVisibility,
                            ),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty) ? AppStrings.requiredField : null,
                        ),
                      ),
                      SizedBox(height: context.responsiveHeight(16, 20)),
                
                      // SECURITY DISCLAIMER
                      Text(AppStrings.loginDisclaimer, style: context.subTitleStyle, textAlign: TextAlign.center),
                      SizedBox(height: context.responsiveHeight(32, 40)),
                
                      // SUBMIT BUTTON
                      ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: context.responsiveHeight(16, 20)),
                          shape: RoundedRectangleBorder(borderRadius: context.responsiveRadius(12, 8)),
                        ),
                        child: Text(AppStrings.login, style: context.titleStyleActive.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
