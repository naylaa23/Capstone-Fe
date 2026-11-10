import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro5Screen extends StatelessWidget {
  const Iqro5Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul
      ['جِ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['جِ', 'حِ', 'ثِ', 'جِ', 'حِ', 'اِ'],
      ['حِ', 'جِ', 'بِ', 'ثِ', 'اِ', 'جِ'],
      ['ثِ', 'اِ', 'جِ', 'حِ', 'بِ', 'تِ'],
      ['جِ', 'بِ', 'حِ', 'اِ', 'ثِ', 'جِ'],
      ['اِ', 'حِ', 'تِ', 'جِ', 'ثِ', 'حِ'],
      ['بِ', 'جِ', 'اِ', 'حِ', 'جِ', 'ثِ'],
      ['حِ', 'ثِ', 'جِ', 'بِ', 'اِ', 'تِ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 5, data: _data);
  }
}