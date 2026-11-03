import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/writing_target.dart';
import '../../services/handwriting_scorer.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/stars.dart';

enum WritingResultAction { retry, next }

/// Hasil penilaian: pesan, persentase kemiripan, bintang, dan tombol lanjut.
/// Huruf satuan: "Level berikutnya". Huruf gabungan: "Lanjut".
class WritingResultScreen extends StatelessWidget {
  final HandwritingResult result;
  final WritingKind kind;

  const WritingResultScreen({
    super.key,
    required this.result,
    required this.kind,
  });

  @override
  Widget build(BuildContext context) {
    final color = result.stars >= 3
        ? AppColors.success
        : (result.passed ? AppColors.orange : AppColors.error);

    return PopScope(
      canPop: false, // keluar hanya lewat tombol agar alur tidak rusak
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                StarsRow(count: result.stars, size: 56),
                const SizedBox(height: 20),
                Text(result.title,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: color)),
                const SizedBox(height: 8),
                Text(result.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Text('Kemiripan',
                          style: TextStyle(color: AppColors.textMuted)),
                      Text('${result.percent}%',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w800,
                              color: color)),
                    ],
                  ),
                ),
                const Spacer(),
                if (result.passed) ...[
                  PrimaryButton(
                    label: kind == WritingKind.single
                        ? 'Level berikutnya'
                        : 'Lanjut',
                    onPressed: () =>
                        Navigator.of(context).pop(WritingResultAction.next),
                  ),
                  const SizedBox(height: 12),
                ],
                OutlineButtonX(
                  label: 'Coba lagi',
                  icon: Icons.refresh_rounded,
                  onPressed: () =>
                      Navigator.of(context).pop(WritingResultAction.retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
