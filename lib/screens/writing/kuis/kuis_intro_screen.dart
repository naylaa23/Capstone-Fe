import 'package:flutter/material.dart';

import 'kuis_router_screen.dart';

class KuisIntroScreen extends StatelessWidget {
  final int level;

  const KuisIntroScreen({super.key, this.level = 1});

  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _orange = Color(0xFFFF9A4D);
  static const Color _lilac = Color(0xFFB39DFA);
  static const Color _green = Color(0xFF4CD787);
  static const Color _pink = Color(0xFFFF8DB8);

  Future<void> _mulai(BuildContext context) async {
    // Layar soal dipilih oleh router. Tunggu hasilnya:
    // true = anak menekan "Selesai" di layar soal.
    final selesai = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => kuisLevelScreen(level)),
    );

    // Teruskan sinyal selesai ke peta level, lalu tutup layar pembuka ini.
    if (selesai == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.maybePop(context),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child:
                            Icon(Icons.chevron_left, size: 26, color: _navy),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Siap main kuis?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Penjelasan
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          '10 level! 1 soal tiap level. Ada 2 jenis soal: '
                          'dengar suara lalu pilih tulisan, atau lihat '
                          'tulisan lalu ucapkan lewat mikrofon. '
                          'Level 10 punya timer 20 detik.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            fontWeight: FontWeight.w700,
                            color: _navy,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Label kecil di gambar',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                      const SizedBox(height: 12),

                      const _FormCard(
                        arab: 'بـ',
                        label: 'awal',
                        labelColor: _orange,
                        caption: 'Di depan, menyambung ke kiri',
                      ),
                      const SizedBox(height: 12),
                      const _FormCard(
                        arab: 'ـبـ',
                        label: 'tengah',
                        labelColor: _lilac,
                        caption: 'Di tengah, ada sambungan di kedua sisi',
                      ),
                      const SizedBox(height: 12),
                      const _FormCard(
                        arab: 'ـب',
                        label: 'akhir',
                        labelColor: _green,
                        caption: 'Di belakang, menyambung dari kanan',
                      ),
                      const SizedBox(height: 12),
                      const _FormCard(
                        arab: 'كتب',
                        label: 'kata',
                        labelColor: _pink,
                        caption: 'Beberapa huruf sudah tersambung',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol mulai
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _mulai(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _purple,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    'Mulai level $level',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satu baris: contoh bentuk huruf + label warna + keterangan
class _FormCard extends StatelessWidget {
  final String arab;
  final String label;
  final Color labelColor;
  final String caption;

  const _FormCard({
    required this.arab,
    required this.label,
    required this.labelColor,
    required this.caption,
  });

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Contoh huruf
          SizedBox(
            width: 72,
            height: 48,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                arab,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 38,
                  height: 1.2,
                  color: _navy,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Label + keterangan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    color: labelColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}