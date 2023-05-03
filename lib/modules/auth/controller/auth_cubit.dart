import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthManager authManager;

  AuthCubit({
    required this.authManager,
  }) : super(const AuthState());

  var _isLoading = false;

  void _emitLoading() {
    emit(state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: '',
    ));
  }

  void _emitErrorMessage({
    required String errorMessage,
  }) {
    emit(state.copyWith(
      isLoading: false,
      hasError: true,
      errorMessage: errorMessage,
    ));
  }

  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    if (!_isLoading) {
      _isLoading = true;
      _emitLoading();
      try {
        final response = await authManager.signIn(
          phoneNumber: phoneNumber,
          password: password,
        );
        emit(state.copyWith(
          isLoading: false,
          hasError: false,
          signInResponse: response,
        ));
      } catch (e) {
        _emitErrorMessage(errorMessage: e.toString());
      }
      _isLoading = false;
    }
    return true;
  }

  Future<bool> register({
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    if (!_isLoading) {
      _isLoading = true;
      _emitLoading();
      try {
        final response = await authManager.signUp(
          email: email,
          phoneNumber: phoneNumber,
          password: password,
        );
        emit(state.copyWith(
          isLoading: false,
          hasError: false,
          signUpResponse: response,
        ));
      } catch (e) {
        _emitErrorMessage(errorMessage: e.toString());
      }
      _isLoading = false;
    }
    return true;
  }

  Future<bool> forgotPassword({
    required String phoneNumber,
    required String password,
  }) async {
    return true;
  }
}
