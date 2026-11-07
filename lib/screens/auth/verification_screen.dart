import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'account_created_screen.dart';
import 'new_password_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  final String nama;
  final bool resetSandi;
  const VerificationScreen({
    super.key,
    required this.email,
    this.nama = '',
    this.resetSandi = false,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);
  static const _navy = Color(0xFF2A1B6B);
  static const _red = Color(0xFFE53935);

  // Kode benar untuk demo (ganti ke server kalau sudah ada backend)
  static const _kodeBenar = '3156';

  final _controllers = List.generate(4, (_) => TextEditingController());
  final _nodes = List.generate(4, (_) => FocusNode());
  bool _error = false;

  String get _code => _controllers.map((c) => c.text).join();
  bool get _complete => _code.length == 4;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int i, String v) {
    if (v.isNotEmpty && i < 3) _nodes[i + 1].requestFocus();
    if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
    if (_error) _error = false;
    setState(() {});
  }

  Future<void> _verify() async {
    // TODO: cek kode ke AuthProvider / server kalau sudah ada backend.
    if (_code != _kodeBenar) {
      setState(() => _error = true);
      return;
    }

    if (!mounted) return;

    // Alur lupa sandi -> buat sandi baru
    if (widget.resetSandi) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
      );
      return;
    }

    // Alur daftar -> akun sudah jadi
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => AccountCreatedScreen(
          nama: widget.nama.isEmpty ? 'Aisyah' : widget.nama,
        ),
      ),
      (route) => false,
    );
  }

  void _resend() {
    // kirim ulang kode
    for (final c in _controllers) {
      c.clear();
    }
    setState(() => _error = false);
    _nodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode baru telah dikirim')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petunjuk = widget.resetSandi
        ? '.\nMasukkan 4 digit kode untuk membuat sandi baru.'
        : '.\nMasukkan 4 digit kode untuk mengonfirmasi akunmu.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tombol kembali
              InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, size: 24),
                ),
              ),
              const SizedBox(height: 28),

              // Judul
              const Text(
                'Periksa emailmu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),

              // Petunjuk
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                      fontSize: 13, color: Colors.grey, height: 1.4),
                  children: [
                    const TextSpan(text: 'Kami telah mengirim kode ke '),
                    TextSpan(
                      text: widget.email,
                      style: const TextStyle(
                          color: Colors.black87, fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: petunjuk),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kotak kode
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, _box),
              ),

              // Pesan error
              if (_error)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error, size: 14, color: _red),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Kode salah. Cek email lagi atau kirim ulang kode.',
                          style: TextStyle(fontSize: 11, color: _red),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              _verifyButton(),
              const SizedBox(height: 16),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Belum menerima email? ',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    GestureDetector(
                      onTap: _resend,
                      child: const Text('Kirim ulang',
                          style: TextStyle(
                              color: _green,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(int i) {
    return SizedBox(
      width: 70,
      height: 56,
      child: TextField(
        controller: _controllers[i],
        focusNode: _nodes[i],
        autofocus: i == 0,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        onChanged: (v) => _onChanged(i, v),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          filled: _error,
          fillColor: _error ? const Color(0xFFFEF2F2) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: _error ? _red : const Color(0xFFE5E7EB),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: _error ? _red : _green,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _verifyButton() {
    return Opacity(
      opacity: _complete ? 1 : 0.4,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_greenLight, _green]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: _complete
              ? const [
                  BoxShadow(
                    color: Color(0x4022C55E),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _complete ? _verify : null,
            child: const Center(
              child: Text('Verifikasi kode',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }
}