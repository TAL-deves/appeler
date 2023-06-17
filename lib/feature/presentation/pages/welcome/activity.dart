import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import '../../../../index.dart';

class WelcomeActivity extends StatelessWidget {
  static const String title = "Welcome";
  static const String route = "/welcome";

  const WelcomeActivity({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      body: ResponsiveLayout(
        mobile: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: WelcomeFragment(
            onSignIn: (context) => AppNavigator.of(context).go(
              AuthActivity.route,
              pathParams: {"name": "sign_in"},
            ),
            onSignUp: (context) => AppNavigator.of(context).go(
              AuthActivity.route,
              pathParams: {"name": "sign_up"},
              queryParams: {"back": "true"},
            ),
            onJoinMeeting: (context) => AppNavigator.of(context).go(
              JoinActivity.route,
            ),
          ),
        ),
      ),
    );
  }
}
