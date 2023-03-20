import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../auth/api/auth_management.dart';

const callingScreenRoute = 'callingScreenRoute';

class CallingScreen extends StatefulWidget {
  const CallingScreen({super.key, required this.id});

  final String id;

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {

  void _answerCall(){
    final docUser = FirebaseFirestore.instance.collection('users').doc(widget.id);
    docUser.update({
      'outgoingCall': {
        'id': AuthManagementUseCase.curUser,
        'singleCall': true
      }
    });
  }

  @override
  void initState() {
    //_answerCall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calling Screen')),
    );
  }
}
