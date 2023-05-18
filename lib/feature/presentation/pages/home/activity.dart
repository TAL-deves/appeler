import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_andomie/widgets.dart';
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
      child: BlocConsumer<HomeController, AuthResponse>(
        listener: (context, state) {
          if (!state.isLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AuthActivity.route,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: const RawText(
                text: AppInfo.name,
                textColor: Colors.black,
                textSize: 20,
              ),
              actions: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        context.read<HomeController>().signOut();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withAlpha(05)
                        ),
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 8),
                        child: RawIcon(
                          icon: Icons.logout_outlined,
                          tint: Colors.black.withAlpha(150),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            body: const HomeBody(
              type: HomeBodyType.initial,
            ),
          );
        },
      ),
    );
  }
}
