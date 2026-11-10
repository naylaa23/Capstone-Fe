import 'package:flutter/material.dart';

import 'iqro1_screen.dart';
import 'iqro2_screen.dart';
import 'iqro3_screen.dart';
import 'iqro4_screen.dart';
import 'iqro5_screen.dart';
import 'iqro6_screen.dart';
import 'iqro7_screen.dart';
import 'iqro8_screen.dart';
import 'iqro9_screen.dart';
import 'iqro10_screen.dart';
import 'iqro11_screen.dart';
import 'iqro12_screen.dart';
import 'iqro_base_screen.dart';

/// Memilih layar halaman Iqro Jilid 1 sesuai nomor halaman.
/// Halaman yang filenya belum dibuat menampilkan "belum tersedia".
Widget iqroHalamanScreen(int halaman) {
  switch (halaman) {
    case 1:
      return const Iqro1Screen();
    case 2:
      return const Iqro2Screen();
    case 3:
      return const Iqro3Screen();
    case 4:
      return const Iqro4Screen();
    case 5:
      return const Iqro5Screen();
    case 6:
      return const Iqro6Screen();
    case 7:
      return const Iqro7Screen();
    case 8:
      return const Iqro8Screen();
    case 9:
      return const Iqro9Screen();
    case 10:
      return const Iqro10Screen();
    case 11:
      return const Iqro11Screen();
    case 12:
      return const IqroHalamanView(halaman: 12, data: null);
    default:
      return IqroHalamanView(halaman: halaman, data: null);
  }
}