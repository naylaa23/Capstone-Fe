import 'package:flutter/material.dart';

import 'kuis_base_screen.dart';

class KuisLevel10Screen extends StatelessWidget {
  const KuisLevel10Screen({super.key});

  // level 10 pakai timer 20 detik (belum dibuat)
  static const _soal = KuisSuaraSoal(
    bentuk: 'kata',
    bentukLabel: 'Kata sambung',
    huruf: 'بيت',
    caption: 'baca kata ini!',
    contoh: 'بيت',
  );

  @override
  Widget build(BuildContext context) {
    return const KuisSuaraView(level: 10, soal: _soal);
  }
}