import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class MeetingParticipantActivity extends StatelessWidget {
  static const String route = "participant";
  static const String title = "Participant";

  final MeetingController? meetingController;

  const MeetingParticipantActivity({
    Key? key,
    required this.meetingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        meetingController != null
            ? BlocProvider.value(value: meetingController!)
            : BlocProvider(create: (context) => locator<MeetingController>())
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
        body: MeetingParticipantFragment(
          items: List.generate(
            50,
            (index) {
              return MeetingContributor(
                id: "$index",
                cameraOn: index.isOdd,
                muted: index.isEven,
                riseHand: index.isOdd,
                name: "Participant : $index",
                email: index % 4 == 0 ? "example@gmail.com" : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
