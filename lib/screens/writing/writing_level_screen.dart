import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/writing_data.dart';
import '../../models/writing_target.dart';
import '../../providers/progress_provider.dart';
import '../../services/handwriting_scorer.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/arabic_text.dart';
import 'camera_capture_screen.dart';
import 'level_complete_screen.dart';
import 'writing_result_screen.dart';

/// Halaman satu level menulis (huruf satuan / gabungan):
/// tampilkan sasaran -> kamera -> penilaian -> hasil.
class WritingLevelScreen extends StatefulWidget {
  final WritingKind kind;
  final int level;

  const WritingLevelScreen({super.key, required this.kind, required this.level});

  @override
  State<WritingLevelScreen> createState() => _WritingLevelScreenState();
}

class _WritingLevelScreenState extends State<WritingLevelScreen> {
  bool _busy = false;

  WritingTarget get _target => WritingData.of(widget.kind, widget.level);

  Future<void> _attempt() async {
    final nav = Navigator.of(context);
    final progress = context.read<ProgressProvider>();
    final t = _target;

    final path = await nav.push<String>(MaterialPageRoute(
      builder: (_) => CameraCaptureScreen(title: 'Level ${t.level}: ${t.latin}'),
    ));
    if (path == null || !mounted) return;

    setState(() => _busy = true);
    HandwritingResult result;
    try {
      result = await HandwritingScorer.score(
        imagePath: path,
        expectedDots: t.expectedDots,
        compound: t.isCompound,
      );
    } catch (_) {
      result = HandwritingResult.fromPercent(0, compound: t.isCompound);
    }
    if (!mounted) return;
    setState(() => _busy = false);

    // Level dianggap selesai (dan level berikutnya terbuka) jika lulus.
    if (result.passed) {
      await progress.completeWriting(widget.kind, widget.level, result.stars);
    }
    if (!mounted) return;

    final action = await nav.push<WritingResultAction>(MaterialPageRoute(
      builder: (_) => WritingResultScreen(result: result, kind: widget.kind),
    ));
    if (!mounted || action == null) return;

    switch (action) {
      case WritingResultAction.retry:
        await _attempt(); // kembali ke kamera untuk level yang sama
        break;
      case WritingResultAction.next:
        if (widget.kind == WritingKind.single) {
          _goNextLevel(nav);
        } else {
          final complete = await nav.push<LevelCompleteAction>(
            MaterialPageRoute(
              builder: (_) => LevelCompleteScreen(
                kind: widget.kind,
                level: widget.level,
                stars: result.stars,
              ),
            ),
          );
          if (!mounted) return;
          if (complete == LevelCompleteAction.nextLevel) {
            _goNextLevel(nav);
          } else if (complete == LevelCompleteAction.backToList) {
            nav.pop();
          }
        }
        break;
    }
  }

  void _goNextLevel(NavigatorState nav) {
    if (widget.level < _target.totalLevels) {
      nav.pushReplacement(MaterialPageRoute(
        builder: (_) =>
            WritingLevelScreen(kind: widget.kind, level: widget.level + 1),
      ));
    } else {
      nav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _target;
    return Scaffold(
      appBar: AppBar(title: Text('Level ${t.level} dari ${t.totalLevels}')),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: t.level / t.totalLevels,
                      minHeight: 12,
                      backgroundColor: AppColors.border,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    t.isCompound ? 'Gandengkan 2 huruf ini!' : 'Tulis huruf ini',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: t.isCompound ? _compoundBody(t) : _singleBody(t),
                    ),
                  ),
                  const Text('Tulis di kertas, lalu foto',
                      style: TextStyle(color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Coba',
                    icon: Icons.camera_alt_rounded,
                    onPressed: _busy ? null : _attempt,
                  ),
                ],
              ),
            ),
          ),
          if (_busy)
            Container(
              color: Colors.black45,
              alignment: Alignment.center,
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Sedang menilai tulisanmu...'),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _singleBody(WritingTarget t) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gold, width: 2),
      ),
      child: Column(
        children: [
          ArabicText(t.arabic, size: 110, color: AppColors.tealDark),
          Text(t.latin,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange)),
        ],
      ),
    );
  }

  Widget _compoundBody(WritingTarget t) {
    Widget letterCard(String l) => Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gold, width: 2),
            ),
            child: ArabicText(l, size: 64, color: AppColors.tealDark),
          ),
        );

    return Column(
      children: [
        Row(
          children: [
            letterCard(t.parts[0]),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('+',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
            ),
            letterCard(t.parts[1]),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.mint,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text('Hasilnya',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              ArabicText(t.arabic, size: 56, color: AppColors.tealDark),
              Text(t.latin,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange)),
            ],
          ),
        ),
      ],
    );
  }
}
