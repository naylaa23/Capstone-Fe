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
import 'iqro13_screen.dart';
import 'iqro14_screen.dart';
import 'iqro15_screen.dart';
import 'iqro16_screen.dart';
import 'iqro17_screen.dart';
import 'iqro18_screen.dart';
import 'iqro19_screen.dart';
import 'iqro20_screen.dart';
import 'iqro21_screen.dart';
import 'iqro22_screen.dart';
import 'iqro23_screen.dart';
import 'iqro24_screen.dart';
import 'iqro25_screen.dart';
import 'iqro26_screen.dart';
import 'iqro27_screen.dart';
import 'iqro28_screen.dart';
import 'iqro29_screen.dart';
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
      return const Iqro12Screen();
    case 13:
      return const Iqro13Screen();
    case 14:
      return const Iqro14Screen();
    case 15:
      return const Iqro15Screen();
    case 16:
      return const Iqro16Screen();
    case 17:
      return const Iqro17Screen();
    case 18:
      return const Iqro18Screen();
    case 19:
      return const Iqro19Screen();
    case 20:
      return const Iqro20Screen();
    case 21:
      return const Iqro21Screen();
    case 22:
      return const Iqro22Screen();
    case 23:
      return const Iqro23Screen();
    case 24:
      return const Iqro24Screen();
    case 25:
      return const Iqro25Screen();
    case 26:
      return const Iqro26Screen();
    case 27:
      return const Iqro27Screen();
    case 28:
      return const Iqro28Screen();
    case 29:
      return const Iqro29Screen();
    default:
      return IqroHalamanView(halaman: halaman, data: null);
  }
}