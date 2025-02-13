import 'package:flutter/material.dart';
import '../../app_style.dart';

class CustomCardWidget extends StatelessWidget {
  final Widget child;

  const CustomCardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Padding(
        padding: AppStyle.padding,
        child: child,
      ));
  }
}