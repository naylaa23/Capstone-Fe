import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro5Screen extends StatelessWidget {
  const Iqro5Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis tengah
    // Baris paling bawah (deretan huruf berurutan) tanpa garis tengah
    barisTanpaPembagi: {7},
    baris: [
      // 0: baris judul (urutan baca dari kanan: ja, ha)
      ['جَ','حَ'],
      // 1-6: baris isi dengan garis tengah (semuanya 6 huruf),
      // dibaca dari kanan ke kiri
      ['جَ', 'اَ', 'حَ', 'جَ', 'حَ', 'ثَ'],
      ['حَ', 'جَ', 'تَ', 'بَ', 'حَ', 'ثَ'],
      ['جَ', 'حَ', 'تَ', 'اَ', 'حَ', 'بَ'],
      ['جَ', 'اَ', 'ثَ', 'حَ', 'اَ', 'حَ'],
      ['ثَ', 'حَ', 'بَ', 'تَ', 'اَ', 'حَ'],
      ['اَ', 'جَ', 'جَ', 'اَ', 'حَ', 'حَ'],
      // 7: deretan huruf berurutan, satu baris utuh tanpa garis tengah
      ['اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ'],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 5, data: _data);
  }
}