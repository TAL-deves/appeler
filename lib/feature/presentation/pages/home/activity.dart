import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../index.dart';

class HomeActivity extends StatelessWidget {
  static const String route = "/";
  static const String title = "Home";

  const HomeActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeController, AuthResponse<AuthInfo>>(
      listener: (context, state) async {
        if (state.isUnauthenticated) {
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
    );
  }

}
