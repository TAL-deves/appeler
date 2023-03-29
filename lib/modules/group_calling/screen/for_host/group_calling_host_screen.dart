import 'dart:async';
import 'package:appeler/modules/calling/screen/call_enum/call_enum.dart';
import 'package:appeler/modules/group_calling/screen/for_remote/group_calling_remote_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../auth/api/auth_management.dart';

const groupCallingHostScreenRoute = 'groupCallingHostScreenRoute';

class GroupCallingHostScreen extends StatefulWidget {
  const GroupCallingHostScreen({Key? key, required this.curList})
      : super(key: key);

  final List<QueryDocumentSnapshot<Map<String, dynamic>>> curList;

  @override
  State<GroupCallingHostScreen> createState() => _GroupCallingHostScreenState();
}

class _GroupCallingHostScreenState extends State<GroupCallingHostScreen> {
  final _users = FirebaseFirestore.instance.collection('users');
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _subsMap = <String, StreamSubscription>{};
  late final _curUser = _users.doc(AuthManagementUseCase.curUser);
  final _userSet = <String>{};

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;

  final _widgetMap = <String, Widget>{};

  Future<MediaStream> get _getUserMediaStream async {
    final mp = <String, dynamic>{
      'audio': false,
      'video': kIsWeb
          ? {'facingMode': 'user'}
          : {
              'width': '640',
              'height': '480',
              'frameRate': '30',
              'facingMode': 'user',
              'optional': [],
            }
    };
    final stream = await navigator.mediaDevices.getUserMedia(mp);
    return stream;
  }

  void _initLocalRenderer() async {
    await _localRenderer.initialize();
    _localStream = await _getUserMediaStream;
    setState(() {
      _localRenderer.srcObject = _localStream;
      _widgetMap['local'] = Flexible(
        child: Container(
          key: const Key('local'),
          margin: const EdgeInsets.all(16),
          decoration: const BoxDecoration(color: Colors.black),
          child: RTCVideoView(_localRenderer, mirror: true),
        ),
      );
    });
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _firebaseDisposeWork() {
    _curUser.update({
      'inAnotherCall': false,
      'inGroupCall': false,
    });
    _subsMap.forEach((key, value) {
      _chatRooms.doc(key).delete();
      value.cancel();
    });
  }

  @override
  void initState() {
    _initLocalRenderer();
    _makeGroupCall();
    super.initState();
  }

  @override
  void dispose() {
    _firebaseDisposeWork();
    _disposeLocalRenderer();
    super.dispose();
  }

  void _makeGroupCall() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      AppSnackBar.showSuccessSnackBar(message: 'Starting group call, please wait!!');
    });

    final curUser = _users.doc(AuthManagementUseCase.curUser);
    curUser.update({
      'inAnotherCall': true,
      'inGroupCall': true,
    });
    for (var item in widget.curList) {
      final curItem = item.data();
      if (curItem['id'] != AuthManagementUseCase.curUser) {
        final name = curItem['name'];
        final id = curItem['id'];
        final isOnline = curItem['isOnline'] as bool;
        final inAnotherCall = curItem['inAnotherCall'] as bool;
        if (!isOnline) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            AppSnackBar.showFailureSnackBar(message: 'User $id is not online!');
          });
        } else if (inAnotherCall) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            AppSnackBar.showFailureSnackBar(
                message: 'User $id in another call');
          });
        } else {
          final remoteUser = _users.doc(id);
          remoteUser.update({
            'incomingCallFrom': AuthManagementUseCase.curUser,
            'inAnotherCall': true,
            'inGroupCall': true,
          });
          final roomId = '${AuthManagementUseCase.curUser}+$id';
          final curRoom = _chatRooms.doc(roomId);
          _subsMap[roomId]?.cancel();
          _subsMap[roomId] = curRoom.snapshots().listen((event) async {
            final curData = event.data();
            if (curData != null) {
              final isAccepted = curData['accepted'];
              if (isAccepted != null) {
                if (isAccepted) {
                  AppSnackBar.showSuccessSnackBar(message: 'Call Accepted by $id');
                  setState(() {
                    _widgetMap[id] = Flexible(
                      child: GroupCallingRemoteScreen(
                        callEnum: CallEnum.outgoing,
                        id: id,
                        localStream: _localStream!,
                      ),
                    );
                  });
                }
                else {
                  curRoom.delete();
                  curUser.update({
                    'inAnotherCall': false,
                    'inGroupCall': false,
                  });
                  AppSnackBar.showFailureSnackBar(message: 'Call rejected by $id');
                }
              }
            } else {
              print('user set is: $_userSet');
              if (_userSet.contains(id)) {
                AppSnackBar.showFailureSnackBar(message: 'Call ended by $id');
              } else {
                _userSet.add(id);
              }
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Calling Host Screen')),
      body: _localStream == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: _widgetMap.entries.map((e) => e.value).toList()
         ),
    );
  }
}
