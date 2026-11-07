import 'package:flutter/material.dart';

import 'login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);
  static const _navy = Color(0xFF2A1B6B);

  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  bool _hidePass = true;
  bool _hideConfirm = true;

  bool get _longEnough => _passC.text.length >= 8;
  bool get _match => _passC.text == _confirmC.text;
  bool get _valid => _longEnough && _confirmC.text.isNotEmpty && _match;

  @override
  void dispose() {
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    // TODO: kirim sandi baru ke server / AuthProvider kalau sudah ada backend.

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _ResetSuccessDialog(),
    );

    if (!mounted) return;

    // Setelah konfirmasi: kembali ke login, hapus layar-layar sebelumnya.
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showMismatch = _confirmC.text.isNotEmpty && !_match;

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
                'Buat sandi baru',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _navy,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pakai minimal 8 karakter ya.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Kata sandi baru
              _label('Kata sandi baru'),
              const SizedBox(height: 8),
              _field(
                controller: _passC,
                hide: _hidePass,
                onToggle: () => setState(() => _hidePass = !_hidePass),
              ),
              const SizedBox(height: 16),

              // Ulangi kata sandi baru
              _label('Ulangi kata sandi baru'),
              const SizedBox(height: 8),
              _field(
                controller: _confirmC,
                hide: _hideConfirm,
                onToggle: () => setState(() => _hideConfirm = !_hideConfirm),
              ),
              if (showMismatch) ...[
                const SizedBox(height: 6),
                const Text(
                  'Kata sandi belum sama.',
                  style: TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
              ],
              const SizedBox(height: 20),

              // Tombol simpan
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
                      onTap: _valid ? _simpan : null,
                      child: const Center(
                        child: Text(
                          'Simpan kata sandi',
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

  Widget _label(String t) => Text(
        t,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      );

  Widget _field({
    required TextEditingController controller,
    required bool hide,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: hide,
      style: const TextStyle(fontSize: 14),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        suffixIcon: IconButton(
          icon: Icon(
            hide ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 18,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
    );
  }
}

/// Dialog "Sandi berhasil direset"
class _ResetSuccessDialog extends StatelessWidget {
  const _ResetSuccessDialog();

  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);
  static const _navy = Color(0xFF2A1B6B);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sandi berhasil direset',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kata sandi kamu sudah diubah. Yuk, masuk lagi dengan sandi baru.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [_greenLight, _green]),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4022C55E),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () => Navigator.pop(context),
                  child: const Center(
                    child: Text(
                      'Konfirmasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}