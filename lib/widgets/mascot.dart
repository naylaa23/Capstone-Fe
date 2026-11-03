import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Maskot burung hantu. Memakai emoji supaya tidak butuh aset tambahan;
/// ganti dengan gambar maskot sendiri bila sudah ada.
class Mascot extends StatelessWidget {
  final double size;
  const Mascot({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.tealLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text('🦉', style: TextStyle(fontSize: size * 0.55)),
    );
  }
}
