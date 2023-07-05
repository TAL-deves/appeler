import 'dart:async';
import 'dart:developer';

import 'package:appeler/feature/presentation/pages/home/fragment_desktop.dart';
import 'package:appeler/feature/presentation/pages/home/fragment_mobile.dart';
import 'package:appeler/feature/presentation/widgets/responsive_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_links/uni_links.dart';

import '../../../../index.dart';

class HomeFragment extends StatefulWidget {
  final HomeController controller;

  const HomeFragment({
    Key? key,
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
    joinButton = ButtonController();
    code.addListener(() {
      joinButton.setEnabled(code.text.isValid);
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
        onCopyOrShare: onCopyOrShare,
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
        onCopyOrShare: onCopyOrShare,
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
    AppNavigator.of(context).go(
      PrepareActivity.route.withSlash,
      extra: {
        "meeting_id": code.text,
        "HomeController": widget.controller,
      },
    );
    code.text = "";
    joinButton.setEnabled(code.text.isValid);
  }

  void onLogout(BuildContext context) => controller.signOut();

  void onDeleteAccount(BuildContext context) async {
    await controller.deleteAccount();
  }

  void onCopyOrShare(dynamic value) async {
    if (value is String && value.isNotEmpty) {
      await ClipboardHelper.setText(
        value,
      );
      Fluttertoast.showToast(msg: "Copied code");
    }
  }
}
