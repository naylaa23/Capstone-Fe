import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro6Screen extends StatelessWidget {
  const Iqro6Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    barisTanpaPembagi: {7}, // baris ke-7 (paling bawah) tanpa garis tengah
    baris: [
      // Baris judul (urutan baca dari kanan: ja, ha, kha)
      ['جَ', 'حَ', 'خَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['حَ', 'اَ', 'جَ', 'خَ', 'اَ', 'خَ'],
      ['ثَ', 'اَ', 'خَ', 'جَ', 'تَ', 'جَ'],
      ['بَ', 'اَ', 'خَ', 'تَ', 'حَ', 'ثَ'],
      ['جَ', 'اَ', 'حَ', 'بَ', 'حَ', 'ثَ'],
      ['تَ', 'اَ', 'خَ', 'جَ', 'حَ', 'ثَ'],
      ['اَ', 'خَ', 'حَ', 'خَ', 'جَ', 'خَ'],
      ['بَ', 'اَ', 'تَ', 'ثَ', 'حَ', 'جَ', 'خَ', 'خَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 6, data: _data);
  }
}