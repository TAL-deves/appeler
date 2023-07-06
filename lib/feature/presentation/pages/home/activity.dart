import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeActivity extends StatelessWidget {
  static const String route = "/app";
  static const String title = "Home";
  final String? id;

  const HomeActivity({
    Key? key,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeController, AuthResponse<AuthInfo>>(
      listener: (context, state) async {
        if (state.isUnauthenticated) {
          AppNavigator.of(context).goHome(
            AuthActivity.route,
            path: AuthSignInFragment.route,
          );
        }
      },
      builder: (context, state) {
        return AppScreen(
          body: HomeFragmentBuilder(
            id: id,
            type: HomeBodyType.initial,
          ),
        );
      },
    );
  }
}
