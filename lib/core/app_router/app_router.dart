import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:appeler/modules/auth/phone/page.dart';
import 'package:appeler/modules/calling/screen/calling_screen.dart';
import 'package:flutter/material.dart';
import '../../modules/home/screen/home_screen.dart';
import '';

const kDefaultRoute = '/';

const appRouter = AppRouter();

class AppRouter{
  const AppRouter();

  Route? onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case kDefaultRoute:
        if(AuthManagementUseCase.isUserLoggedIn()){
          return MaterialPageRoute(
            builder: (context) => const AppHomeScreen(),
          );
        }
        else{
          return MaterialPageRoute(
            builder: (context) => const AuthPhonePage(),
          );
        }
      case authScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const AuthPhonePage(),
        );
      case homeScreenRoute:
        return MaterialPageRoute(
          builder: (context) => const AppHomeScreen(),
        );
      case callingScreenRoute:
        final curId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => CallingScreen(id: curId),
        );
      default:
        return null;
    }
  }

}