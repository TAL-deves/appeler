import 'package:appeler/feature/domain/entities/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';

class MeetingParticipantFragment extends StatelessWidget {
  final List<MeetingContributor> items;

  const MeetingParticipantFragment({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      crossGravity: CrossAxisAlignment.start,
      mainGravity: MainAxisAlignment.start,
      scrollable: true,
      children: [
        RecyclerView(
          width: double.infinity,
          background: Colors.black.withAlpha(5),
          items: items,
          itemCount: 50,
          builder: (context, item) {
            return MeetingParticipant(
              item: item,
            );
          },
        ),
      ],
    );
  }
}

class MeetingParticipant extends StatelessWidget {
  final MeetingContributor item;

  const MeetingParticipant({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      paddingHorizontal: 16,
      paddingVertical: 12,
      layoutGravity: LayoutGravity.center,
      crossGravity: CrossAxisAlignment.center,
      orientation: Axis.horizontal,
      marginVertical: 1,
      background: Colors.white,
      children: [
        AvatarView(
          url: item.photo ??
              "https://assets.materialup.com/uploads/b78ca002-cd6c-4f84-befb-c09dd9261025/preview.png",
          size: 40,
          marginEnd: 24,
        ),
        LinearLayout(
          flex: 1,
          children: [
            TextView(
              text: item.name ?? "Unnamed Person",
              textSize: 16,
              textColor: Colors.black,
              maxLines: 2,
            ),
            TextView(
              visibility: item.email.isValid
                  ? ViewVisibility.visible
                  : ViewVisibility.gone,
              marginTop: 4,
              text: item.email,
              textColor: Colors.grey,
              textSize: 14,
              maxLines: 2,
            ),
          ],
        ),
        IconView(
          paddingHorizontal: 8,
          visibility:
              item.isRiseHand ? ViewVisibility.visible : ViewVisibility.gone,
          icon: Icons.front_hand_outlined,
        ),
        IconView(
          paddingHorizontal: 8,
          icon: item.isMuted ? Icons.mic_none : Icons.mic_off_outlined,
        ),
        IconView(
          paddingHorizontal: 8,
          icon: item.isCameraOn
              ? Icons.videocam_outlined
              : Icons.videocam_off_outlined,
        ),
      ],
    );
  }
}
