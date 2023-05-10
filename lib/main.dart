import 'dart:ui';

import 'package:appeler/core/app_utilities/app_utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'core/app_router/app_router.dart';
//import 'dart:html' as html;

late final SharedPreferences sharedPref;

//old work

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
      //home: TestWork()
    );
  }
}

class MyText extends StatefulWidget {
  const MyText({super.key, required this.textValue});

  final String textValue;

  @override
  State<MyText> createState() => _MyTextState();
}

class _MyTextState extends State<MyText> {
  late final innerValue = widget.textValue;
  @override
  Widget build(BuildContext context) {
    return Text(innerValue);
  }
}


class TestWork extends StatefulWidget {
  const TestWork({Key? key}) : super(key: key);

  @override
  State<TestWork> createState() => _TestWorkState();
}

class _TestWorkState extends State<TestWork> {
  final _widgetMap = <String, Widget>{};


  Widget _addButton(String value){
    return TextButton(
      child: Text(value),
      onPressed: (){
        setState(() {
          _widgetMap[value] = MyText(textValue: value, key: UniqueKey());
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('test'),),
      body: Column(
        children: [
          Column(
            children: _widgetMap.entries.map((e) => e.value).toList(),
          ),
          Row(
            children: [
              Column(
                children: [
                  _addButton('123'),
                  _addButton('456'),
                  _addButton('789'),
                ],
              ),
              Column(
                children: [
                  _removeButton('123'),
                  _removeButton('456'),
                  _removeButton('789'),
                ],
              )
            ],
          )
        ],
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

