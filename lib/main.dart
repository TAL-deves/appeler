import 'dart:ui';
import 'dart:io';
import 'package:appeler/core/app_constants/app_color.dart';
import 'package:appeler/core/app_utilities/app_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'core/app_router/app_router.dart';
//import 'dart:html' as html;

late final SharedPreferences sharedPref;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground',
    'MY FOREGROUND SERVICE',
    description: 'This channel is used for important notifications.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
    critical: true,
  );

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'AWESOME SERVICE',
      initialNotificationContent: 'Initializing',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  service.startService();
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  print('on ios background is called');
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print('on start is called');
  DartPluginRegistrant.ensureInitialized();

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  service.on('setAsForeground').listen((event) {
    flutterLocalNotificationsPlugin.show(
      888,
      'COOL SERVICE',
      'Awesome ${DateTime.now()}',
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
          iOS: DarwinNotificationDetails(
              subtitle: 'my_foreground'
          )
      ),
    );
  });

  service.on('setAsBackground').listen((event) {
    flutterLocalNotificationsPlugin.show(
      888,
      'COOL SERVICE',
      'Awesome ${DateTime.now()}',
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'my_foreground',
            'MY FOREGROUND SERVICE',
            icon: 'ic_bg_service_small',
            ongoing: true,
          ),
          iOS: DarwinNotificationDetails(
              subtitle: 'my_foreground'
          )
      ),
    );
  });

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  // bring to foreground
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  // html.window.onUnload.listen((event) async{
  //   AuthManagementUseCase.updateOnlineStatus(false);
  // });
  Wakelock.enable();
  await Firebase.initializeApp(
    options: kIsWeb ? const FirebaseOptions(
      apiKey: "AIzaSyBmB2nrR8fHhMlWWCMtDJfYsHPY-s0HOa8",
      authDomain: "appeler-7dbb2.firebaseapp.com",
      projectId: "appeler-7dbb2",
      storageBucket: "appeler-7dbb2.appspot.com",
      messagingSenderId: "926347959879",
      appId: "1:926347959879:web:8f71cce0c2f22919b6db62",
    ) : null,
  );
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appeler',
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      navigatorKey: AppUtilities.appNavigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: appRouter.onGenerateRoute,
      //home: const GroupCallingHostScreen(curList: [])
      //home: const GroupCallingClientScreen()
      //home: const TestPage(),
      //home: const AuthPhonePage(),
      //home: const TestWork()
    );
  }
}

class MyText extends StatefulWidget {
  const MyText({super.key, required this.textValue, required this.keyValue});

  final String textValue, keyValue;

  @override
  State<MyText> createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  late final innerTextValue = widget.textValue;

  @override
  void dispose() {
    print('dispose is called with ${widget.keyValue}');
    super.dispose();
  }

  @override
  void initState() {
    print('init is called with ${widget.keyValue}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kRedColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Key is :${widget.keyValue}'),
          const SizedBox(width: 10,),
          Text('Value is : $innerTextValue'),
        ],
      ),
    );
  }
}

class MyText2 extends StatelessWidget {
  const MyText2({super.key, required this.textValue, required this.keyValue});

  final String textValue, keyValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kRedColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Key is : $keyValue'),
          const SizedBox(width: 10,),
          Text('Value is: $textValue'),
        ],
      ),
    );
  }
}


class TestWork extends StatefulWidget {
  const TestWork({Key? key}) : super(key: key);

  @override
  State<TestWork> createState() => _TestWorkState();
}

class _TestWorkState extends State<TestWork>{
  final _widgetMap = <String, Widget>{};
  final _keyMap = <String, GlobalKey>{};

  Widget _addButton(String value){
    return TextButton(
      child: Text(value),
      onPressed: (){
        setState(() {
          final curKey = GlobalKey();
          _keyMap[value] = curKey;
          _widgetMap[value] = MyText(textValue: value, keyValue: value, key: curKey);
        });
      },
    );
  }

  Widget _removeButton(String value){
    return TextButton(
      child: Text(value),
      onPressed: (){
        setState(() {
          _widgetMap.remove(value);
          _keyMap.remove(value);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test'),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if(_widgetMap.length == 1) _widgetMap['111']!
            else Column(children: _widgetMap.entries.map((e) => e.value).toList()),
        // GridView(
        // padding: const EdgeInsets.all(16),
        // scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   crossAxisSpacing: 10,
        //   mainAxisSpacing: 10,
        //   childAspectRatio: 1,
        // ),
        // children: _widgetMap.entries.map((e) => e.value).toList(),
        // ),
            Row(
              children: [
                Column(
                  children: [
                    _addButton('111'),
                    _addButton('222'),
                    _addButton('333'),
                    _addButton('123'),
                    _addButton('456'),
                    _addButton('789'),
                  ],
                ),
                Column(
                  children: [
                    _removeButton('111'),
                    _removeButton('222'),
                    _removeButton('333'),
                    _removeButton('123'),
                    _removeButton('456'),
                    _removeButton('789'),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}


class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with WidgetsBindingObserver{

  void update(bool status) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc('123');
    final json = {
      'isOnline': status,
    };
    await docUser.update(json);
  }

  void listenTest(){
    // final docUser = FirebaseFirestore.instance.collection('users').doc('123').collection('test');
    // final stream = docUser.snapshots().listen((snapshot) {
    //   final list = snapshot.docChanges;
    //   for(var i = 0; i < list.length; ++i){
    //     final curItem = list[i];
    //     final dataIs = curItem.doc.data();
    //     final type = curItem.type;
    //     print('data: ${dataIs}    type: $type');
    //   }
    // });
  }

  void work2() async{
    final timeValue = DateTime.now().millisecondsSinceEpoch.toString();
    final docUser = FirebaseFirestore.instance.collection('users').doc('123').collection('test').doc(timeValue);
    final json = {
      'name': 'Shimul',
      'age': 21,
      'value': 'testing'
    };
    await docUser.set(json);
  }

  void work() async{
    final docUser = FirebaseFirestore.instance.collection('users').doc('789');
    final json = {
      'name': 'Android',
      'age': 21,
      'isOnline': true,
      'inAnotherCall': false,
    };
    await docUser.set(json);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if(state == AppLifecycleState.resumed){
      update(true);
    }
    else{
      update(false);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();
    //update('Online');
    WidgetsBinding.instance.addObserver(this);
    //listenTest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello world')),
      body: Center(
        child: TextButton(
          onPressed: work,
          child: const Text('Upload'),
        ),
      ),
    );
  }
}