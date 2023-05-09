import 'dart:async';

import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../modules/calling/screen/call_enum/call_enum.dart';
import '../../../modules/group_calling/screen/for_remote/group_calling_remote_screen.dart';

const kGroupChatScreenRoute = 'groupChatScreen';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key, required this.groupId});

  final String groupId;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _groupChatRooms = FirebaseFirestore.instance.collection('group-chat-rooms');
  late final _userDoc = _groupChatRooms.doc(widget.groupId);

  final _localRenderer = RTCVideoRenderer();
  MediaStream? _localStream;
  final _widgetMap = <String, Widget>{};
  final _addedUser = <String>{};

  StreamSubscription? _roomSubs, _hostSubs;

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

  void _initLocalRenderer() async{
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

  void _addCurrentUser() {
    _userDoc.get().then((value) {
      final curMap = value.data()!;
      curMap[AuthManagementUseCase.curUser!] = {
        'isMute': false,
        'handUp': false,
      };
      _userDoc.set(curMap);
    });
  }

  void _removeCurrentUser() {
    _userDoc.get().then((value) {
      final curMap = value.data()!;
      curMap.remove(AuthManagementUseCase.curUser!);
      if (curMap.isEmpty) {
        _userDoc.delete();
      } else {
        _userDoc.set(curMap);
      }
    });
  }

  void _disposeLocalRenderer() {
    _localRenderer.dispose();
    _localStream?.getTracks().forEach((element) {
      element.stop();
    });
    _localStream?.dispose();
  }

  void disposeSubs(){
    _hostSubs?.cancel();
    _roomSubs?.cancel();
  }

  void _offerAnswerHostUser(){
    _hostSubs = _userDoc.snapshots().listen((event) {
      final mp = event.data();
      if(mp != null){
        for(final item in mp.entries){
          final curItem = item.key;
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
    });
  }

  @override
  void dispose() {
    _removeCurrentUser();
    _disposeLocalRenderer();
    super.dispose();
  }

  @override
  void initState() {
    _initLocalRenderer();
    _addCurrentUser();
    _offerAnswerHostUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID: ${widget.groupId}'),
      ),
      body: _localStream == null
            ? const Center(child: CircularProgressIndicator(),)
            : Column(
              children: _widgetMap.entries.map((e) => e.value).toList(),
            )
    );
  }
}
