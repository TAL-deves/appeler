import 'dart:async';

import 'package:appeler/modules/calling/screen/call_enum/call_enum.dart';
import 'package:appeler/modules/group_calling/screen/for_remote/group_calling_remote_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../auth/api/auth_management.dart';

const groupCallingClientScreenRoute = 'groupCallingClientScreenRoute';

class GroupCallingClientScreen extends StatefulWidget {
  const GroupCallingClientScreen({super.key, this.callerHostId});

  final String? callerHostId;

  @override
  State<GroupCallingClientScreen> createState() => _GroupCallingClientScreenState();
}

class _GroupCallingClientScreenState extends State<GroupCallingClientScreen> {
  final _users = FirebaseFirestore.instance.collection('users');
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  late final _curUser = _users.doc(AuthManagementUseCase.curUser);
  late final _curRoom = _chatRooms.doc('${widget.callerHostId}+${AuthManagementUseCase.curUser}');
  late final _hostUser = _users.doc(widget.callerHostId);
  late final _curUserConnectedWithHost = _hostUser.collection('connected').doc('list');

  late StreamSubscription _roomSubs, _hostSubs;

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  final _widgetMap = <String, Widget>{};
  final _addedUser = <String>{};

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
      _widgetMap[widget.callerHostId!] = Flexible(
        child: GroupCallingRemoteScreen(
          callEnum: CallEnum.incoming,
          id: widget.callerHostId!,
          localStream: _localStream!,
        ),
      );
    });
    _offerAnswerHostUser();
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void _firebaseDeleteWork() {
    _curUser.update({
      'inAnotherCall': false,
      'inGroupCall': false,
      'incomingCallFrom': null,
    });
    _curRoom.delete();
    _roomSubs.cancel();
    _hostSubs.cancel();
  }

  void _initRoom() {
    _roomSubs = _curRoom.snapshots().listen((event) {
      final data = event.data();
      if (data == null) Navigator.pop(context);
    });
  }

  var offerCalled = 0;

  void _offerAnswerHostUser(){
    _hostSubs = _curUserConnectedWithHost.snapshots().listen((event) {
      final mp = event.data();
      if(mp != null){
        final curList = mp['curList'] as List<dynamic>?;
        print('offer called: $curList    ${++offerCalled}  ${AuthManagementUseCase.curUser}');
        if(curList != null){
          for(final item in curList){
            final curItem = item as String;
            if(curItem != AuthManagementUseCase.curUser && !_addedUser.contains(curItem)){
              setState(() {
                _addedUser.add(curItem);
                _widgetMap[curItem] = Flexible(
                  child: GroupCallingRemoteScreen(
                    callEnum: AuthManagementUseCase.curUser!.compareTo(curItem) > 0
                        ? CallEnum.outgoing
                        : CallEnum.incoming,
                    id: curItem,
                    localStream: _localStream!,
                  ),
                );
              });
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    _initLocalRenderer();
    _initRoom();
    super.initState();
  }

  @override
  void dispose() {
    _disposeLocalRenderer();
    _firebaseDeleteWork();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Calling Client Screen'),
      ),
      body: _localStream == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: _widgetMap.entries.map((e) => e.value).toList(),
            )
    );
  }
}
