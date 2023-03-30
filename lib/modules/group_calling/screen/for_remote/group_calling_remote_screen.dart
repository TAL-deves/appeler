import 'dart:async';

import 'package:appeler/modules/calling/screen/call_enum/call_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../auth/api/auth_management.dart';

class GroupCallingRemoteScreen extends StatefulWidget {
  const GroupCallingRemoteScreen({
    super.key,
    required this.callEnum,
    required this.id,
    required this.localStream,
  });

  final CallEnum callEnum;
  final String id;
  final MediaStream localStream;

  @override
  State<GroupCallingRemoteScreen> createState() => _GroupCallingRemoteScreenState();
}

class _GroupCallingRemoteScreenState extends State<GroupCallingRemoteScreen> {
  final _chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final _curUser = FirebaseFirestore.instance.collection('users').doc(AuthManagementUseCase.curUser);
  late final _curRoom = _chatRooms.doc(
      widget.callEnum == CallEnum.outgoing
          ? '${AuthManagementUseCase.curUser}+${widget.id}'
          : '${widget.id}+${AuthManagementUseCase.curUser}'
  );

  late final _curRoomSelfCandidates = _curRoom.collection(widget.callEnum == CallEnum.outgoing ? 'callerCandidate': 'callieCandidate');
  late final _curRoomRemoteCandidates = _curRoom.collection(widget.callEnum == CallEnum.outgoing ? 'callieCandidate' : 'callerCandidate');

  MediaStream? _remoteStream;
  late RTCPeerConnection _peerConnection;

  StreamSubscription? _curRoomSubs, _candidateSubs;

  final _remoteRenderer = RTCVideoRenderer();

  void _setRemoteCandidate() {
    _candidateSubs = _curRoomRemoteCandidates.snapshots().listen((event) async{
      for(var item in event.docChanges){
        if(item.type == DocumentChangeType.added){
          final curData = item.doc.data();
          if(curData != null){
            final candidate = RTCIceCandidate(curData['candidate'], curData['sdpMid'], curData['sdpMLineIndex']);
            await _peerConnection.addCandidate(candidate);
          }
        }
      }
    });
  }

  Future<void> _initRemoteRenderer() async{
    await _remoteRenderer.initialize();
    _setRemoteCandidate();
  }

  Future<void> _disposeRemoteRenderer() async{
    _remoteRenderer.dispose();
    _remoteStream?.getTracks().forEach((track) {track.stop();});
    _remoteStream?.dispose();
    //_peerConnection.dispose();
  }

  Future<RTCPeerConnection> _createPeerConnection() async{
    final config = <String, dynamic>{
      "sdpSemantics": "plan-b", //this line is added
      'iceServers': [
        //{ "url": "stun:34.143.165.178:3478" },
        {
          "url": "turn:34.143.165.178:3478?transport=udp",
          "username": "test",
          "credential": "test123",
        },
        // {
        //   "url": "turn:180.210.129.103:3478?transport=udp",
        //   "username": "citlrtc",
        //   "credential": "c1tlr7c",
        // }
      ]
    };

    final pc = await createPeerConnection(config);
    await pc.addStream(widget.localStream);

    pc.onIceCandidate = (e){
      if(e.candidate != null){
        _curRoomSelfCandidates.add(e.toMap());
      }
    };

    pc.onAddStream = (stream){
      setState(() {
        _remoteRenderer.srcObject = stream;
        _remoteStream = stream;
      });
    };
    return pc;
  }

  Future<void> _initPeerConnection() async{
    _peerConnection = await _createPeerConnection();
  }

  Future<void> _setRemoteDescription({required Map<String, dynamic> sdpMap}) async{
    final description = RTCSessionDescription(sdpMap['sdp'], sdpMap['type']);
    return await _peerConnection.setRemoteDescription(description);
  }

  void _createOffer() async{
    final offer = await _peerConnection.createOffer();
    await _peerConnection.setLocalDescription(offer);
    _curRoom.set({'offer': offer.toMap()});
    _curRoomSubs = _curRoom.snapshots().listen((snapshot) async{
      final sdpMap = snapshot.data()?['answer'];
      if(await _peerConnection.getRemoteDescription() == null && sdpMap != null){
        await _setRemoteDescription(sdpMap: sdpMap);
      }
    });
  }

  void _createAnswer() async{
    _curRoomSubs = _curRoom.snapshots().listen((snapshot) async {
      final sdpMap = snapshot.data()?['offer'];
      if(await _peerConnection.getRemoteDescription() == null && sdpMap != null){
        await _setRemoteDescription(sdpMap: sdpMap);
        final answer = await _peerConnection.createAnswer();
        await _peerConnection.setLocalDescription(answer);
        _curRoom.update({'answer': answer.toMap()});
      }
    });
  }

  void _initRendererOfferAnswer() async{
    await _initPeerConnection();
    await _initRemoteRenderer();
    if(widget.callEnum == CallEnum.outgoing){ _createOffer(); }
    else{ _createAnswer(); }
  }

  Future<void> _deleteInnerCollection() async{
    final innerCollection = await _curRoomSelfCandidates.get();
    for(var item in innerCollection.docs){
      await item.reference.delete();
    }
  }

  void _deleteRoomAndRecoverState() async{
    await _deleteInnerCollection();
    _curRoom.delete();
    _curUser.update({
      'inAnotherCall': false,
      'incomingCallFrom': null
    });
  }

  void _cancelSubscriptions(){
    _curRoomSubs?.cancel();
    _candidateSubs?.cancel();
  }

  @override
  void initState() {
    _initRendererOfferAnswer();
    super.initState();
  }

  @override
  void dispose() {
    _deleteRoomAndRecoverState();
    _disposeRemoteRenderer();
    _cancelSubscriptions();
    //_peerConnection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _remoteStream == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
            key: const Key('local'),
            margin: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: Colors.black),
            child: RTCVideoView(_remoteRenderer, mirror: true),
          ),
    );
  }
}
