import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../index.dart';

class HomeActivity extends StatelessWidget {
  static const String route = "/";
  static const String title = "Home";

  const HomeActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<HomeController>()),
      ],
      child: BlocConsumer<HomeController, AuthResponse<AuthInfo>>(
        listener: (context, state) {
          if (!state.isAuthenticated) {
            AppNavigator.of(context).goHome(
              AuthActivity.route,
              pathParams: {"name": "sign_in"},
            );
          }
        },
        builder: (context, state) {
          return const AppScreen(
            body: HomeFragmentBuilder(
              type: HomeBodyType.initial,
            ),
          );
        },
      ),
    );
  }
}
