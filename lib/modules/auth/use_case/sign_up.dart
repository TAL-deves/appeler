import 'package:flutter/foundation.dart';

import '../../../../index.dart';

class SignUpUseCase extends CommonSendReceiveUseCase<SignUpResponse> {
  SignUpUseCase({
    required super.apiPath,
    required super.dio,
  });

  @override
  Future<SignUpResponse> onCompute(String responseData) {
    return compute(_parseLoginResponse, responseData);
  }

  static Future<SignUpResponse> _parseLoginResponse(String responseData) async {
    return SignUpResponse.from(responseData);
  }
}
