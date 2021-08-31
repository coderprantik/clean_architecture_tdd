import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Theme.of(context).accentColor,
      height: 60,
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90),
      ),
    );
  }
}
