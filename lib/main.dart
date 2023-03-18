import 'package:appeler/modules/auth/phone/page.dart';
import 'package:appeler/modules/login/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestPage(),
      //home: const AuthPhonePage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> with WidgetsBindingObserver{

  void update(String status) async{
    final docUser = FirebaseFirestore.instance.collection('users').doc('test');
    final json = {
      'status': status,
    };
    await docUser.update(json);
  }

  void work() async{
    final docUser = FirebaseFirestore.instance.collection('users').doc('test');
    final json = {
      'name': 'Android',
      'age': 21,
    };
    await docUser.set(json);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      update('Online');
    }
    else{
      update('Offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void initState() {
    super.initState();
    update('Online');
    WidgetsBinding.instance.addObserver(this);
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

