import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../index.dart';

class CommonReceiveUseCase extends CommonSendReceiveUseCase<CommonReceiveResponse>{
  CommonReceiveUseCase({required super.apiPath, required super.dio});

  @override
  Future<CommonReceiveResponse> onCompute(String responseData) {
    return compute(parseCommonResponse, responseData);
  }

  static Future<CommonReceiveResponse> parseCommonResponse(String responseData) async{
    return CommonReceiveResponse.fromMap(jsonDecode(responseData));
  }

}