import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../../../../index.dart';

class DeleteAccountUseCase extends CommonSendReceiveUseCase<DeleteAccountResponse>{
  DeleteAccountUseCase({required super.apiPath, required super.dio});

  @override
  Future<DeleteAccountResponse> onCompute(String responseData) {
    return compute(_parseDeleteResponse, responseData);
  }

  static Future<DeleteAccountResponse> _parseDeleteResponse(String responseData) async{
    return DeleteAccountResponse.fromMap(jsonDecode(responseData));
  }

  Future<void> deleteCurUserAccount() async{
    final curContext = AppUtilities.curNavigationContext!;
    try{
      final curResponse = await getData(jsonEncode({'username' : SavedUserUseCase.userId}));
      if(curResponse.result?.status != null && curResponse.result!.status == 200){
        await AppUtilities.forceLogoutFromApplication(deleteMap: {'message': curResponse.data ?? ''});
      }
      else{ AppSnackBar.showFailureSnackBar(message: curResponse.result?.errMsg); }
    }
    catch(e){
      final errorMessage = e.toString();
      print('error occured!');
      AppSnackBar.showFailureSnackBar(message: errorMessage);
    }

  }
}