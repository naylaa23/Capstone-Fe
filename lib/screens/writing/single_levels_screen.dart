import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/writing_data.dart';
import '../../models/writing_target.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/arabic_text.dart';
import '../../widgets/stars.dart';
import 'writing_level_screen.dart';

/// "Huruf Satuan": 28 level. Level terbuka berwarna, sisanya pucat.
class SingleLevelsScreen extends StatelessWidget {
  const SingleLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    const kind = WritingKind.single;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Huruf Satuan'),
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
              '${p.writingDone(kind)} level selesai dari ${WritingData.singleLevels}',
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
              itemCount: WritingData.singleLevels,
              itemBuilder: (_, i) {
                final level = i + 1;
                final unlocked = p.isWritingUnlocked(kind, level);
                final done = p.isWritingCompleted(kind, level);
                final target = WritingData.single(level);
                final palette = [
                  AppColors.sky,
                  AppColors.pink,
                  AppColors.mint,
                  AppColors.cream,
                ];
                return Opacity(
                  opacity: unlocked ? 1 : 0.35,
                  child: Material(
                    color: palette[i % palette.length],
                    borderRadius: BorderRadius.circular(18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: unlocked
                          ? () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => WritingLevelScreen(
                                  kind: kind, level: level)))
                          : null,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$level',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15)),
                          Flexible(
                            child: FittedBox(
                              child: ArabicText(target.arabic,
                                  size: 26, color: AppColors.tealDark),
                            ),
                          ),
                          if (done)
                            StarsRow(
                                count: p.writingStarsOf(kind, level), size: 12),
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
