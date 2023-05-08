import 'package:appeler/modules/auth/api/auth_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  void _addCurrentUser(){
    _userDoc.get().then((value){
      final curMap = value.data()!;
      curMap[AuthManagementUseCase.curUser!] = {
        'isMute': false,
        'handUp': false,
      };
      _userDoc.set(curMap);
    });
  }

  void _removeCurrentUser(){
    _userDoc.get().then((value){
      final curMap = value.data()!;
      curMap.remove(AuthManagementUseCase.curUser!);
      if(curMap.isEmpty) { _userDoc.delete(); }
      else { _userDoc.set(curMap); }
    });
  }

  @override
  void dispose() {
    _removeCurrentUser();
    super.dispose();
  }

  @override
  void initState() {
    _addCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID: ${widget.groupId}'),
      ),
    );
  }
}