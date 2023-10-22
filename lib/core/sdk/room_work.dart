import 'dart:developer';
import 'analytica_rtc.dart';
import 'realtime_repository.dart';
import 'package:uuid/uuid.dart';
import 'use_cases.dart' show createRoomUseCase, deleteRoomUseCase;

abstract class RoomWork {
  Future<String> autoCreateRoomId({String? roomId, required int minutes});
  static String curRoomPath = '';
  RoomWork._();

  static RoomWork? _instance;

  static RoomWork get instance => _instance ??= _RoomWorkImp();

  static void dispose(){
    //_deleteCurRoom();
    curRoomPath = '';
    _instance = null;
  }

  void deleteCurRoom();
}

class _RoomWorkImp implements RoomWork{
  final _uuid = const Uuid();
  final _roomPathPrefix = 'appId:${AnalyticaRTC.appId}/roomId:';

  @override
  Future<String> autoCreateRoomId({String? roomId, required int minutes}) async{
    if(RoomWork.curRoomPath.isNotEmpty) await deleteCurRoom(makeRoomEmpty: false);
    RoomWork.curRoomPath = '$_roomPathPrefix${roomId ?? _uuid.v4()}';
    try{
      final response = await createRoomUseCase.createRoom(
        roomId: RoomWork.curRoomPath,
        minutes: minutes,
      );
      log(response);
      await RealTimeRepository.instance.set(path: RoomWork.curRoomPath, data: {});
    }
    catch(e){ return e.toString(); }
    return RoomWork.curRoomPath;
  }

  @override
  Future<void> deleteCurRoom({bool makeRoomEmpty = true}) async{
    try{
      deleteRoomUseCase.deleteRoom(roomId: RoomWork.curRoomPath).then((value){
        log('Room deleted form server: $value');
      });
      await RealTimeRepository.instance.delete(path: RoomWork.curRoomPath);
      log('Old path ID: ${RoomWork.curRoomPath} deleted successfully!');
      if(makeRoomEmpty) RoomWork.curRoomPath = '';
    }
    catch(e){ log('Old ID delete failed'); }
  }
}