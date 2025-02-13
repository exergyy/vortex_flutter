import 'package:flutter/material.dart';
import 'package:vortex/app_style.dart';

class HeaderWidget extends StatelessWidget {
  final String data;

  const HeaderWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppStyle.padding,
      margin: AppStyle.margin,
      alignment: Alignment.centerLeft,
      child: Text( 
        data,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20
        ),
        ),
    );
  }
}