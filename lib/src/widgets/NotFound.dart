import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  NotFound({
    this.width,
  });
  double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 200,
      child: Image.asset(
        "assets/found.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
