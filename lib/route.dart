import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'index.dart';

class AppRouter {
  AppRouter._();

  static AppRouter get I => AppRouter._();

  List<String> ignoreRedirections = [
    AboutActivity.route,
    '${AuthActivity.route}/:name',
    SplashActivity.route,
    WelcomeActivity.route,
  ];

  bool isRedirection(String? path) {
    return !ignoreRedirections.contains(path);
  }

  GoRouter get router => GoRouter(
        initialLocation: SplashActivity.route,
        errorBuilder: (context, state) => const ErrorScreen(),
        redirect: (context, state) async {
          if (kIsWeb && isRedirection(state.fullPath)) {
            final bool loggedIn = await locator<AuthHandler>().isSignIn();
            if (!loggedIn) {
              return WelcomeActivity.route;
            }
          }
          return null;
        },
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
              return BlocProvider(
                create: (context) => locator<AuthController>(),
                child: AuthActivity(
                  isFromWelcome: back.equals("true"),
                  type: type.equals("sign_up")
                      ? AuthFragmentType.signUp
                      : AuthFragmentType.signIn,
                ),
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
              var data = state.extra;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => locator<HomeController>()),
                ],
                child: HomeActivity(
                  id: data.getValue<String>("meeting_id"),
                ),
              );
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
                path: MeetingParticipantActivity.route,
                builder: (context, state) {
                  var data = state.extra;
                  var controller =
                      data.getValue<MeetingController>("MeetingController");
                  var id = data.getValue<String>("meeting_id");
                  if (controller != null) {
                    return BlocProvider.value(
                      value: controller,
                      child: MeetingParticipantActivity(meetingId: id),
                    );
                  } else {
                    return BlocProvider(
                      create: (context) => locator<MeetingController>(),
                      child: MeetingParticipantActivity(meetingId: id),
                    );
                  }
                },
              ),
              GoRoute(
                path: PrepareActivity.route,
                builder: (context, state) {
                  var data = state.extra;
                  var id = data.getValue("meeting_id");
                  var controller = data.getValue("HomeController");
                  return MultiBlocProvider(
                    providers: [
                      controller != null && controller is HomeController
                          ? BlocProvider.value(value: controller)
                          : BlocProvider(
                              create: (context) => locator<HomeController>(),
                            )
                    ],
                    child: PrepareActivity(
                      meetingId: id,
                      homeController: controller,
                    ),
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

  String withParent(String parent) {
    return "/$parent/$this";
  }
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
