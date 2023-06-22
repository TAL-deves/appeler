import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class MeetingParticipantActivity extends StatelessWidget {
  static const String route = "participant";
  static const String title = "Participant";

  final String? meetingId;

  const MeetingParticipantActivity({
    Key? key,
    this.meetingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: !kIsWeb,
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Participants",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: meetingId.isValid
              ? context
                  .read<MeetingController>()
                  .handler
                  .getMeetingReference(meetingId ?? "")
                  .snapshots()
              : null,
          builder: (context, snapshot) {
            var response = snapshot.data?.data();
            var list = <MeetingContributor>[];
            if (response is Map<String, dynamic>) {
              list = response.entries.map((item) {
                return MeetingContributor.from(item.value);
              }).toList();
            }
            return MeetingParticipantFragment(items: list);
          }),
    );
  }
}
