import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/iqro_data.dart';
import '../../providers/progress_provider.dart';
import '../../services/tts_service.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/arabic_text.dart';

/// Halaman baca Iqro: contoh huruf, kotak huruf yang bisa diketuk (bersuara),
/// serta tombol Sebelumnya / Dengar / Berikutnya / Tandai selesai.
class IqroReaderScreen extends StatefulWidget {
  final int jilid;
  final int initialPage;

  const IqroReaderScreen({
    super.key,
    required this.jilid,
    required this.initialPage,
  });

  @override
  State<IqroReaderScreen> createState() => _IqroReaderScreenState();
}

class _IqroReaderScreenState extends State<IqroReaderScreen> {
  late int _page = widget.initialPage;
  int _selected = -1; // -1 = contoh di atas yang tersorot

  IqroJilid get _jilid => IqroData.jilid(widget.jilid);
  IqroPage get _data => IqroData.page(widget.jilid, _page);

  /// Teks bar "Suara" selalu mengikuti kartu yang tersorot.
  String get _soundLabel =>
      _selected < 0 ? _data.exampleLatin : _data.cells[_selected].latin;

  String get _soundArabic =>
      _selected < 0 ? _data.exampleArabic : _data.cells[_selected].arabic;

  void _select(int i) {
    setState(() => _selected = i);
    TtsService.instance.speak(_data.cells[i].arabic);
  }

  void _listen() => TtsService.instance.speak(_soundArabic);

  void _goTo(int page) {
    setState(() {
      _page = page;
      _selected = -1;
    });
  }

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  Future<void> _markDone() async {
    final messenger = ScaffoldMessenger.of(context);
    await context.read<ProgressProvider>().markIqroDone(widget.jilid, _page);
    messenger.showSnackBar(SnackBar(
        content: Text('Halaman $_page ditandai selesai. Progres tersimpan.')));
  }

  @override
  Widget build(BuildContext context) {
    final done =
        context.watch<ProgressProvider>().isIqroPageDone(widget.jilid, _page);
    final data = _data;
    final isJilid2 = widget.jilid == 2;

    return Scaffold(
      appBar: AppBar(title: Text('Jilid ${widget.jilid} · Halaman $_page')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Bar suara
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_up_rounded,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text('Suara: $_soundLabel',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Ketuk huruf untuk mendengar suaranya',
                        style: TextStyle(color: AppColors.textMuted)),
                    const SizedBox(height: 12),
                    if (isJilid2 && data.rule != null) ...[
                      Text(data.rule!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.tealDark)),
                      const SizedBox(height: 8),
                    ],
                    // Contoh huruf di bagian atas
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),
                      child: Column(
                        children: [
                          ArabicText(
                            isJilid2
                                ? (data.exampleFormula ?? data.exampleArabic)
                                : data.exampleArabic,
                            size: isJilid2 ? 36 : 64,
                            color: AppColors.tealDark,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    isJilid2 ? _joinedGrid(data) : _letterGrid(data),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlineButtonX(
                          label: 'Sebelumnya',
                          onPressed: _page > 1 ? () => _goTo(_page - 1) : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Dengar',
                          icon: Icons.volume_up_rounded,
                          onPressed: _listen,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlineButtonX(
                          label: 'Berikutnya',
                          onPressed: _page < _jilid.totalPages
                              ? () => _goTo(_page + 1)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: done ? 'Sudah selesai ✓' : 'Tandai selesai',
                    color: AppColors.success,
                    onPressed: _markDone,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Jilid 1: kotak huruf berfathah (6 kolom x 3 baris).
  Widget _letterGrid(IqroPage data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: data.cells.length,
      itemBuilder: (_, i) {
        final sel = i == _selected;
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _select(i),
          child: Container(
            decoration: BoxDecoration(
              color: sel ? AppColors.orange.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: sel ? AppColors.orange : AppColors.border, width: 2),
            ),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: ArabicText(data.cells[i].arabic, size: 30),
            ),
          ),
        );
      },
    );
  }

  /// Jilid 2: kartu huruf sambung + tulisan latinnya.
  Widget _joinedGrid(IqroPage data) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemCount: data.cells.length,
      itemBuilder: (_, i) {
        final sel = i == _selected;
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _select(i),
          child: Container(
            decoration: BoxDecoration(
              color: sel ? AppColors.orange.withOpacity(0.2) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: sel ? AppColors.orange : AppColors.border, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: ArabicText(data.cells[i].arabic, size: 34),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(data.cells[i].latin,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textMuted)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
