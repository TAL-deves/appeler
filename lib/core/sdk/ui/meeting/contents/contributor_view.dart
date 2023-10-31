import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/services.dart';
import 'package:flutter_androssy/widgets.dart';

class ARTContributorView<T extends ARTCContributor> extends StatelessWidget {
  final double borderRadius;
  final double margin;
  final Color? background;
  final Widget renderView;
  final T item;
  final ARTContributorButtonProperties handButtonStyle;
  final ARTContributorButtonProperties microphoneButtonStyle;
  final ARTContributorButtonProperties moreButtonStyle;
  final OnViewBuilder<T>? userView;

  const ARTContributorView({
    Key? key,
    this.background,
    this.borderRadius = 0,
    this.margin = 0,
    required this.renderView,
    this.userView,
    required this.item,
    this.handButtonStyle = const ARTContributorButtonProperties(),
    this.microphoneButtonStyle = const ARTContributorButtonProperties(),
    this.moreButtonStyle = const ARTContributorButtonProperties(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        item.isCameraOn
            ? renderView
            : userView?.call(context, item) ??
                ImageView(
                  width: 80,
                  height: 80,
                  shape: ViewShape.circular,
                  image: item.photo ?? "",
                  scaleType: BoxFit.cover,
                ),
        Stack(
          alignment: Alignment.center,
          children: [
            if (!item.isCurrentContributor && item.isRiseHand)
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.back_hand_outlined,
                    size: handButtonStyle.size ?? 18,
                    color: handButtonStyle.color ?? Colors.white,
                  ),
                ),
              ),
            if (!item.isCurrentContributor)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.isMicrophoneOn ? Icons.mic : Icons.mic_off,
                    size: microphoneButtonStyle.size ?? 18,
                    color: microphoneButtonStyle.color ?? Colors.white,
                  ),
                ),
              ),
            if (!item.isCurrentContributor)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.more_vert,
                    size: moreButtonStyle.size ?? 18,
                    color: moreButtonStyle.color ?? Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class ARTCContributor extends Entity {
  final bool isCurrentContributor;
  final bool isCameraOn;
  final bool isMicrophoneOn;
  final bool isRiseHand;
  final bool isShareScreen;
  final String? email;
  final String? name;
  final String? photo;
  final String? phone;

  ARTCContributor({
    super.id,
    super.timeMills,
    this.email,
    this.name,
    this.photo,
    this.phone,
    this.isCurrentContributor = false,
    bool? isCameraOn,
    bool? isMicrophoneOn,
    bool? isRiseHand,
    bool? isShareScreen,
  })  : isCameraOn = isCameraOn ?? false,
        isMicrophoneOn = isMicrophoneOn ?? false,
        isRiseHand = isRiseHand ?? false,
        isShareScreen = isShareScreen ?? false;
}

class ARTContributorButtonProperties {
  final Color? color;
  final double? size;
  final Widget? view;

  const ARTContributorButtonProperties({
    this.color,
    this.size,
    this.view,
  });
}
