import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/quiz_bank.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/stars.dart';
import 'quiz_play_screen.dart';

/// Peta level kuis: 20 level. Selesai = berwarna, level aktif = kuning,
/// level di depannya = putih (terkunci).
class QuizMapScreen extends StatelessWidget {
  const QuizMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: StarCounter(stars: p.totalStars)),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${p.quizDone} level selesai dari ${QuizBank.totalLevels}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: QuizBank.totalLevels,
              itemBuilder: (_, i) {
                final level = i + 1;
                final unlocked = p.isQuizUnlocked(level);
                final done = p.isQuizCompleted(level);
                final active = unlocked && !done;

                final Color bg = active
                    ? AppColors.yellow
                    : (done ? AppColors.mint : Colors.white);

                return Material(
                  color: bg,
                  borderRadius: BorderRadius.circular(18),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: unlocked
                        ? () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => QuizPlayScreen(level: level)))
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: active ? AppColors.orange : AppColors.border,
                          width: active ? 3 : 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (unlocked)
                            Text('$level',
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w800))
                          else
                            const Icon(Icons.lock_outline,
                                color: AppColors.textMuted),
                          if (done)
                            StarsRow(count: p.quizStarsOf(level), size: 13),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
