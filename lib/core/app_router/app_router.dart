import 'package:appeler/modules/auth/phone/page.dart';
import 'package:flutter/material.dart';
import '../../modules/home/screen/home_screen.dart';

const kDefaultRoute = '/';

const appRouter = AppRouter();

class AppRouter{
  const AppRouter();

  Route? onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case kDefaultRoute:
        return MaterialPageRoute(
          builder: (context) => const AuthPhonePage(),
        );
      case homeScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const AppHomeScreen(),
        );
      default:
        return null;
    }
  }

}