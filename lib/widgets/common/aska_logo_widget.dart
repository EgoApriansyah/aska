import 'package:flutter/material.dart';

class AskaLogoWidget extends StatelessWidget {
  final double? height;

  const AskaLogoWidget({Key? key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_aska.png',
      height: height ?? 100, // Tinggi default
      fit: BoxFit.contain,
    );
  }
}