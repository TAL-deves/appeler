import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../index.dart';

class HomeFragmentBuilder extends StatefulWidget {
  final String? id;
  final HomeBodyType type;

  const HomeFragmentBuilder({
    Key? key,
    required this.type,
    this.id,
  }) : super(key: key);

  @override
  State<HomeFragmentBuilder> createState() => _HomeFragmentBuilderState();
}

class _HomeFragmentBuilderState extends State<HomeFragmentBuilder> {
  late HomeController controller;

  @override
  void initState() {
    controller = context.read<HomeController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case HomeBodyType.initial:
        return HomeFragment(
          controller: controller,
          id: widget.id,
        );
    }
  }
}

enum HomeBodyType {
  initial,
}
