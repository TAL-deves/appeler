import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeActivity extends StatelessWidget {
  static const String route = "home";
  static const String title = "Home";

  const HomeActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => locator<HomeController>()),
      ],
      child: BlocConsumer<HomeController, Response<AuthInfo>>(
        listener: (context, state) {
          if (!state.isSuccessful) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AuthActivity.route,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return const AppScreen(
            child: HomeBody(
              type: HomeBodyType.initial,
            ),
          );
        },
      ),
    );
  }
}
