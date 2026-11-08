import 'package:flutter/material.dart';

import 'kuis_base_screen.dart';

class KuisLevel6Screen extends StatelessWidget {
  const KuisLevel6Screen({super.key});

  static const _soal = KuisSuaraSoal(
    bentuk: 'akhir',
    bentukLabel: 'Bentuk akhir',
    huruf: 'ـب',
    caption: 'di akhir kata!',
    contoh: 'با',
  );

  @override
  Widget build(BuildContext context) {
    return const KuisSuaraView(level: 6, soal: _soal);
  }
}