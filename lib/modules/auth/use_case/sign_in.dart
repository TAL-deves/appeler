import 'package:flutter/foundation.dart';

import '../../../../index.dart';

class SignInUseCase extends CommonSendReceiveUseCase<SignInResponse> {
  SignInUseCase({
    required super.apiPath,
    required super.dio,
  });

  @override
  Future<SignInResponse> onCompute(String responseData) {
    return compute(_parseLoginResponse, responseData);
  }

  static Future<SignInResponse> _parseLoginResponse(String responseData) async {
    return SignInResponse.from(responseData);
  }
}
