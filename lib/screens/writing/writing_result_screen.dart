import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Pilihan anak di layar hasil. Dikembalikan lewat Navigator.pop().
enum WritingResultAction { next, retry, example }

enum _Verdict { hebat, hampir, belumRapi, hurufBeda }

class WritingResultScreen extends StatefulWidget {
  /// Huruf yang diminta, mis. 'ث'
  final String target;

  /// Skor 0 - 100
  final int score;

  /// Huruf yang terbaca dari tulisan anak. Kalau diisi dan beda dari
  /// [target], tampil "Hurufnya belum sama".
  final String? detected;

  /// Petunjuk di kotak info (opsional)
  final String? tip;

  final bool showLoading;
  final Duration loadingDuration;

  const WritingResultScreen({
    super.key,
    required this.target,
    required this.score,
    this.detected,
    this.tip,
    this.showLoading = true,
    this.loadingDuration = const Duration(milliseconds: 2000),
  });

  @override
  State<WritingResultScreen> createState() => _WritingResultScreenState();
}

class _WritingResultScreenState extends State<WritingResultScreen> {
  static const Color _background = Color(0xFFFFF3D6);
  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);
  static const Color _yellow = Color(0xFFFFD43B);
  static const Color _blue = Color(0xFF2F80ED);
  static const Color _green = Color(0xFF1FA64A);
  static const Color _orange = Color(0xFFF57C00);
  static const Color _red = Color(0xFFE53950);

  /// Ganti dengan nama file gambar ikon "menilai" milikmu
  static const String _logoAsset = 'assets/images/logo menilai.png';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loading = widget.showLoading;
    if (_loading) {
      Future.delayed(widget.loadingDuration, () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  _Verdict get _verdict {
    final d = widget.detected;
    if (d != null && d != widget.target) return _Verdict.hurufBeda;
    if (widget.score >= 85) return _Verdict.hebat;
    if (widget.score >= 60) return _Verdict.hampir;
    return _Verdict.belumRapi;
  }

  int get _stars {
    switch (_verdict) {
      case _Verdict.hebat:
        return 3;
      case _Verdict.hampir:
        return 2;
      case _Verdict.belumRapi:
      case _Verdict.hurufBeda:
        return 1;
    }
  }

  void _pilih(WritingResultAction aksi) => Navigator.pop(context, aksi);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _loading
              ? KeyedSubtree(
                  key: const ValueKey('loading'),
                  child: _loadingView(),
                )
              : KeyedSubtree(
                  key: const ValueKey('result'),
                  child: _resultView(),
                ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------
  // Tampilan 1: sedang menilai
  // ---------------------------------------------------------------
  Widget _loadingView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFF8E7),
              border: Border.all(color: const Color(0xFF14877A), width: 6),
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  _logoAsset,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const _FallbackLogo(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sedang menilai tulisanmu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _navy,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tunggu sebentar ya..',
            style: TextStyle(fontSize: 13, color: _navy),
          ),
          const SizedBox(height: 14),
          const _DotsLoader(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------
  // Tampilan 2, 3, 4: hasil
  // ---------------------------------------------------------------
  Widget _resultView() {
    final look = _look;
    final tip = _tip;

    return LayoutBuilder(
      builder: (context, c) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: c.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    // Bintang
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Icon(
                            Icons.star_rounded,
                            size: 56,
                            color: i < _stars
                                ? const Color(0xFFFFB800)
                                : const Color(0xFFD9D9D9),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 14),

                    // Judul + keterangan
                    Text(
                      look.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: look.titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      look.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Kartu hasil
                    _verdict == _Verdict.hurufBeda
                        ? _compareCard(look.cardColor)
                        : _scoreCard(look),

                    // Kotak info
                    if (tip != null) ...[
                      const SizedBox(height: 12),
                      _tipBox(tip),
                    ],

                    const Spacer(),
                    const SizedBox(height: 24),

                    // Tombol
                    _button(
                      label: look.primary,
                      background: _purple,
                      foreground: Colors.white,
                      onTap: () => _pilih(look.primaryAction),
                    ),
                    const SizedBox(height: 12),
                    _button(
                      label: look.secondary,
                      background: _yellow,
                      foreground: _navy,
                      onTap: () => _pilih(look.secondaryAction),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _Look get _look {
    switch (_verdict) {
      case _Verdict.hebat:
        return const _Look(
          title: 'Hebat sekali!',
          subtitle: 'Tulisanmu sudah mirip dengan huruf yang diminta.',
          titleColor: _green,
          cardColor: Color(0xFFD8F5E1),
          scoreColor: _green,
          labelColor: _navy,
          primary: 'Level berikutnya',
          primaryAction: WritingResultAction.next,
          secondary: 'Coba lagi',
          secondaryAction: WritingResultAction.retry,
        );
      case _Verdict.hampir:
        return const _Look(
          title: 'Hampir benar!',
          subtitle: 'Tulisanmu hampir mirip dengan huruf yang diminta.',
          titleColor: _orange,
          cardColor: Color(0xFFFFE08A),
          scoreColor: _orange,
          labelColor: _navy,
          primary: 'Level berikutnya',
          primaryAction: WritingResultAction.next,
          secondary: 'Coba lagi',
          secondaryAction: WritingResultAction.retry,
        );
      case _Verdict.belumRapi:
        return const _Look(
          title: 'Belum rapi, ayo coba lagi!',
          subtitle: 'Tulisanmu belum mirip dengan huruf yang diminta.',
          titleColor: _red,
          cardColor: Color(0xFFFFD9E2),
          scoreColor: _blue,
          labelColor: _blue,
          primary: 'Coba lagi',
          primaryAction: WritingResultAction.retry,
          secondary: 'Lihat contoh huruf',
          secondaryAction: WritingResultAction.example,
        );
      case _Verdict.hurufBeda:
        return const _Look(
          title: 'Hurufnya belum sama',
          subtitle: 'Tulisanmu terbaca sebagai huruf lain.',
          titleColor: _red,
          cardColor: Color(0xFFFFD9E2),
          scoreColor: _blue,
          labelColor: _blue,
          primary: 'Coba lagi',
          primaryAction: WritingResultAction.retry,
          secondary: 'Lihat contoh huruf',
          secondaryAction: WritingResultAction.example,
        );
    }
  }

  String? get _tip {
    switch (_verdict) {
      case _Verdict.belumRapi:
        return widget.tip ??
            'Lihat contoh dulu, lalu ikuti angka dari 1 sampai ujung.';
      case _Verdict.hurufBeda:
        return widget.tip;
      case _Verdict.hebat:
      case _Verdict.hampir:
        return null;
    }
  }

  Widget _scoreCard(_Look look) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: look.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.target,
            style: const TextStyle(fontSize: 76, height: 1.3, color: _navy),
          ),
          const SizedBox(width: 36),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skor',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: look.labelColor,
                ),
              ),
              Text(
                '${widget.score}%',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                  color: look.scoreColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _compareCard(Color color) {
    Widget kolom(String label, Color labelColor, String huruf) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: labelColor,
            ),
          ),
          Text(
            huruf,
            style: const TextStyle(fontSize: 64, height: 1.3, color: _navy),
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kolom('Tulisanmu', _blue, widget.detected ?? ''),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              '≠',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: _navy,
              ),
            ),
          ),
          kolom('Target', _green, widget.target),
        ],
      ),
    );
  }

  Widget _tipBox(String teks) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 11,
            backgroundColor: _blue,
            child: Text(
              'i',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              teks,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button({
    required String label,
    required Color background,
    required Color foreground,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

/// Isi teks dan warna untuk satu jenis hasil
class _Look {
  final String title;
  final String subtitle;
  final Color titleColor;
  final Color cardColor;
  final Color scoreColor;
  final Color labelColor;
  final String primary;
  final WritingResultAction primaryAction;
  final String secondary;
  final WritingResultAction secondaryAction;

  const _Look({
    required this.title,
    required this.subtitle,
    required this.titleColor,
    required this.cardColor,
    required this.scoreColor,
    required this.labelColor,
    required this.primary,
    required this.primaryAction,
    required this.secondary,
    required this.secondaryAction,
  });
}

/// Tiga titik loading (pink, kuning, hijau) yang berdenyut bergantian
class _DotsLoader extends StatefulWidget {
  const _DotsLoader();

  @override
  State<_DotsLoader> createState() => _DotsLoaderState();
}

class _DotsLoaderState extends State<_DotsLoader>
    with SingleTickerProviderStateMixin {
  static const List<Color> _colors = [
    Color(0xFFFF6B9A),
    Color(0xFFFFC93C),
    Color(0xFF4CD787),
  ];

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_c.value - i * 0.2) % 1.0;
            final scale = 0.7 + 0.5 * math.sin(t * math.pi);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _colors[i],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Dipakai kalau gambar logo "menilai" belum ada di assets
class _FallbackLogo extends StatelessWidget {
  const _FallbackLogo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF14877A), width: 3),
        ),
        child: const Text(
          'قلمكو',
          style: TextStyle(
            fontSize: 22,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFF9A4D),
          ),
        ),
      ),
    );
  }
}