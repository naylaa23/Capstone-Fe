import 'package:flutter/material.dart';

class QuizLevelsScreen extends StatelessWidget {
  const QuizLevelsScreen({super.key});

  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _orange = Color(0xFFFF9A4D);
  static const Color _lilac = Color(0xFFB39DFA);
  static const Color _green = Color(0xFF4CD787);
  static const Color _pink = Color(0xFFFF8DB8);

  // Data contoh (ganti dari ProgressProvider nanti)
  static const int _jumlahBintang = 12;
  static const int _levelTerbuka = 1; // level 1..N sudah terbuka

  static const List<_QuizGroup> _groups = [
    _QuizGroup(
      label: 'Bentuk awal',
      caption: 'Mengenali huruf di awal kata',
      color: _orange,
      levels: [1, 2, 3],
    ),
    _QuizGroup(
      label: 'Bentuk tengah',
      caption: 'Mengenali huruf di tengah kata',
      color: _lilac,
      levels: [4, 5],
    ),
    _QuizGroup(
      label: 'Bentuk akhir',
      caption: 'Termasuk huruf yang tidak menyambung',
      color: _green,
      levels: [6, 7],
    ),
    _QuizGroup(
      label: 'Kata sambung',
      caption: 'Level 10 pakai timer 20 detik',
      color: _pink,
      levels: [8, 9, 10],
    ),
  ];

  void _onLevelTap(BuildContext context, int level) {
    final terbuka = level <= _levelTerbuka;
    final pesan = terbuka
        ? 'Kuis level $level segera hadir'
        : 'Selesaikan level sebelumnya dulu ya';
    // kalau terbuka, Navigator.push ke layar soal kuis
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
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
                      'Kuis',
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
                'Huruf sambung: 10 level, 1 soal tiap level',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 16),

              // Kelompok level
              for (final g in _groups) ...[
                _GroupSection(
                  group: g,
                  levelTerbuka: _levelTerbuka,
                  onLevelTap: (level) => _onLevelTap(context, level),
                ),
                const SizedBox(height: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizGroup {
  final String label;
  final String caption;
  final Color color;
  final List<int> levels;

  const _QuizGroup({
    required this.label,
    required this.caption,
    required this.color,
    required this.levels,
  });
}

class _GroupSection extends StatelessWidget {
  final _QuizGroup group;
  final int levelTerbuka;
  final ValueChanged<int> onLevelTap;

  const _GroupSection({
    required this.group,
    required this.levelTerbuka,
    required this.onLevelTap,
  });

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label kelompok
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: group.color,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            group.label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          group.caption,
          style: const TextStyle(fontSize: 15, color: _navy),
        ),
        const SizedBox(height: 10),

        // Kartu level
        Row(
          children: [
            for (int i = 0; i < group.levels.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: _LevelCard(
                  level: group.levels[i],
                  color: group.color,
                  terbuka: group.levels[i] <= levelTerbuka,
                  aktif: group.levels[i] == levelTerbuka,
                  onTap: () => onLevelTap(group.levels[i]),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final int level;
  final Color color;
  final bool terbuka;
  final bool aktif; // level yang sedang dikerjakan: berwarna penuh
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.color,
    required this.terbuka,
    required this.aktif,
    required this.onTap,
  });

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    final bg = aktif ? color : Colors.white;
    final textColor = aktif ? Colors.white : _navy;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 70,
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
                  fontSize: 24,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              if (!terbuka)
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(Icons.lock_rounded,
                      size: 11, color: Color(0xFF9AA0A6)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}