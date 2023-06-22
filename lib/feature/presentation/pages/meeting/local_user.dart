import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../../../../index.dart';

class ContributorCard extends StatefulWidget {
  final RTCVideoRenderer renderer;
  final String meetingId;
  final String uid;
  final bool mirror;

  const ContributorCard({
    Key? key,
    required this.renderer,
    required this.meetingId,
    required this.uid,
    required this.mirror,
  }) : super(key: key);

  @override
  State<ContributorCard> createState() => _ContributorCardState();
}

class _ContributorCardState extends State<ContributorCard> {
  late final config = SizeConfig.of(context);
  late final controller = context.read<MeetingController>();

  @override
  Widget build(BuildContext context) {
    return ContributorView(
      renderView: RTCVideoView(
        widget.renderer,
        mirror: widget.mirror,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
      stream: controller.handler.liveContributor(
        widget.meetingId,
        widget.uid,
      ),
      userView: (context, item) {
        var photo = item?.photo ??
            "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png";
        var name = item?.name ?? item?.email ?? "Unknown";

        return LinearLayout(
          layoutGravity: LayoutGravity.center,
          children: [
            ImageView(
              width: 80,
              height: 80,
              shape: ViewShape.circular,
              image: photo.isValid
                  ? photo
                  : "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png",
              scaleType: BoxFit.cover,
            ),
            TextView(
              text: name.isValid ? name : item?.email ?? "Unknown",
              textOverflow: TextOverflow.ellipsis,
              textSize: 14,
              textColor: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.bold,
              marginTop: 8,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
