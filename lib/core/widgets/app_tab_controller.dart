import 'package:appeler/core/app_constants/app_color.dart';
import 'package:flutter/material.dart';

class AppTabController extends StatefulWidget {
  final List<Widget> tabChildren;
  final List<String> tabItemTitles;
  final Function(int)? indexOnChanged;
  final double? tabItemsFontSize;
  final Color? tabBarCustomColor;

  const AppTabController({
    Key? key,
    required this.tabChildren,
    required this.tabItemTitles,
    this.indexOnChanged,
    this.tabItemsFontSize,
    this.tabBarCustomColor,
  }) : super(key: key);

  @override
  State<AppTabController> createState() => _AppTabControllerState();
}

class _AppTabControllerState extends State<AppTabController> {
  late PageController _controller;
  var selectedPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = PageController(initialPage: selectedPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: widget.tabBarCustomColor ?? kWhiteColor,
            ),
            child: Row(
              children: [
                for (int i = 0; i < widget.tabChildren.length; ++i)
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (i != selectedPage) {
                          setState(() {
                            final pageDif = (i - selectedPage).abs();
                            if (pageDif == 1) {
                              _controller.animateToPage(
                                selectedPage = i,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            }
                            else { _controller.jumpToPage(selectedPage = i); }
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: i == selectedPage ? kPrimaryColor : null,
                          ),
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            widget.tabItemTitles[i],
                            style: TextStyle(
                                color: i == selectedPage ? kWhiteColor : null,
                                fontSize: widget.tabItemsFontSize),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _controller,
              children: widget.tabChildren,
              onPageChanged: (position) {
                setState(() {
                    selectedPage = position;
                    if (widget.indexOnChanged != null) {
                      widget.indexOnChanged!.call(position);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
