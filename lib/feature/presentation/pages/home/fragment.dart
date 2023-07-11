import 'dart:async';
import 'dart:developer';

import 'package:appeler/feature/presentation/pages/home/fragment_desktop.dart';
import 'package:appeler/feature/presentation/pages/home/fragment_mobile.dart';
import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uni_links/uni_links.dart';

import '../../../../index.dart';

void onCopyOrShare(dynamic value, BuildContext context) {
  if (value is String && value.isNotEmpty) {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      "https://appeler.techanalyticaltd.com/app?meeting_id=$value",
      subject: "Let's go to meeting ... ",
      sharePositionOrigin:
          box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
  }
}

class HomeFragment extends StatefulWidget {
  final String? id;
  final HomeController controller;

  const HomeFragment({
    Key? key,
    this.id,
    required this.controller,
  }) : super(key: key);

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late HomeController controller;
  late TextEditingController code;
  late ButtonController joinButton;
  late int index = 0;
  String? oldRoomId;

  StreamSubscription? _sub;

  bool _initialUriIsHandled = false;

  @override
  void initState() {
    controller = widget.controller;
    code = TextEditingController();
    code.text = widget.id ?? "";
    joinButton = ButtonController();
    code.addListener(() {
      joinButton.setEnabled(code.text.isNotEmpty);
    });
    _handleIncomingLinks();
    _handleInitialUri();
    super.initState();
  }

  @override
  void dispose() {
    code.dispose();
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        final uri = await getInitialUri();
        if (uri != null) {
          setState(() {
            _routeByLink(uri);
          });
          log('Initial uri : $uri');
        }
      } catch (_) {
        log('Initial error : $_');
      }
    }
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((uri) {
        if (uri != null) {
          setState(() {
            _routeByLink(uri);
          });
          log("Incoming link : $uri");
        }
      }, onError: (error) {
        log("Incoming error : $error");
      });
    }
  }

  void _routeByLink(Uri? uri) {
    if (uri != null) {
      final params = uri.queryParameters.entries.first;
      var key = params.key;
      var value = params.value;
      if (key == "meeting_id" && value.isNotEmpty) {
        code.text = value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: HomeFragmentMobile(
        controller: widget.controller,
        joinButton: joinButton,
        codeController: code,
        onCreateMeet: onCreateMeetingId,
        onJoinMeet: onJoinMeet,
        onScheduleMeet: onScheduleMeet,
        onJoin: onJoin,
        onLogout: onLogout,
        onDeleteAccount: onDeleteAccount,
        onCopyOrShare: (value) => onCopyOrShare(value, context),
      ),
      desktop: HomeFragmentDesktop(
        controller: widget.controller,
        joinButton: joinButton,
        codeController: code,
        onCreateMeet: onCreateMeetingId,
        onJoinMeet: onJoinMeet,
        onScheduleMeet: onScheduleMeet,
        onJoin: onJoin,
        onLogout: onLogout,
        onDeleteAccount: onDeleteAccount,
        onCopyOrShare: (value) => onCopyOrShare(value, context),
      ),
    );
  }

  void onCreateMeetingId(BuildContext context) {
    final roomId = controller.generateRoom(oldRoomId);
    oldRoomId = roomId;
    if (roomId != null) {
      setState(() {
        code.text = roomId;
      });
    }
  }

  void onJoinMeet(BuildContext context) {}

  void onScheduleMeet(BuildContext context) {}

  void onJoin(BuildContext context) {
    AppCurrentNavigator.of(context).go(
      PrepareActivity.route.withParent("app"),
      extra: {
        "meeting_id": code.text,
        "HomeController": widget.controller,
      },
    );
    code.text = "";
    joinButton.setEnabled(code.text.isNotEmpty);
  }

  void onLogout(BuildContext context) => controller.signOut();

  void onDeleteAccount(BuildContext context) async {
    await controller.deleteAccount();
  }
}
