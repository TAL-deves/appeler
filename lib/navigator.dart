import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class AppNavigator {
  final BuildContext context;

  const AppNavigator._(this.context);

  factory AppNavigator.of(BuildContext context) => AppNavigator._(context);

  void go(
    String route, {
    Object? extra,
    Map<String, String> pathParams = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    if (pathParams.isNotEmpty || queryParams.isNotEmpty) {
      if (kIsWeb) {
        context.goNamed(
          route,
          extra: extra,
          pathParameters: pathParams,
          queryParameters: queryParams,
        );
      } else {
        context.pushNamed(
          route,
          extra: extra,
          pathParameters: pathParams,
          queryParameters: queryParams,
        );
      }
    } else {
      if (kIsWeb) {
        context.go(route, extra: extra);
      } else {
        context.push(route, extra: extra);
      }
    }
  }

  void goHome(
    String route, {
    Object? extra,
    Map<String, String> pathParams = const <String, String>{},
    Map<String, dynamic> queryParams = const <String, dynamic>{},
  }) {
    if (pathParams.isNotEmpty || queryParams.isNotEmpty) {
      if (kIsWeb) {
        Router.neglect(context, () {
          context.goNamed(
            route,
            extra: extra,
            pathParameters: pathParams,
            queryParameters: queryParams,
          );
        });
      } else {
        context.pushReplacementNamed(
          route,
          extra: extra,
          pathParameters: pathParams,
          queryParameters: queryParams,
        );
      }
    } else {
      if (kIsWeb) {
        Router.neglect(context, () {
          context.go(route, extra: extra);
        });
      } else {
        context.pushReplacement(route, extra: extra);
      }
    }
  }

  void goBack([Object? result]) {
    context.pop(result);
  }
}
