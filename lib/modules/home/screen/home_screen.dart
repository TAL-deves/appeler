import 'package:flutter/material.dart';
const homeScreenRoute = 'kHomeScreen';

class AppHomeScreen extends StatelessWidget {
  const AppHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}