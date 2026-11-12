import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro8Screen extends StatelessWidget {
  const Iqro8Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    barisTanpaPembagi: {7}, // baris ke-7 (paling bawah) tanpa garis tengah
    baris: [
      // Baris judul (urutan baca dari kanan: dal, dzal)
      ['دَ', 'ذَ'],
      // Baris isi: dibaca dari kanan ke kiri
      ['دَ', 'اَ', 'ذَ', 'خَ', 'دَ', 'ذَ'],
      ['اَ', 'حَ', 'دَ', 'جَ', 'حَ', 'ذَ'],
      ['خَ', 'تَ', 'دَ', 'اَ', 'ثَ', 'ذَ'],
      ['جَ', 'حَ', 'خَ', 'ذَ', 'بَ', 'حَ'],
      ['حَ', 'دَ', 'ثَ', 'اَ', 'خَ', 'ذَ'],
      ['اَ', 'ذَ', 'دَ', 'خَ', 'دَ', 'ذَ'],
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ', 'ذَ', 'دَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 8, data: _data);
  }
}