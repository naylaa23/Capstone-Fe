import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/mascot.dart';
import '../../widgets/stars.dart';
import '../auth/login_screen.dart';
import '../iqro/jilid_list_screen.dart';
import '../quiz/quiz_map_screen.dart';
import '../writing/writing_home_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final progress = context.read<ProgressProvider>();
    final nav = Navigator.of(context);
    await auth.logout();
    progress.clear();
    nav.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final progress = context.watch<ProgressProvider>();
    final nav = Navigator.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Halo, ${user?.nickname ?? ''}!',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tealDark,
                    ),
                  ),
                ),
                StarCounter(stars: progress.totalStars),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'logout') _logout(context);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'logout', child: Text('Keluar')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Mascot(size: 72),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'Mau belajar apa hari ini?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _MenuCard(
              emoji: '📖',
              color: AppColors.sky,
              title: 'Membaca Iqro',
              subtitle: 'Jilid 1 dan 2 · ada suara',
              onStart: () => nav.push(
                  MaterialPageRoute(builder: (_) => const JilidListScreen())),
            ),
            _MenuCard(
              emoji: '✏️',
              color: AppColors.pink,
              title: 'Menulis',
              subtitle: 'Tulis · foto · dapat bintang',
              onStart: () => nav.push(MaterialPageRoute(
                  builder: (_) => const WritingHomeScreen())),
            ),
            _MenuCard(
              emoji: '🧩',
              color: AppColors.mint,
              title: 'Kuis',
              subtitle: '20 level · uji hafalanmu',
              onStart: () => nav.push(
                  MaterialPageRoute(builder: (_) => const QuizMapScreen())),
            ),
            const SizedBox(height: 8),
            // Label level + bar progres (dengan keterangan angka yang jelas).
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${progress.learnerLevel}: ${progress.learnerLevelName}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress.levelProgress,
                      minHeight: 12,
                      backgroundColor: AppColors.border,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${progress.starsIntoLevel} dari ${ProgressProvider.starsPerLevel} bintang menuju Level ${progress.learnerLevel + 1}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String emoji;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onStart;

  const _MenuCard({
    required this.emoji,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textDark)),
              ],
            ),
          ),
          SizedBox(
            width: 92,
            child: PrimaryButton(label: 'Mulai', onPressed: onStart),
          ),
        ],
      ),
    );
  }
}
