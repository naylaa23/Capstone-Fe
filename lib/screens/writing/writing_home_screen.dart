import 'package:flutter/material.dart';
import 'single_level_screen.dart';

class WritingHomeScreen extends StatelessWidget {
  const WritingHomeScreen({super.key});

  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _green = Color(0xFF4CD787);
  static const Color _yellow = Color(0xFFFFD43B);

  // Data contoh (ganti dari ProgressProvider / writing_data.dart nanti)
  static const int _levelSatuan = 4;
  static const int _totalSatuan = 28;
  static const int _levelGabungan = 1;
  static const int _totalGabungan = 10;

  void _segeraHadir(BuildContext context, String fitur) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Fitur $fitur segera hadir')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: tombol kembali + judul
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
                    'Ayo menulis!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _purple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text(
                'Pilih kategori',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 12),

              // Kartu Huruf Satuan
              _CategoryCard(
                color: _green,
                preview: const Text(
                  'ب',
                  style: TextStyle(
                    fontSize: 84,
                    height: 1.2,
                    color: _navy,
                  ),
                ),
                title: 'Huruf Satuan',
                subtitle: '$_totalSatuan level, tulis 1 huruf per level',
                progress: 'Level $_levelSatuan dari $_totalSatuan',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SingleLevelsScreen(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Kartu Huruf Gabungan
              _CategoryCard(
                color: _yellow,
                preview: const _CombinePreview(),
                title: 'Huruf Gabungan',
                subtitle: 'Gandengkan 2, 3, dan 4 huruf',
                progress: 'Level $_levelGabungan dari $_totalGabungan',
                // Navigator.push ke compound_levels_screen.dart
                onTap: () => _segeraHadir(context, 'Huruf Gabungan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Contoh gabungan huruf: با = ا + ب
class _CombinePreview extends StatelessWidget {
  const _CombinePreview();

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    const arab = TextStyle(fontSize: 52, height: 1.4, color: _navy);
    const simbol = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: _navy,
    );

    // LTR supaya urutannya sama dengan desain
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('با', style: arab),
          SizedBox(width: 14),
          Text('=', style: simbol),
          SizedBox(width: 14),
          Text('ا', style: arab),
          SizedBox(width: 14),
          Text('+', style: simbol),
          SizedBox(width: 14),
          Text('ب', style: arab),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Color color;
  final Widget preview;
  final String title;
  final String subtitle;
  final String progress;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.color,
    required this.preview,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.onTap,
  });

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          preview,
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: _navy),
          ),
          const SizedBox(height: 10),
          Text(
            progress,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
          const SizedBox(height: 14),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: onTap,
              child: const SizedBox(
                width: 130,
                height: 44,
                child: Center(
                  child: Text(
                    'Pilih',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _navy,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}