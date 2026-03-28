import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lottie/radish.json',
      width: 200,
      height: 200,
    );
  }
}