import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  const MessageDisplay({
    Key? key,
    required this.msg,
  }) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(minHeight: 100, maxHeight: double.infinity),
        child: Text(
          msg,
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }
}
