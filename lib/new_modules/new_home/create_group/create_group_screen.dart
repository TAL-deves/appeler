import 'package:appeler/new_modules/new_home/group_chat/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/app_constants/app_color.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupChatRooms = FirebaseFirestore.instance.collection('group-chat-rooms');
  final _textController = TextEditingController();
  String? _oldRoomId;

  void _resetState(){
    setState(() {
      _oldRoomId = null;
      _textController.text = '';
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(hintText: 'ROOM ID'),
                onChanged: print,
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              flex: 3,
              child: MaterialButton(
                color: kRedColor,
                onPressed: (){
                  setState(() {
                    if(_oldRoomId != null){
                      _groupChatRooms.doc(_oldRoomId).delete();
                    }
                    final newDoc = _groupChatRooms.doc();
                    _oldRoomId = newDoc.id;
                    _textController.text = _oldRoomId!;
                    newDoc.set({});
                  });
                },
                child: const Text('Generate', style: TextStyle(color: kWhiteColor),),
              ),
            ),
            const SizedBox(width: 5,)
          ],
        ),
        const SizedBox(height: 5),
        MaterialButton(
          color: kGreenColor,
          disabledColor: kGreyColor,
          onPressed: _oldRoomId != null
              ? (){ Navigator.of(context).pushNamed(kGroupChatScreenRoute, arguments: _oldRoomId).then((value){ _resetState(); }); }
              : null,
          child: const Text('Join Room', style: TextStyle(color: kWhiteColor),),
        ),
      ],
    );
  }
}