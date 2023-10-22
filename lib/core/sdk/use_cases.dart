import 'analytica_rtc.dart';
import 'validation_repository.dart';
import 'validation_repository.dart' show validationRepository;
import 'validation_response.dart';

final CheckValidationUseCase checkValidationUseCase =
    _CheckValidationUseCaseImp();
final CreateRoomUseCase createRoomUseCase = _CreateRoomUseCaseImp();
final JoinLeaveRoomUseCase joinLeaveRoomUseCase = _JoinLeaveRoomUseCaseImp();
final DeleteRoomUseCase deleteRoomUseCase = _DeleteRoomUseCaseImp();

abstract class CheckValidationUseCase {
  Future<ValidationResponse> checkValidation();
}

class _CheckValidationUseCaseImp implements CheckValidationUseCase {
  @override
  Future<ValidationResponse> checkValidation() {
    return validationRepository.checkValidation(
        appId: AnalyticaRTC.appId, token: AnalyticaRTC.token);
  }
}

abstract class CreateRoomUseCase {
  Future<String> createRoom({required String roomId, required int minutes});
}

class _CreateRoomUseCaseImp implements CreateRoomUseCase {
  @override
  Future<String> createRoom({required String roomId, required int minutes}) {
    return validationRepository.createRoom(
        appId: AnalyticaRTC.appId,
        token: AnalyticaRTC.token,
        roomId: roomId,
        minutes: minutes);
  }
}

abstract class JoinLeaveRoomUseCase {
  Future<String> joinLeaveRoom(
      {required String roomId, required String userId, required int type});
}

class _JoinLeaveRoomUseCaseImp implements JoinLeaveRoomUseCase {
  @override
  Future<String> joinLeaveRoom(
      {required String roomId, required String userId, required int type}) {
    return validationRepository.joinLeaveRoom(
        appId: AnalyticaRTC.appId,
        token: AnalyticaRTC.token,
        roomId: roomId,
        userId: userId,
        type: type);
  }
}

abstract class DeleteRoomUseCase {
  Future<String> deleteRoom({required String roomId});
}

class _DeleteRoomUseCaseImp implements DeleteRoomUseCase {
  @override
  Future<String> deleteRoom({required String roomId}) {
    return validationRepository.deleteRoom(
        appId: AnalyticaRTC.appId, token: AnalyticaRTC.token, roomId: roomId);
  }
}
