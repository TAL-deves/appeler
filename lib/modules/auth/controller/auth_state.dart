import 'package:equatable/equatable.dart';

import '../../../index.dart';

class AuthState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final SignInResponse? signInResponse;
  final SignUpResponse? signUpResponse;

  const AuthState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    this.signInResponse,
    this.signUpResponse,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    SignInResponse? signInResponse,
    SignUpResponse? signUpResponse,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      signInResponse: signInResponse,
      signUpResponse: signUpResponse,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        hasError,
        errorMessage,
        signInResponse,
        signUpResponse,
      ];

  @override
  String toString() {
    return 'LoginState{isLoading: $isLoading, hasError: $hasError, errorMessage: $errorMessage, signInResponse: $signInResponse, signUpResponse: $signUpResponse}';
  }
}
