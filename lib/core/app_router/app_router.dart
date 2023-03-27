import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:appeler/modules/auth/phone/page.dart';
import 'package:appeler/modules/calling/screen/calling_screen.dart';
import 'package:appeler/modules/group_calling/screen/group_calling_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../modules/home/screen/home_screen.dart';


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
        final curList = settings.arguments as List<dynamic>;
        final curId = curList[0];
        final callEnum = curList[1];
        return MaterialPageRoute(
          builder: (context) => CallingScreen(id: curId, callEnum: callEnum),
        );
      case groupCallingScreenRoute:
        final curList = settings.arguments as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
        return MaterialPageRoute(
          builder: (context) => GroupCallingScreen(curList: curList),
        );
      default:
        return null;
    }
  }

}