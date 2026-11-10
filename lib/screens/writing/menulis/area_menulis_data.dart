import 'package:flutter/material.dart';

const Color _kuning = Color(0xFFFFD43B);
const Color _pink = Color(0xFFFFB3D1);
const Color _biru = Color(0xFF6BB6FF);

/// Warna chip bergantian: kuning, pink, biru, lalu berulang.
const List<Color> _palet = [_kuning, _pink, _biru];

class HurufMenulis {
  final String arab;
  final String latin;
  final Color warna;
  final int titikAtas;
  final int titikBawah;

  const HurufMenulis(
    this.arab,
    this.latin,
    this.warna, {
    this.titikAtas = 0,
    this.titikBawah = 0,
  });
}

class _Entri {
  final String arab;
  final String latin;
  final int atas;
  final int bawah;

  const _Entri(this.arab, this.latin, {this.atas = 0, this.bawah = 0});
}

/// Urutan huruf di layar. Untuk menambah atau mengubah huruf, edit daftar ini.
const List<_Entri> _entri = [
  _Entri('ب', 'ba', bawah: 1),
  _Entri('ت', 'ta', atas: 2),
  _Entri('ث', 'tsa', atas: 3),
  _Entri('ج', 'ja', bawah: 1),
  _Entri('ح', 'ha'),
  _Entri('خ', 'kha', atas: 1),
  _Entri('د', 'da'),
  _Entri('ذ', 'dza', atas: 1),
  _Entri('ر', 'ra'),
  _Entri('ز', 'za', atas: 1),
  _Entri('س', 'sa'),
  _Entri('ش', 'sya', atas: 3),
  _Entri('ص', 'sha'),
  _Entri('ض', 'dha', atas: 1),
  _Entri('ط', 'tha'),
  _Entri('ظ', 'zha', atas: 1),
  _Entri('ع', "'a"),
  _Entri('غ', 'gha', atas: 1),
  _Entri('ف', 'fa', atas: 1),
  _Entri('ق', 'qa', atas: 2),
  _Entri('ك', 'ka'),
  _Entri('ل', 'la'),
  _Entri('م', 'ma'),
  _Entri('ن', 'na', atas: 1),
  _Entri('ه', 'ha'),
  _Entri('و', 'wa'),
  _Entri('ي', 'ya', bawah: 2),
];

final List<HurufMenulis> daftarHurufMenulis = [
  for (int i = 0; i < _entri.length; i++)
    HurufMenulis(
      _entri[i].arab,
      _entri[i].latin,
      _palet[i % _palet.length],
      titikAtas: _entri[i].atas,
      titikBawah: _entri[i].bawah,
    ),
];