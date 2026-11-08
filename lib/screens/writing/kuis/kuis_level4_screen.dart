import 'package:flutter/material.dart';

import 'kuis_base_screen.dart';

class KuisLevel4Screen extends StatelessWidget {
  const KuisLevel4Screen({super.key});

  static const _soal = KuisSuaraSoal(
    bentuk: 'tengah',
    bentukLabel: 'Bentuk tengah',
    huruf: 'ـبـ',
    caption: 'di tengah kata!',
    contoh: 'با',
  );

  @override
  Widget build(BuildContext context) {
    return const KuisSuaraView(level: 4, soal: _soal);
  }
}