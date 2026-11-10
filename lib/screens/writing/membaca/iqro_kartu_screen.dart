import 'package:flutter/material.dart';

import 'iqro_halaman_screen.dart';

/// Kartu berbingkai ungu: instruksi, contoh, dan kotak bacaan.
/// [data] = null berarti isi halaman belum tersedia.
class IqroKartu extends StatelessWidget {
  final IqroHalaman? data;

  const IqroKartu({super.key, required this.data});

  static const Color _navy = Color(0xFF2A1B6B);
  static const Color _purple = Color(0xFF6C3FD6);

  @override
  Widget build(BuildContext context) {
    final d = data;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _purple, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: d == null ? _kosong() : _isi(d),
      ),
    );
  }

  Widget _kosong() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Isi halaman ini belum tersedia',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
      ),
    );
  }

  Widget _isi(IqroHalaman d) {
    // Instruksi dan legend hanya digambar kalau ada isinya
    final adaInstruksi = d.instruksi.trim().isNotEmpty;
    final adaLegend = d.legend.isNotEmpty;

    return Column(
      children: [
        // Instruksi
        if (adaInstruksi) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Text(
              d.instruksi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.35,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1.5, color: _purple),
        ],

        // Baris contoh
        if (adaLegend) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final t in d.legend)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 34,
                        height: 1.3,
                        color: _navy,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1.5, color: _purple),
        ],

        // Kotak bacaan
        Expanded(
          child: Column(
            children: [
              for (int r = 0; r < d.baris.length; r++)
                Expanded(
                  child: _baris(
                    d.baris[r],
                    garisBawah: d.tampilkanGaris && r < d.baris.length - 1,
                    // Garis tengah tidak dipakai di baris judul
                    pakaiPembagi:
                        d.tampilkanGaris && !(d.adaJudul && r == 0),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Satu baris bacaan. RTL: sel pertama ada di paling kanan.
  Widget _baris(
    List<String> sel, {
    required bool garisBawah,
    required bool pakaiPembagi,
  }) {
    final setengah = sel.length ~/ 2;

    return Container(
      decoration: BoxDecoration(
        border: garisBawah
            ? Border(
                bottom: BorderSide(
                  color: _purple.withOpacity(0.55),
                  width: 1,
                ),
              )
            : null,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int i = 0; i < sel.length; i++) ...[
              if (pakaiPembagi && i == setengah)
                Container(width: 2, color: _purple),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      sel[i],
                      style: const TextStyle(
                        fontSize: 32,
                        height: 1.3,
                        color: _navy,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}