import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:go_router/go_router.dart';

import '../../../../index.dart';

class SplashActivity extends StatelessWidget {
  static const String title = "Splash";
  static const String route = "/splash";

  const SplashActivity({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: AppSplashView(
        title: AppInfo.name,
        titleAllCaps: true,
        titleExtraSize: 2,
        titleSize: 24,
        titleColor: AppColors.secondary,
        subtitle: AppInfo.description,
        logo: AppInfo.logo,
        logoColor: AppColors.primary,
        onRoute: (c) {
          locator<AuthHandler>().isSignIn().then((value) {
            if (value) {
              context.pushReplacement(
                HomeActivity.route,
                extra: AuthHelper.uid,
              );
            } else {
              context.pushReplacement(
                WelcomeActivity.route,
                extra: AuthHelper.uid,
              );
            }
          });
        },
      ),
    );
  }
}
