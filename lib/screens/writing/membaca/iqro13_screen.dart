import 'package:flutter/material.dart';

import 'iqro_base_screen.dart';

class Iqro13Screen extends StatelessWidget {
  const Iqro13Screen({super.key});

  static const IqroHalaman _data = IqroHalaman(
    instruksi: '',
    legend: [],
    adaJudul: true, // baris pertama = judul, tanpa garis
    // Garis vertikal setiap 3 huruf: tiap baris jadi 3 balok
    hurufPerBalok: 3,
    baris: [
      // 0: baris judul
      ['صَ'],
      // 1-6: baris isi, semuanya 9 huruf = 3 balok x 3 huruf.
      // Dibaca dari kanan ke kiri: balok kanan, tengah, kiri.
      ['صَ', 'اَ', 'شَ', 'صَ', 'شَ', 'زَ', 'سَ', 'رَ', 'صَ'],
      ['صَ', 'ثَ', 'ذَ', 'صَ', 'سَ', 'دَ', 'شَ', 'رَ', 'تَ'],
      ['صَ', 'زَ', 'ذَ', 'دَ', 'صَ', 'حَ', 'صَ', 'خَ', 'سَ'],
      ['زَ', 'جَ', 'سَ', 'صَ', 'بَ', 'شَ', 'رَ', 'ذَ', 'حَ'],
      ['زَ', 'رَ', 'شَ', 'ذَ', 'جَ', 'صَ', 'خَ', 'دَ', 'صَ'],
      ['صَ', 'خَ', 'ثَ', 'اَ', 'بَ', 'تَ', 'ثَ', 'جَ', 'حَ'],
      // 7: deretan huruf berurutan (8 huruf). Sel kosong di ujung kiri
      // supaya garis vertikalnya sejajar dengan baris lain.
      ['خَ', 'دَ', 'ذَ', 'رَ', 'زَ', 'سَ', 'شَ', 'صَ', ''],
    ],
  );

  @override
  Widget build(BuildContext context) {
    return const IqroHalamanView(halaman: 13, data: _data);
  }
}