import 'package:flutter/material.dart';

import 'kuis_base_screen.dart';

class KuisLevel8Screen extends StatelessWidget {
  const KuisLevel8Screen({super.key});

  static const _soal = KuisSuaraSoal(
    bentuk: 'kata',
    bentukLabel: 'Kata sambung',
    huruf: 'كتب',
    caption: 'baca kata ini!',
    contoh: 'كتب',
  );

  @override
  Widget build(BuildContext context) {
    return const KuisSuaraView(level: 8, soal: _soal);
  }
}