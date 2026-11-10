import 'package:flutter/material.dart';

/// Dialog "Batas Maksimal Tercapai!"
/// Mengembalikan true kalau anak memilih "Reset Pilihan".
class BatasDialog extends StatelessWidget {
  const BatasDialog({super.key});

  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _purpleDark = Color(0xFF4A2BB8);
  static const Color _orange = Color(0xFFFF7A00);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE6D5),
                shape: BoxShape.circle,
                border: Border.all(color: _orange, width: 1.5),
              ),
              child: const Icon(
                Icons.priority_high_rounded,
                size: 26,
                color: _orange,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Batas Maksimal Tercapai!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Untuk mode latihan ini, kombinasi dibatasi maksimal '
              '3 huruf bersambung.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                height: 1.4,
                color: Color(0xFF6B6B7B),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _purpleDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Lanjut Menulis',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context, true),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text(
                  'Reset Pilihan',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _purple,
                  side: const BorderSide(color: _purple, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Titik berwarna + tulisan kecil di bawah kotak menulis ("Garis", "Titik")
class TitikLegend extends StatelessWidget {
  final Color warna;
  final String teks;

  const TitikLegend({super.key, required this.warna, required this.teks});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          teks,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2A1B6B),
          ),
        ),
      ],
    );
  }
}