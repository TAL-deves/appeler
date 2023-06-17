import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:go_router/go_router.dart';

import 'index.dart';

class AppRouter {
  const AppRouter._();

  static AppRouter get I => const AppRouter._();

  GoRouter get router => GoRouter(
        initialLocation: SplashActivity.route,
        errorBuilder: (context, state) => const ErrorScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: SplashActivity.route,
            builder: (context, state) {
              return const SplashActivity();
            },
          ),
          GoRoute(
            name: AuthActivity.route,
            path: '${AuthActivity.route}/:name',
            builder: (context, state) {
              var type = state.pathParameters.getValue<String>("name");
              var back = state.queryParameters.getValue<String>("back");
              return AuthActivity(
                isFromWelcome: back.equals("true"),
                type: type.equals("sign_up")
                    ? AuthFragmentType.signUp
                    : AuthFragmentType.signIn,
              );
            },
          ),
          GoRoute(
            path: WelcomeActivity.route,
            builder: (context, state) {
              return const WelcomeActivity();
            },
          ),
          GoRoute(
            path: AboutActivity.route,
            builder: (context, state) {
              var data = state.extra;
              return AboutActivity(
                type: data.getValue<AboutFragmentType>("type"),
              );
            },
          ),
          GoRoute(
            path: HomeActivity.route,
            builder: (context, state) {
              return const HomeActivity();
            },
            routes: <RouteBase>[
              GoRoute(
                path: MeetingActivity.route,
                builder: (context, state) {
                  var data = state.extra;
                  return MeetingActivity(
                    data: data.getValue("data"),
                    homeController: data.getValue("HomeController"),
                  );
                },
              ),
              GoRoute(
                path: JoinActivity.route,
                builder: (context, state) {
                  var data = state.extra;
                  return JoinActivity(
                    homeController: data.getValue("HomeController"),
                  );
                },
              ),
              GoRoute(
                path: PrepareActivity.route,
                builder: (context, state) {
                  var data = state.extra;
                  return PrepareActivity(
                    meetingId: data.getValue("meeting_id"),
                    homeController: data.getValue("HomeController"),
                  );
                },
              ),
            ],
          ),
        ],
      );
}

extension AppRouterPathExtension on String {
  String get withSlash => "/$this";
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "No screen found!",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
