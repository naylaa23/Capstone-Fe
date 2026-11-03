import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/writing_data.dart';
import '../../models/writing_target.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/arabic_text.dart';
import 'compound_levels_screen.dart';
import 'single_levels_screen.dart';

/// "Ayo menulis!" - pilih kategori Huruf Satuan atau Huruf Gabungan.
class WritingHomeScreen extends StatelessWidget {
  const WritingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProgressProvider>();
    final nav = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayo menulis!')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Pilih kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          _CategoryCard(
            color: AppColors.sky,
            title: 'Huruf Satuan',
            subtitle: '${WritingData.singleLevels} level',
            progressText:
                'Level ${p.writingCurrentLevel(WritingKind.single)} dari ${WritingData.singleLevels}',
            example: const ArabicText('ث', size: 48, color: AppColors.tealDark),
            onPick: () => nav.push(MaterialPageRoute(
                builder: (_) => const SingleLevelsScreen())),
          ),
          _CategoryCard(
            color: AppColors.pink,
            title: 'Huruf Gabungan',
            subtitle: '${WritingData.compoundLevels} level',
            progressText:
                'Level ${p.writingCurrentLevel(WritingKind.compound)} dari ${WritingData.compoundLevels}',
            // Contoh sama dengan Level 1: ب + ت = بت
            example: const ArabicText('ب + ت = بت',
                size: 28, color: AppColors.tealDark),
            onPick: () => nav.push(MaterialPageRoute(
                builder: (_) => const CompoundLevelsScreen())),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;
  final String progressText;
  final Widget example;
  final VoidCallback onPick;

  const _CategoryCard({
    required this.color,
    required this.title,
    required this.subtitle,
    required this.progressText,
    required this.example,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: example,
          ),
          const SizedBox(height: 12),
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          Text('$subtitle · $progressText',
              style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 12),
          PrimaryButton(label: 'Pilih', onPressed: onPick),
        ],
      ),
    );
  }
}
