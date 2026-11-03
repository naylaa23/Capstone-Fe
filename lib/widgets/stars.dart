import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Deretan 3 bintang; yang terisi sesuai `count`.
class StarsRow extends StatelessWidget {
  final int count;
  final int max;
  final double size;

  const StarsRow({super.key, required this.count, this.max = 3, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(max, (i) {
        final filled = i < count;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_outline_rounded,
            size: size,
            color: filled ? AppColors.yellow : AppColors.disabled,
          ),
        );
      }),
    );
  }
}

/// Pil kecil "⭐ 12" di pojok halaman.
class StarCounter extends StatelessWidget {
  final int stars;
  const StarCounter({super.key, required this.stars});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.yellow, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.yellow, size: 22),
          const SizedBox(width: 4),
          Text('$stars',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }
}
