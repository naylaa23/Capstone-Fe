import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/quiz_bank.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/mascot.dart';
import '../../widgets/stars.dart';
import 'quiz_play_screen.dart';

/// "Kuis selesai!" - bintang, skor, dan level berikutnya yang terbuka.
class QuizResultScreen extends StatelessWidget {
  final int level;
  final int correct;
  final int total;
  final int stars;
  final bool passed;

  const QuizResultScreen({
    super.key,
    required this.level,
    required this.correct,
    required this.total,
    required this.stars,
    required this.passed,
  });

  @override
  Widget build(BuildContext context) {
    final nextOpen = passed && level < QuizBank.totalLevels;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Mascot(size: 110),
              const SizedBox(height: 16),
              const Text('Kuis selesai!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.tealDark)),
              const SizedBox(height: 12),
              StarsRow(count: stars, size: 56),
              const SizedBox(height: 16),
              Text('Skor: $correct / $total',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                passed
                    ? (nextOpen
                        ? 'Jawaban benar. Level ${level + 1} sudah terbuka!'
                        : 'Jawaban benar. Semua level kuis sudah selesai!')
                    : 'Belum lulus. Ayo ulangi level ini!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Kembali ke peta level',
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 12),
              OutlineButtonX(
                label: 'Ulangi level',
                icon: Icons.refresh_rounded,
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (_) => QuizPlayScreen(level: level)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
