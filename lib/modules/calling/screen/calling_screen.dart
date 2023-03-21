import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../auth/api/auth_management.dart';
import 'call_enum/call_enum.dart';

const callingScreenRoute = 'callingScreenRoute';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key, required this.id, required this.callEnum});

  final String id;
  final CallEnum callEnum;

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  final chatRooms = FirebaseFirestore.instance.collection('chat-rooms');
  final curUser = FirebaseFirestore.instance.collection('users').doc(AuthManagementUseCase.curUser);
  late final curRoom = chatRooms.doc(
    widget.callEnum == CallEnum.outgoing
        ? '${AuthManagementUseCase.curUser}+${widget.id}'
        : '${widget.id}+${AuthManagementUseCase.curUser}'
  );

  StreamSubscription? _roomSubs;

  void _initRoom(){
    _roomSubs = curRoom.snapshots().listen((event) {
      final data = event.data();
      if(data == null) Navigator.pop(context);
    });
  }

  void _deleteRoomAndRecoverState(){
    curRoom.delete();
    curUser.update({
      'inAnotherCall': false,
      'incomingCallFrom': null
    });
    _roomSubs?.cancel();
  }

  @override
  void dispose() {
    _deleteRoomAndRecoverState();
    super.dispose();
  }

  @override
  void initState() {
    //_answerCall();
    _initRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('enum is: ${widget.callEnum}');
    return Scaffold(
      appBar: AppBar(title: const Text('Calling Screen')),
    );
  }
}
