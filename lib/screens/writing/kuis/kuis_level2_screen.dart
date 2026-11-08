import 'package:flutter/material.dart';

import 'kuis_base_screen.dart';

class KuisLevel2Screen extends StatelessWidget {
  const KuisLevel2Screen({super.key});

  static const _soal = KuisSuaraSoal(
    bentuk: 'awal',
    bentukLabel: 'Bentuk awal',
    huruf: 'تـ',
    caption: 'di awal kata!',
    contoh: 'تا',
  );

  @override
  Widget build(BuildContext context) {
    return const KuisSuaraView(level: 2, soal: _soal);
  }
}