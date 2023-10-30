import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import 'contents/contributor_view.dart';

class ARTCContributorCard extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final String meetingId;
  final String uid;
  final bool mirror;
  final ARTCContributor contributor;

  const ARTCContributorCard({
    Key? key,
    required this.renderer,
    required this.meetingId,
    required this.uid,
    required this.mirror,
    required this.contributor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ARTContributorView(
      renderView: RTCVideoView(
        renderer,
        key: UniqueKey(),
        mirror: mirror,
        objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      ),
      item: contributor,
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
              textFontWeight: FontWeight.bold,
              marginTop: 8,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
