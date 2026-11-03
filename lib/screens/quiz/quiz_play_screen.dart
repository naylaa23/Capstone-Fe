import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/quiz_bank.dart';
import '../../models/quiz_question.dart';
import '../../providers/progress_provider.dart';
import '../../services/tts_service.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/arabic_text.dart';
import '../../widgets/mascot.dart';
import 'quiz_result_screen.dart';

/// Mengerjakan satu level kuis (5 soal): pilih huruf, dengarkan lalu pilih,
/// dan cocokkan huruf dengan bunyinya.
class QuizPlayScreen extends StatefulWidget {
  final int level;
  const QuizPlayScreen({super.key, required this.level});

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  late final List<QuizQuestion> _questions =
      QuizBank.questionsFor(widget.level);
  int _index = 0;
  int _correct = 0;
  bool _answered = false;
  bool _lastCorrect = false;

  QuizQuestion get _q => _questions[_index];

  void _onAnswered(bool correct) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _lastCorrect = correct;
      if (correct) _correct++;
    });
  }

  Future<void> _next() async {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _answered = false;
      });
      return;
    }
    // Soal terakhir selesai: hitung bintang, simpan, tampilkan hasil.
    final stars = QuizBank.starsFor(_correct, _questions.length);
    final passed = QuizBank.passed(_correct);
    final progress = context.read<ProgressProvider>();
    final nav = Navigator.of(context);
    if (passed) await progress.completeQuiz(widget.level, stars);
    if (!mounted) return;
    nav.pushReplacement(MaterialPageRoute(
      builder: (_) => QuizResultScreen(
        level: widget.level,
        correct: _correct,
        total: _questions.length,
        stars: stars,
        passed: passed,
      ),
    ));
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari kuis?'),
        content: const Text('Jawabanmu di level ini belum tersimpan.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Lanjut main')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Keluar')),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: _confirmExit),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Level ${widget.level}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16)),
                          Text(
                              'Soal ${_index + 1} dari ${_questions.length}',
                              style: const TextStyle(
                                  color: AppColors.textMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (_index + (_answered ? 1 : 0)) / _questions.length,
                    minHeight: 12,
                    backgroundColor: AppColors.border,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: _QuestionView(
                      key: ValueKey('q$_index'),
                      question: _q,
                      onAnswered: _onAnswered,
                    ),
                  ),
                ),
                if (_answered)
                  _FeedbackCard(
                    correct: _lastCorrect,
                    correctLabel: _q.correctLabel,
                    isLast: _index == _questions.length - 1,
                    onNext: _next,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _FeedbackCard extends StatelessWidget {
  final bool correct;
  final String correctLabel;
  final bool isLast;
  final VoidCallback onNext;

  const _FeedbackCard({
    required this.correct,
    required this.correctLabel,
    required this.isLast,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: correct ? AppColors.mint : AppColors.cream,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: correct ? AppColors.success : AppColors.orange, width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Mascot(size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // U+2011 = tanda hubung tanpa pemisah baris, supaya
                      // "apa-apa" tidak terpotong di tengah kata.
                      correct
                          ? 'Hebat, jawabanmu benar!'
                          : 'Belum tepat, tidak apa\u2011apa!',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    if (!correct)
                      Text('Jawaban benar: $correctLabel',
                          style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
              label: isLast ? 'Lihat hasil' : 'Lanjut', onPressed: onNext),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _QuestionView extends StatefulWidget {
  final QuizQuestion question;
  final ValueChanged<bool> onAnswered;

  const _QuestionView({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  State<_QuestionView> createState() => _QuestionViewState();
}

class _QuestionViewState extends State<_QuestionView> {
  // pilihan ganda
  int? _selected;

  // mencocokkan
  late final List<int> _rightOrder; // urutan kolom bunyi (diacak)
  int? _pendingLeft;
  final Map<int, int> _assign = {}; // indeks kiri -> indeks kanan (asli)
  bool _checked = false;

  static const _cardColors = [
    AppColors.yellow,
    AppColors.pink,
    AppColors.sky,
    AppColors.mint,
  ];

  QuizQuestion get q => widget.question;
  bool get _answered => _selected != null || _checked;

  @override
  void initState() {
    super.initState();
    final n = q.pairs.length;
    _rightOrder = List<int>.generate(n, (i) => i);
    if (q.type == QuizType.match && n > 1) {
      // Acak urutan kolom bunyi; pastikan TIDAK sama dengan urutan huruf.
      var seed = q.prompt.length + n;
      do {
        _rightOrder.shuffle(Random(seed++));
      } while (_isIdentity(_rightOrder));
    }
    if (q.type == QuizType.listenChoose) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _play());
    }
  }

  bool _isIdentity(List<int> l) {
    for (var i = 0; i < l.length; i++) {
      if (l[i] != i) return false;
    }
    return true;
  }

  void _play() {
    if (q.speakText != null) TtsService.instance.speak(q.speakText!);
  }

  void _choose(int i) {
    if (_answered) return;
    setState(() => _selected = i);
    widget.onAnswered(i == q.correctIndex);
  }

  void _tapLeft(int i) {
    if (_checked) return;
    setState(() {
      _assign.remove(i); // ketuk lagi = batalkan pasangan lama
      _pendingLeft = i;
    });
  }

  void _tapRight(int rightPos) {
    if (_checked || _pendingLeft == null) return;
    final original = _rightOrder[rightPos];
    setState(() {
      _assign.removeWhere((_, v) => v == original); // 1 bunyi = 1 huruf
      _assign[_pendingLeft!] = original;
      _pendingLeft = null;
    });
  }

  void _check() {
    final ok = _assign.entries.every((e) => e.key == e.value);
    setState(() => _checked = true);
    widget.onAnswered(ok);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(q.prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        if (q.type == QuizType.listenChoose) _listenButton(),
        if (q.type == QuizType.match) _matchBody() else _choices(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _listenButton() {
    return Column(
      children: [
        InkWell(
          onTap: _play,
          customBorder: const CircleBorder(),
          child: Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
                color: AppColors.orange, shape: BoxShape.circle),
            child: const Icon(Icons.volume_up_rounded,
                size: 48, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        const Text('Ketuk untuk mendengar lagi',
            style: TextStyle(color: AppColors.textMuted)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _choices() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemCount: q.options.length,
      itemBuilder: (_, i) {
        Color bg = _cardColors[i % _cardColors.length];
        Color border = Colors.transparent;
        double opacity = 1;
        if (_selected != null) {
          if (i == q.correctIndex) {
            bg = AppColors.success.withOpacity(0.35);
            border = AppColors.success;
          } else if (i == _selected) {
            bg = AppColors.error.withOpacity(0.35);
            border = AppColors.error;
          } else {
            opacity = 0.35; // pilihan lain memudar
          }
        }
        return Opacity(
          opacity: opacity,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => _choose(i),
            child: Container(
              // padding vertikal besar supaya tanda baris tetap di dalam kartu
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: border, width: 3),
              ),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ArabicText(q.options[i], size: 56),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _matchBody() {
    final n = q.pairs.length;
    return Column(
      children: [
        for (var row = 0; row < n; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(child: _leftTile(row)),
                const SizedBox(width: 16),
                Expanded(child: _rightTile(row)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: 'Periksa',
          onPressed: (!_checked && _assign.length == n) ? _check : null,
        ),
      ],
    );
  }

  Color? _pairColor(int leftIndex) {
    if (!_assign.containsKey(leftIndex)) return null;
    if (_checked) {
      return _assign[leftIndex] == leftIndex
          ? AppColors.success.withOpacity(0.35)
          : AppColors.error.withOpacity(0.35);
    }
    return _cardColors[leftIndex % _cardColors.length];
  }

  Widget _leftTile(int i) {
    final selected = _pendingLeft == i;
    final color = _pairColor(i) ?? Colors.white;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _tapLeft(i),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: selected ? AppColors.orange : AppColors.border,
              width: selected ? 3 : 1.5),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: ArabicText(q.pairs[i].letter, size: 40),
        ),
      ),
    );
  }

  Widget _rightTile(int pos) {
    final original = _rightOrder[pos];
    int? leftOwner;
    _assign.forEach((l, r) {
      if (r == original) leftOwner = l;
    });
    final color = leftOwner == null ? Colors.white : _pairColor(leftOwner!)!;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _tapRight(pos),
      child: Container(
        height: 84,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(q.pairs[original].sound,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
