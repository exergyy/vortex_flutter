import 'package:flutter/material.dart';

abstract final class AppStyle {
  static const spacing = 4.0;
  static const padding = EdgeInsets.all(spacing * 2);
  static const margin = EdgeInsets.symmetric(vertical: spacing);
  static final borderRadius = BorderRadius.circular(20);
}
