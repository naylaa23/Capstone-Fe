import 'package:flutter/material.dart';
import '../writing/writing_home_screen.dart';
import '../writing/kuis/kuis_level_screen.dart';
import '../writing/membaca/iqro1_screen.dart';
import '../writing/membaca/iqro3_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String nama;

  const DashboardScreen({super.key, this.nama = 'Aisyah'});

  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _orange = Color(0xFFFF9A4D);
  static const Color _green = Color(0xFF4CD787);
  static const Color _purple = Color(0xFFB39DFA);
  static const Color _pink = Color(0xFFFF6B9A);

  static const String _levelLabel = 'Level 2: Huruf Dasar';
  static const double _levelProgress = 0.4; // 0.0 - 1.0

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
                  Image.asset(
                    'assets/images/logo dashboard.png',
                    width: 55,
                    height: 55,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 17),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat datang,',
                        style: TextStyle(fontSize: 17, color: _navy),
                      ),
                      Text(
                        'Halo, $nama !',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 44), // jarak ke "Mau belajar apa hari ini?"

              const Text(
                'Mau belajar apa hari ini?',
                style: TextStyle(fontSize: 15, color: _navy),
              ),
              const SizedBox(height: 12),

              // Menu
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _MenuCard(
                        color: _orange,
                        title: 'Membaca\nIqro',
                        subtitle: 'Jilid 1 dan 2, ada suara',
                        icon: const Icon(Icons.menu_book_rounded,
                            size: 40, color: _orange),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const IqroHalamanScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MenuCard(
                        color: _green,
                        title: 'Menulis',
                        subtitle: 'Tulis di layar, dapat bintang',
                        icon: const Icon(Icons.edit_rounded,
                            size: 40, color: _green),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WritingHomeScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _MenuCard(
                        color: _purple,
                        title: 'Kuis',
                        subtitle: '10 level huruf sambung',
                        icon: const Text(
                          '?',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: _navy,
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const QuizLevelsScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Progress level
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      _levelLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _levelProgress,
                        minHeight: 10,
                        backgroundColor: const Color(0xFFEDE9FE),
                        valueColor: const AlwaysStoppedAnimation(_pink),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final Widget icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  static const Color _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              // Kotak ikon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: icon),
              ),
              const SizedBox(width: 14),

              // Judul + subjudul
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13, color: _navy),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Tombol Mulai
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Mulai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _navy,
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