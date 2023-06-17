import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

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
        onRoute: (context) {
          locator<AuthHandler>().isSignIn().then((value) {
            if (value) {
              AppNavigator.of(context).goHome(
                HomeActivity.route,
                extra: AuthHelper.uid,
              );
            } else {
              AppNavigator.of(context).goHome(
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
