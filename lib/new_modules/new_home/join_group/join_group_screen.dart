import 'package:appeler/new_modules/new_home/group_chat/group_chat_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/app_constants/app_color.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  String? _oldRoomId;
  final _textController = TextEditingController();

  void _resetState(){
    setState(() {
      _oldRoomId = null;
      _textController.text = '';
    });
  }

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        _oldRoomId = _textController.text;
        if(_oldRoomId!.isEmpty) _oldRoomId = null;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
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
              color: kGreenColor,
              disabledColor: kGreyColor,
              onPressed: _oldRoomId != null
                  ? (){ Navigator.of(context).pushNamed(kGroupChatScreenRoute, arguments: _oldRoomId).then((value){ _resetState(); }); }
                  : null,
              child: const Text('Join Room', style: TextStyle(color: kWhiteColor),),
            ),
          ),
        ],
      ),
    );
  }
}