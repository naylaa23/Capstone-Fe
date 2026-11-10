import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro3Screen extends StatelessWidget {
  const Iqro3Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    baris: [
      // Baris judul (huruf besar paling atas)
      ['بَ', 'تَ', 'ثَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['تَ', 'بَ', 'ثَ', 'ثَ', 'بَ', 'تَ'],
      ['بَ', 'تَ', 'ثَ', 'تَ', 'ثَ', 'بَ'],
      ['اَ', 'بَ', 'ثَ', 'ثَ', 'تَ', 'بَ'],
      ['ثَ', 'بَ', 'تَ', 'بَ', 'اَ', 'تَ'],
      ['تَ', 'ثَ', 'بَ', 'اَ', 'ثَ', 'بَ'],
      ['بَ', 'ثَ', 'تَ', 'تَ', 'بَ', 'ثَ'],
      ['ثَ', 'اَ', 'بَ', 'تَ', 'تَ', 'بَ', 'ثَ', 'اَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 3, data: _data);
  }
}