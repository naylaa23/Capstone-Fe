import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Teks Arab dengan font Amiri dan tinggi baris longgar supaya tanda baris
/// (fathah/kasrah/dhammah) tidak keluar dari kartu.
class ArabicText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;

  const ArabicText(
    this.text, {
    super.key,
    this.size = 40,
    this.color = const Color(0xFF1E2F33),
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
      style: GoogleFonts.amiri(
        fontSize: size,
        height: 2.0,
        color: color,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
