import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

final di = GetIt.I;

Future<void> registerAllDependency() async {
  _registerLogin();
  _registerDio();
  _registerSharedPref();
  await di.allReady();
}

void _registerSharedPref() {
  di.registerSingletonAsync<SharedPreferences>(
      () async => await SharedPreferences.getInstance());
}

void _registerLogin() {
  di.registerLazySingleton<SavedUserUseCase>(
      () => SavedUserUseCaseImp(sharedPreferences: di()));
  di.registerLazySingleton<SignInUseCase>(
      () => SignInUseCase(apiPath: ApiInfo.login, dio: di()));
  di.registerLazySingleton<SignUpUseCase>(
      () => SignUpUseCase(apiPath: ApiInfo.register, dio: di()));
  di.registerLazySingleton<SignOutUseCase>(
      () => SignOutUseCase(apiPath: ApiInfo.logout, dio: di()));
  di.registerLazySingleton<ClearTokenUseCase>(
      () => ClearTokenUseCase(apiPath: ApiInfo.clearToken, dio: di()));
  di.registerLazySingleton<AuthManager>(() => AuthManagerImpl(
        clearTokenUseCase: di(),
        savedUserUseCase: di(),
        signInUseCase: di(),
        signUpUseCase: di(),
        signOutUseCase: di(),
        dio: di(),
      ));

  di.registerFactory<AuthCubit>(
      () => AuthCubit(authManager: di()));
}

var loggingOutProgress = false;

void _registerDio() {
  di.registerLazySingleton<BaseOptions>(() => BaseOptions(
        baseUrl: ApiInfo.appBaseUrl,
        responseType: ResponseType.plain,
        connectTimeout: const Duration(seconds: 15),
        // TODO : 15 * 1000
        receiveTimeout: const Duration(seconds: 15),
        // TODO: 15 * 1000
        validateStatus: (status) => status! < 500,
        headers: {'Authorization': ApiInfo.authorization},
      ));
  di.registerLazySingleton<Dio>(
    () => Dio(di())
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.next(options);
          },
          onResponse: (response, handler) async {
            final curData =
                await AppEncryptionUtilities.getJsonFromApiData(response.data);
            if (curData.contains('Token not found') ||
                curData.contains('No token in DB') ||
                curData.contains('token is expired')) {
              if (!loggingOutProgress) {
                loggingOutProgress = true;
                if (AppAlertDialog.logoutDialogIsOpen) {
                  AppUtilities.popTopWidget();
                  AppAlertDialog.logoutDialogIsOpen = false;
                }
                AppSnackBar.showFailureSnackBar(
                  message:
                      'Session expired due to inactivity, Please login again!',
                );
                await Future.delayed(const Duration(milliseconds: 1500));
                AppUtilities.forceLogoutFromApplication();
                loggingOutProgress = false;
              }
            } else {
              handler.next(Response(
                requestOptions: response.requestOptions,
                redirects: response.redirects,
                isRedirect: response.isRedirect,
                statusCode: response.statusCode,
                statusMessage: response.statusMessage,
                extra: response.extra,
                headers: response.headers,
                data: curData,
              ));
            }
          },
          onError: (error, handler) {
            final customDioError = CustomDioError(
              requestOptions: error.requestOptions,
              error: error.error,
              message: error.message,
              response: error.response,
              stackTrace: error.stackTrace,
              type: error.type,
            );
            handler.next(customDioError);
          },
        ),
      ),
  );
}
