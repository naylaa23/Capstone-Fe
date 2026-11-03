import 'package:flutter/material.dart';

/// Logo Qalamku (lingkaran buku + pensil, nama, dan tagline).
class QalamkuLogo extends StatelessWidget {
  final double width;
  const QalamkuLogo({super.key, this.width = 220});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/qalamku_logo.png',
      width: width,
      fit: BoxFit.contain,
    );
  }
}
