import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/iqro_data.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/app_buttons.dart';
import 'iqro_reader_screen.dart';

/// "Iqro Jilid N": kartu jilid + pilihan halaman + tombol mulai.
class JilidDetailScreen extends StatefulWidget {
  final int jilid;
  const JilidDetailScreen({super.key, required this.jilid});

  @override
  State<JilidDetailScreen> createState() => _JilidDetailScreenState();
}

class _JilidDetailScreenState extends State<JilidDetailScreen> {
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final data = IqroData.jilid(widget.jilid);
    final selected = _selected ?? progress.iqroNextPage(widget.jilid);

    return Scaffold(
      appBar: AppBar(title: Text('Iqro Jilid ${widget.jilid}')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.gold),
                ),
                child: Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.tealDark),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Pilih halaman',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: data.totalPages,
                itemBuilder: (_, i) {
                  final page = i + 1;
                  final isSel = page == selected;
                  final done = progress.isIqroPageDone(widget.jilid, page);
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => setState(() => _selected = page),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSel
                            ? AppColors.orange
                            : (done ? AppColors.mint : Colors.white),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel ? AppColors.orange : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isSel ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                label: 'Mulai halaman $selected',
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => IqroReaderScreen(
                      jilid: widget.jilid, initialPage: selected),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
