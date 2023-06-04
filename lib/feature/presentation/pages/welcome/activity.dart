import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';

import '../../../../index.dart';

class WelcomeActivity extends StatelessWidget {
  static const String title = "Welcome";
  static const String route = "welcome";

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
            onSignIn: (context) => Navigator.pushNamed(
              context,
              AuthActivity.route,
              arguments: AuthFragmentType.signIn,
            ),
            onSignUp: (context) => Navigator.pushNamed(
              context,
              AuthActivity.route,
              arguments: AuthFragmentType.signUp,
            ),
            onJoinMeeting: (context) => Navigator.pushNamed(
              context,
              JoinActivity.route,
              arguments: AuthFragmentType.signIn,
            ),
          ),
        ),
      ),
    );
  }
}
