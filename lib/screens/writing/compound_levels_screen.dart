import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/writing_data.dart';
import '../../models/writing_target.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/arabic_text.dart';
import '../../widgets/stars.dart';
import 'writing_level_screen.dart';

/// "Huruf Gabungan": 10 level, level berikutnya terkunci sampai yang
/// sebelumnya selesai.
class CompoundLevelsScreen extends StatelessWidget {
  const CompoundLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    const kind = WritingKind.compound;

    return Scaffold(
      appBar: AppBar(title: const Text('Huruf Gabungan')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${WritingData.compoundLevels} level, gandengkan 2 huruf',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: WritingData.compoundLevels,
              itemBuilder: (_, i) {
                final level = i + 1;
                final unlocked = p.isWritingUnlocked(kind, level);
                final done = p.isWritingCompleted(kind, level);
                final t = WritingData.compound(level);
                return Opacity(
                  opacity: unlocked ? 1 : 0.5,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: unlocked ? AppColors.pink : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Text('Level $level',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 16)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: unlocked
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                      child: ArabicText(
                                          '${t.parts[0]} + ${t.parts[1]}',
                                          size: 24,
                                          color: AppColors.tealDark),
                                    ),
                                    if (done)
                                      StarsRow(
                                          count: p.writingStarsOf(kind, level),
                                          size: 16),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        if (unlocked)
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => WritingLevelScreen(
                                  kind: kind,
                                  level: level,
                                  totalLevel: WritingData.compoundLevels,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(done ? 'Ulangi' : 'Mulai'),
                          )
                        else
                          const Row(
                            children: [
                              Icon(Icons.lock_outline,
                                  size: 18, color: AppColors.textMuted),
                              SizedBox(width: 4),
                              Text('Terkunci',
                                  style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                      ],
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