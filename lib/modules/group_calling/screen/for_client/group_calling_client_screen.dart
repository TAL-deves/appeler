import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_constants/app_color.dart';
import '../../../../core/widgets/app_button.dart';
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

  late StreamSubscription _roomSubs;

  void _commonDeleteWork(){
    _curUser.update({
      'inAnotherCall': false,
      'inGroupCall': false,
      'incomingCallFrom': null,
    });
    _curRoom.delete();
    _roomSubs.cancel();
  }

  void _initRoom(){
    _roomSubs = _curRoom.snapshots().listen((event) {
      final data = event.data();
      if(data == null) Navigator.pop(context);
    });
  }

  @override
  void initState() {
    _initRoom();
    super.initState();
  }

  @override
  void dispose() {
    _commonDeleteWork();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Group Calling Client Screen'),),
      body: Center(
        child: AppCommonButton(
          color: kRedColor,
          title: 'Cancel call for id: ${widget.callerHostId}',
          onPressed: (){ Navigator.pop(context); },
        ),
      ),
    );
  }
}
