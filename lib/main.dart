import 'dart:io';
import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:wakelock/wakelock.dart';

import 'index.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyBmB2nrR8fHhMlWWCMtDJfYsHPY-s0HOa8",
            authDomain: "appeler-7dbb2.firebaseapp.com",
            projectId: "appeler-7dbb2",
            storageBucket: "appeler-7dbb2.appspot.com",
            messagingSenderId: "926347959879",
            appId: "1:926347959879:web:8f71cce0c2f22919b6db62",
          )
        : null,
  );
  await diInit();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: false);
  setPathUrlStrategy();
  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver{
  ReceivePort? _receivePort;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state is: $state');
    if(state == AppLifecycleState.detached){
      _stopForegroundTask();
      _closeReceivePort();
    }
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await FlutterForegroundTask.canDrawOverlays) {
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();

    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(id: 'sendButton', text: 'Send'),
          const NotificationButton(id: 'testButton', text: 'Test'),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is int) {
        print('eventCount: $data');
      } else if (data is String) {
        if (data == 'onNotificationPressed') {
          //Navigator.of(context).pushNamed('/resume-route');
        }
      } else if (data is DateTime) {
        print('timestamp: ${data.toString()}');
      }
    });

    return _receivePort != null;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!kIsWeb && Platform.isAndroid) {
        await _requestPermissionForAndroid();
        _initForegroundTask();
        if (await FlutterForegroundTask.isRunningService) {
          final newReceivePort = FlutterForegroundTask.receivePort;
          _registerReceivePort(newReceivePort);
        }
        _startForegroundTask();
      }
    });
  }


  @override
  void dispose() {
    print('dispose is called');
    //_stopForegroundTask();
    //_closeReceivePort();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppInfo.name,
        theme: ThemeData(
          primarySwatch: AppColors.primary,
        ),
        routerConfig: AppRouter.I.router,
        // initialRoute: SplashActivity.route,
        // onGenerateRoute: AppRouter.I.generate,
      ),
    );
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  int _eventCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    final customData =
    await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
      notificationTitle: 'Foreground Service',
      notificationText: 'Service event: $_eventCount',
    );

    sendPort?.send(_eventCount);

    _eventCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  @override
  void onButtonPressed(String id) {
    print('onButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    //FlutterForegroundTask.launchApp("/resume-route");
    FlutterForegroundTask.launchApp(SplashActivity.route);
    _sendPort?.send('onNotificationPressed');
  }
}

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
//
// /// This sample app shows an app with two screens.
// ///
// /// The first route '/' is mapped to [HomeScreen], and the second route
// /// '/details' is mapped to [DetailsScreen].
// ///
// /// The buttons use context.go() to navigate to each destination. On mobile
// /// devices, each destination is deep-linkable and on the web, can be navigated
// /// to using the address bar.
// void main() => runApp(const MyApp());
//
// /// The route configuration.
// final GoRouter _router = GoRouter(
//   routes: <RouteBase>[
//     GoRoute(
//       path: '/',
//       builder: (BuildContext context, GoRouterState state) {
//         return const HomeScreen();
//       },
//       routes: <RouteBase>[
//         GoRoute(
//           path: 'details',
//           builder: (BuildContext context, GoRouterState state) {
//             return const DetailsScreen();
//           },
//         ),
//         GoRoute(
//           name: "settings",
//           path: "settings/:name",
//           builder: (BuildContext context, GoRouterState state) {
//             print('setting path value is : ${state.pathParameters}');
//             print('setting query value is : ${state.queryParameters}');
//             return const SettingsScreen();
//           },
//         ),
//       ],
//     ),
//   ],
// );
//
// /// The main app.
// class MyApp extends StatelessWidget {
//   /// Constructs a [MyApp]
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routerConfig: _router,
//     );
//   }
// }
//
// /// The home screen
// class HomeScreen extends StatelessWidget {
//   /// Constructs a [HomeScreen]
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home Screen')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               //onPressed: () => context.go('/details'),
//               onPressed: () => context.go('/details'),
//               child: const Text('Go to the Details screen'),
//             ),
//             const SizedBox(height: 20,),
//             ElevatedButton(
//               //onPressed: () => context.go('/details'),
//               onPressed: () => context.goNamed("settings", pathParameters: {"name": "codemagic"}, queryParameters: {'pagol': 'chagol'}),
//               child: const Text('Go to the settings screen'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class SettingsScreen extends StatelessWidget {
//   /// Constructs a [DetailsScreen]
//   const SettingsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings Screen')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <ElevatedButton>[
//             ElevatedButton(
//               onPressed: () => context.go('/'),
//               child: const Text('Go back to the Home screen'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// The details screen
// class DetailsScreen extends StatelessWidget {
//   /// Constructs a [DetailsScreen]
//   const DetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Details Screen')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <ElevatedButton>[
//             ElevatedButton(
//               onPressed: () => context.go('/'),
//               child: const Text('Go back to the Home screen'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }