import 'package:flutter/material.dart';
import 'package:flutter_andomie/widgets.dart';

import '../../../../index.dart';

class WelcomeFragment extends StatefulWidget {
  final OnViewClickListener onSignIn, onSignUp, onJoinMeeting;

  const WelcomeFragment({
    Key? key,
    required this.onSignIn,
    required this.onSignUp,
    required this.onJoinMeeting,
  }) : super(key: key);

  @override
  State<WelcomeFragment> createState() => _WelcomeFragmentState();
}

class _WelcomeFragmentState extends State<WelcomeFragment> {
  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      width: double.infinity,
      gravity: Alignment.center,
      layoutGravity: LayoutGravity.center,
      children: [
        LinearLayout(
          orientation: Axis.horizontal,
          paddingHorizontal: 24,
          paddingTop: 60,
          children: [
            _Button(
              text: "SIGN IN",
              background: AppColors.secondary,
              onClick: widget.onSignIn,
            ),
            _Button(
              text: "SIGN UP",
              background: AppColors.primary,
              onClick: widget.onSignUp,
            ),
          ],
        ),
        const WelcomeSlider(
          items: SlideItem.items,
        ),
        TextView(
          text: "Join a Meeting",
          background: AppColors.primary,
          textColor: Colors.white,
          paddingHorizontal: 40,
          paddingVertical: 12,
          borderRadius: 25,
          margin: 24,
          marginBottom: 60,
          onClick: widget.onJoinMeeting,
        ),
      ],
    );
  }
}

class WelcomeSlider extends StatefulWidget {
  final List<SlideItem> items;

  const WelcomeSlider({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  State<WelcomeSlider> createState() => _WelcomeSliderState();
}

class _WelcomeSliderState extends State<WelcomeSlider> {
  late ViewPagerController controller;

  @override
  void initState() {
    controller = ViewPagerController();
    controller.setOnPageChangeListener((index) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      width: double.infinity,
      flex: 1,
      children: [
        Expanded(
          child: IntroSlider(
            renderNextBtn: const SizedBox(),
            renderSkipBtn: const SizedBox(),
            renderDoneBtn: const SizedBox(),
            renderPrevBtn: const SizedBox(),
            listCustomTabs: widget.items.map((e) {
              return _SlideViewItem(item: e);
            }).toList(),
            // navigationBarConfig: NavigationBarConfig(
            //   navPosition: NavPosition.bottom,
            //   padding: EdgeInsets.only(
            //     top: MediaQuery.of(context).viewPadding.top > 0 ? 20 : 10,
            //     bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 20 : 10,
            //   ),
            //   backgroundColor: Colors.transparent,
            // ),
            indicatorConfig: IndicatorConfig(
              indicatorColor: AppColors.primary.withAlpha(25),
              indicatorColorSelected: AppColors.primary,
              indicatorSize: 12,
              indicatorSelected: null,
              indicator: null,
              indicatorVisible: true,
              indicatorAnimationType: IndicatorAnimationType.sliding,
            ),
            isAutoScroll: false,
            curveScroll: Curves.bounceIn,
          ),
        ),
      ],
    );
  }
}

class SlideItem {
  final dynamic image;
  final String title;
  final String body;

  const SlideItem({
    this.image,
    this.title = "",
    this.body = "",
  });

  static const items = [
    SlideItem(
      title:
          "Instant Video Conferences with your colleagues, friends and family",
      body: "Start or join a video conference meetings",
      image: WelcomeContents.img_1,
    ),
    SlideItem(
      title:
          "Instant Video Conferences with your colleagues, friends and family",
      body: "Start or join a video conference meetings",
      image: WelcomeContents.img_1,
    ),
    SlideItem(
      title:
          "Instant Video Conferences with your colleagues, friends and family",
      body: "Start or join a video conference meetings",
      image: WelcomeContents.img_1,
    ),
  ];
}

class _SlideViewItem extends StatelessWidget {
  final SlideItem item;

  const _SlideViewItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      layoutGravity: LayoutGravity.center,
      width: double.infinity,
      height: double.infinity,
      paddingHorizontal: 40,
      children: [
        TextView(
          text: item.title,
          textColor: AppColors.secondary,
          textSize: 14,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          lineSpacingExtra: 8,
        ),
        ImageView(
          image: item.image,
          scaleType: BoxFit.contain,
          marginVertical: 40,
        ),
        TextView(
          text: item.body,
          textColor: AppColors.secondary,
          textSize: 16,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w500,
          lineSpacingExtra: 8,
        ),
      ],
    );
  }
}

class _Button extends StatelessWidget {
  final Color? background;
  final String text;
  final OnViewClickListener onClick;

  const _Button({
    Key? key,
    this.background,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextView(
      background: background,
      flex: 1,
      width: 40,
      height: 40,
      borderRadiusTL: 50,
      borderRadiusBR: 50,
      gravity: Alignment.center,
      text: text,
      textColor: Colors.white,
      textAlign: TextAlign.center,
      textSize: 16,
      fontWeight: FontWeight.w500,
      onClick: onClick,
    );
  }
}
