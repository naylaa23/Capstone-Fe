import 'package:flutter/material.dart';

import 'kuis_level1_screen.dart';
import 'kuis_level2_screen.dart';
import 'kuis_level3_screen.dart';
import 'kuis_level4_screen.dart';
import 'kuis_level5_screen.dart';
import 'kuis_level6_screen.dart';
import 'kuis_level7_screen.dart';
import 'kuis_level8_screen.dart';
import 'kuis_level9_screen.dart';
import 'kuis_level10_screen.dart';

/// Memilih layar soal kuis sesuai nomor level.
/// Level di luar 1..10 menampilkan "segera hadir".
Widget kuisLevelScreen(int level) {
  switch (level) {
    case 1:
      return const KuisLevel1Screen();
    case 2:
      return const KuisLevel2Screen();
    case 3:
      return const KuisLevel3Screen();
    case 4:
      return const KuisLevel4Screen();
    case 5:
      return const KuisLevel5Screen();
    case 6:
      return const KuisLevel6Screen();
    case 7:
      return const KuisLevel7Screen();
    case 8:
      return const KuisLevel8Screen();
    case 9:
      return const KuisLevel9Screen();
    case 10:
      return const KuisLevel10Screen();
    default:
      return _BelumTersedia(level: level);
  }
}

class _BelumTersedia extends StatelessWidget {
  final int level;

  const _BelumTersedia({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF3D6),
        elevation: 0,
        foregroundColor: const Color(0xFF2A1B6B),
      ),
      body: Center(
        child: Text(
          'Soal kuis level $level segera hadir',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2A1B6B),
          ),
        ),
      ),
    );
  }
}