import 'package:flutter/material.dart';

class Explode extends StatefulWidget {
  const Explode({
    Key? key,
    required this.child,
    required this.animationController,
    required this.screenSize,
    required this.widgetSize,
    this.blow = false,
  }) : super(key: key);
  final Widget child;
  final AnimationController animationController;
  final Size screenSize;
  final Size widgetSize;
  final bool blow;

  @override
  State<Explode> createState() => _ExplodeState();
}

class _ExplodeState extends State<Explode> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !widget.blow
          ? widget.child
          : Builder(
              builder: (_) {
                print('init stack..');
                return Stack(
                  children: [],
                );
              },
            ),
    );
  }
}
