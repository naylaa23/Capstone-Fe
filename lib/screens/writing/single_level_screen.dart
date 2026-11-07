import 'package:flutter/material.dart';

import 'writing_level_screen.dart';

class SingleLevelsScreen extends StatelessWidget {
  const SingleLevelsScreen({super.key});

  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);

  // Warna kotak level bergantian: hijau, biru, pink, kuning
  static const List<Color> _palette = [
    Color(0xFF4CD787),
    Color(0xFF5BB5FF),
    Color(0xFFFF8DB8),
    Color(0xFFFFC93C),
  ];

  // Data contoh (ganti dari ProgressProvider / writing_data.dart nanti)
  static const int _totalLevel = 28;
  static const int _levelTerbuka = 4; // level 1..4 sudah terbuka
  static const int _levelSelesai = 3;
  static const int _jumlahBintang = 12;

  void _onLevelTap(BuildContext context, int level, bool terbuka) {
    if (!terbuka) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selesaikan level sebelumnya dulu ya')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            WritingLevelScreen(level: level, totalLevel: _totalLevel),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: kembali, judul, bintang
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
                  const Expanded(
                    child: Text(
                      'Huruf Satuan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _purple,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded,
                            size: 18, color: Color(0xFFFFB800)),
                        SizedBox(width: 4),
                        Text(
                          '$_jumlahBintang',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _navy,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                '$_levelSelesai level selesai dari $_totalLevel',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 14),

              // Peta level
              Expanded(
                child: GridView.builder(
                  itemCount: _totalLevel,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, i) {
                    final level = i + 1;
                    final terbuka = level <= _levelTerbuka;
                    return _LevelTile(
                      level: level,
                      color: _palette[i % _palette.length],
                      terbuka: terbuka,
                      onTap: () => _onLevelTap(context, level, terbuka),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final int level;
  final Color color;
  final bool terbuka;
  final VoidCallback onTap;

  const _LevelTile({
    required this.level,
    required this.color,
    required this.terbuka,
    required this.onTap,
  });

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    final bg = terbuka ? color : color.withOpacity(0.28);
    final textColor = terbuka ? _navy : const Color(0xFF8C8C8C);

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Level',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            Text(
              '$level',
              style: TextStyle(
                fontSize: 26,
                height: 1.1,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}