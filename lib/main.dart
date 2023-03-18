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
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  void work() async{
    final docUser = FirebaseFirestore.instance.collection('users').doc(DateTime.now().millisecondsSinceEpoch.toString());
    final json = {
      'name': 'Android',
      'age': 21,
    };
    await docUser.set(json);
  }

  @override
  void initState() {
    //work();
    super.initState();
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

