import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            onSignIn: (context) => context.push(AuthActivity.route),
            onSignUp: (context) => context.push(
              AuthActivity.route,
              extra: {
                "isFromWelcome": true,
                "type": AuthFragmentType.signUp,
              },
            ),
            onJoinMeeting: (context) => context.push(JoinActivity.route),
          ),
        ),
      ),
    );
  }
}
