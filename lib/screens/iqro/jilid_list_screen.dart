import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/iqro_data.dart';
import '../../providers/progress_provider.dart';
import 'jilid_detail_screen.dart';

/// Halaman "Pilih jilid": 6 kartu, hanya Jilid 1 dan 2 yang aktif.
class JilidListScreen extends StatelessWidget {
  const JilidListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih jilid')),
      body: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.95,
        children: IqroData.jilidList.map((j) {
          String status;
          if (!j.active) {
            status = 'Segera hadir';
          } else if (progress.iqroDoneCount(j.number) == 0 && j.number == 2) {
            status = 'Belum mulai';
          } else {
            status = 'Mulai dari halaman ${progress.iqroNextPage(j.number)}';
          }

          return _JilidCard(
            jilid: j,
            status: status,
            onTap: () {
              if (!j.active) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Jilid ${j.number} segera hadir.')));
                return;
              }
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => JilidDetailScreen(jilid: j.number)));
            },
          );
        }).toList(),
      ),
    );
  }
}

class _JilidCard extends StatelessWidget {
  final IqroJilid jilid;
  final String status;
  final VoidCallback onTap;

  const _JilidCard(
      {required this.jilid, required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = jilid.active;
    final colors = [
      AppColors.sky,
      AppColors.pink,
      AppColors.mint,
      AppColors.cream,
      AppColors.tealLight,
      AppColors.peach,
    ];
    return Opacity(
      opacity: active ? 1 : 0.5,
      child: Material(
        color: active ? colors[jilid.number - 1] : AppColors.border,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                active
                    ? Text('${jilid.number}',
                        style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            color: AppColors.tealDark))
                    : const Icon(Icons.lock_outline,
                        size: 44, color: AppColors.textMuted),
                const SizedBox(height: 6),
                Text('Jilid ${jilid.number}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                if (active)
                  Text(jilid.subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: active
                            ? AppColors.textDark
                            : AppColors.textMuted,
                        fontWeight:
                            active ? FontWeight.w400 : FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
