import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/writing_data.dart';
import '../../models/writing_target.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/mascot.dart';
import '../../widgets/stars.dart';

enum LevelCompleteAction { nextLevel, backToList }

/// "Level N selesai!" - judul, bintang, dan level yang terbuka selalu
/// mengikuti level & hasil yang sedang dikerjakan.
class LevelCompleteScreen extends StatelessWidget {
  final WritingKind kind;
  final int level;
  final int stars;

  const LevelCompleteScreen({
    super.key,
    required this.kind,
    required this.level,
    required this.stars,
  });

  @override
  Widget build(BuildContext context) {
    final total = kind == WritingKind.single
        ? WritingData.singleLevels
        : WritingData.compoundLevels;
    final hasNext = level < total;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const Mascot(size: 110),
                const SizedBox(height: 20),
                Text('Level $level selesai!',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.tealDark)),
                const SizedBox(height: 12),
                StarsRow(count: stars, size: 56),
                const SizedBox(height: 16),
                Text(
                  hasNext
                      ? 'Level ${level + 1} sudah terbuka. Ayo lanjut!'
                      : 'Hebat! Semua level sudah selesai.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                if (hasNext) ...[
                  PrimaryButton(
                    label: 'Level berikutnya',
                    onPressed: () => Navigator.of(context)
                        .pop(LevelCompleteAction.nextLevel),
                  ),
                  const SizedBox(height: 12),
                ],
                OutlineButtonX(
                  label: 'Kembali ke daftar level',
                  onPressed: () => Navigator.of(context)
                      .pop(LevelCompleteAction.backToList),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
