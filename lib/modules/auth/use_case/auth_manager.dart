import 'package:dio/dio.dart';

import '../../../../index.dart';

abstract class AuthManager {
  Future<SignInResponse> signIn({
    required String phoneNumber,
    required String password,
  });

  Future<SignUpResponse> signUp({
    required String email,
    required String phoneNumber,
    required String password,
  });

  Future<CommonReceiveResponse?> signOut();

  Future<bool> forceSignOut();

  bool get isUserLoggedIn;
}

class AuthManagerImpl implements AuthManager {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final SavedUserUseCase savedUserUseCase;
  final ClearTokenUseCase clearTokenUseCase;
  final Dio dio;

  AuthManagerImpl({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.signUpUseCase,
    required this.savedUserUseCase,
    required this.clearTokenUseCase,
    required this.dio,
  });

  Future<void> refreshToken({
    required String? request,
    required Future<void> Function() onRecursion,
  }) async {
    final isPermitted = await AppAlertDialog.clearTokenAlertDialog(
      context: AppUtilities.curNavigationContext!,
      title: LocaleKeys.activeSessionFound,
      errorMessage: LocaleKeys.sameAccountMessage,
      errorCode: null,
    );
    if (isPermitted != null && isPermitted) {
      final response = await clearTokenUseCase.getData(request);
      if (response.result!.status! == 200) {
        return onRecursion.call();
      } else {
        return Future.error(response.result!.errMsg!);
      }
    } else {
      return Future.error('Operation cancel by user');
    }
  }

  @override
  Future<SignInResponse> signIn({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final info = AuthRequestInfo.signIn(
        phoneNumber: phoneNumber,
        password: password,
      );
      final response = await signInUseCase.getData(info.request());
      if (response.isSuccessful) {
        final saved = await savedUserUseCase.save(response);
        if (saved) {
          _setBearerToken(response.data.accessToken);
        } else {
          final refreshInfo = AuthRequestInfo.refreshToken(
            accessToken: response.data.accessToken,
            phoneNumber: phoneNumber,
            password: password,
          );
          await refreshToken(
            request: refreshInfo.request(),
            onRecursion: () => signIn(
              phoneNumber: phoneNumber,
              password: password,
            ),
          );
        }

        return response;
      } else {
        return Future.error(response.errorMessage);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<SignUpResponse> signUp({
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final info = AuthRequestInfo.signUp(
        email: email,
        phoneNumber: phoneNumber,
        password: password,
      );
      final response = await signUpUseCase.getData(info.request());
      if (response.isSuccessful) {
        return response;
      } else {
        return Future.error(response.errorMessage);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<CommonReceiveResponse?> signOut() async {
    try {
      final response = await signOutUseCase.getData(null);
      final statusCode = response.result?.status;
      if (statusCode != null && statusCode == 200 || statusCode == 202) {
        final isClearedUser = await clearUser();
        if (isClearedUser) {
          return response;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> forceSignOut() async {
    return await clearUser();
  }

  @override
  bool get isUserLoggedIn {
    final curUser = savedUserUseCase.curUser;
    if (curUser != null) {
      _setBearerToken(curUser.data.accessToken);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> clearUser() async {
    final isClearedUser = await savedUserUseCase.removeUser();
    if (isClearedUser) {
      _setBasicToken();
      return true;
    } else {
      return false;
    }
  }

  void _setBearerToken(String? token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void _setBasicToken() {
    dio.options.headers['Authorization'] = ApiInfo.authorization;
  }

}
