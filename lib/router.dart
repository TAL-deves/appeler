import 'package:appeler/modules_old/calling/screen/calling_screen.dart';
import 'package:appeler/modules_old/group_calling/screen/for_client/group_calling_client_screen.dart';
import 'package:appeler/modules_old/group_calling/screen/for_host/group_calling_host_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'index.dart';

const kDefaultRoute = '/';

class AppRouter {
  const AppRouter._();

  static AuthManager get loginManagementUseCase =>
      di<AuthManager>();

  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kDefaultRoute:
      case HomePage.route:
        if (loginManagementUseCase.isUserLoggedIn) {
          return MaterialPageRoute(
            builder: (context) => const HomePage(),
          );
        } else {
          return MaterialPageRoute(builder: (context) => const SignInPage());
        }
      case SignInPage.route:
        return MaterialPageRoute(
          builder: (context) => const SignInPage(),
        );
      case SignUpPage.route:
        return MaterialPageRoute(
          builder: (context) => const SignUpPage(),
        );
      case AuthPhonePage.route:
        return MaterialPageRoute(
          builder: (context) => const AuthPhonePage(),
        );
      case callingScreenRoute:
        final curList = settings.arguments as List<dynamic>;
        final curId = curList[0];
        final callEnum = curList[1];
        return MaterialPageRoute(
          builder: (context) => CallingScreen(id: curId, callEnum: callEnum),
        );
      case groupCallingHostScreenRoute:
        final curList = settings.arguments
            as List<QueryDocumentSnapshot<Map<String, dynamic>>>;
        return MaterialPageRoute(
          builder: (context) => GroupCallingHostScreen(curList: curList),
        );
      case groupCallingClientScreenRoute:
        final callerHostId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (context) =>
              GroupCallingClientScreen(callerHostId: callerHostId),
        );
      default:
        return null;
    }
  }
}
