import 'package:auth_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        bottom: TextView(
          marginBottom: 40,
          textAlign: TextAlign.center,
          textColor: Colors.grey,
          textSize: 12,
          text:
              'Powered by Tech Analytica Limited || Version ${locator<PackageInfo>().version}',
        ),
        onRoute: (context) {
          locator<AuthHandler>().isSignIn().then((value) {
            if (value) {
              AppCurrentNavigator.of(context).goHome(HomeActivity.route);
            } else {
              AppCurrentNavigator.of(context).goHome(
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
