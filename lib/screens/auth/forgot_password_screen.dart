import 'package:flutter/material.dart';

import 'verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);
  static const _navy = Color(0xFF2A1B6B);

  final _emailC = TextEditingController();

  // Tombol aktif kalau email terisi dan berformat benar
  bool get _valid {
    final e = _emailC.text.trim();
    return e.contains('@') && e.contains('.');
  }

  @override
  void dispose() {
    _emailC.dispose();
    super.dispose();
  }

  void _reset() {
    final email = _emailC.text.trim();

    //  kirim permintaan reset ke server kalau sudah ada backend.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode reset telah dikirim ke emailmu')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationScreen(email: email, resetSandi: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 24),

              // Judul
              const Text(
                'Lupa sandi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Masukkan email kamu dulu yuk biar reset sandinya.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),

              // Ilustrasi
              Center(
                child: Image.asset(
                  'assets/images/lupa sandi kosong.png',
                  height: 190,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 190,
                    child: Icon(Icons.help_outline,
                        size: 90, color: Color(0xFF14877A)),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Input email
              const Text(
                'Email kamu',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailC,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 14),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Tulis emailmu',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _green, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Tombol reset
              Opacity(
                opacity: _valid ? 1 : 0.4,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(colors: [_greenLight, _green]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _valid
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
                      onTap: _valid ? _reset : null,
                      child: const Center(
                        child: Text(
                          'Reset sandi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}