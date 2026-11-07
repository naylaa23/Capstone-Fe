import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);
  static const _red = Color(0xFFE53935);

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  bool _hidePass = true;
  bool _hideConfirm = true;

  String? _nameError;
  String? _emailError;
  String? _passError;
  String? _confirmError;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    super.dispose();
  }

  bool _isValidEmail(String e) {
    return RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(e);
  }

  void _register() {
    final nama = _nameC.text.trim();
    final email = _emailC.text.trim();
    final pass = _passC.text;
    final confirm = _confirmC.text;

    String? nameErr;
    String? emailErr;
    String? passErr;
    String? confirmErr;

    if (nama.isEmpty) nameErr = 'Nama panggilan wajib diisi.';

    if (email.isEmpty) {
      emailErr = 'Email orang tua wajib diisi.';
    } else if (!_isValidEmail(email)) {
      emailErr = 'Format email belum benar. Contoh: nama@email.com.';
    }

    if (pass.isEmpty) {
      passErr = 'Kata sandi wajib diisi.';
    } else if (pass.length < 8) {
      passErr = 'Kata sandi minimal 8 karakter.';
    }

    if (confirm != pass) {
      confirmErr = 'Kata sandi belum sama. Coba lagi ya.';
    }

    setState(() {
      _nameError = nameErr;
      _emailError = emailErr;
      _passError = passErr;
      _confirmError = confirmErr;
    });

    if (nameErr != null ||
        emailErr != null ||
        passErr != null ||
        confirmErr != null) {
      return;
    }

    // TODO: panggil AuthProvider untuk mendaftar kalau sudah ada backend.

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerificationScreen(email: email, nama: nama),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final headerH = w * 0.85;
    const overlap = 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Header (sama seperti layar login)
            Image.asset(
              'assets/images/login1.png',
              width: double.infinity,
              height: headerH,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: headerH,
                color: const Color(0xFFBFE3F5),
              ),
            ),
            Image.asset(
              'assets/images/login2.png',
              width: double.infinity,
              height: headerH,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: headerH,
                color: const Color(0xFFBFE3F5),
              ),
            ),

            // Kartu form
            Padding(
              padding: EdgeInsets.only(
                  top: headerH - overlap, left: 12, right: 12, bottom: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tabs(),
                    const SizedBox(height: 16),

                    // Nama panggilan anak
                    _label('Nama panggilan anak'),
                    const SizedBox(height: 6),
                    _field(
                      _nameC,
                      'Masukkan nama panggilan',
                      error: _nameError != null,
                      onChanged: (_) {
                        if (_nameError != null) {
                          setState(() => _nameError = null);
                        }
                      },
                    ),
                    if (_nameError != null) _errorText(_nameError!),
                    const SizedBox(height: 12),

                    // Email orang tua
                    _label('Email orang tua'),
                    const SizedBox(height: 6),
                    _field(
                      _emailC,
                      'nama@email.com',
                      keyboard: TextInputType.emailAddress,
                      error: _emailError != null,
                      onChanged: (_) {
                        if (_emailError != null) {
                          setState(() => _emailError = null);
                        }
                      },
                    ),
                    if (_emailError != null) _errorText(_emailError!),
                    const SizedBox(height: 12),

                    // Kata sandi
                    _label('Kata sandi'),
                    const SizedBox(height: 6),
                    _field(
                      _passC,
                      'Masukkan kata sandi',
                      obscure: _hidePass,
                      error: _passError != null,
                      onChanged: (_) {
                        if (_passError != null) {
                          setState(() => _passError = null);
                        }
                      },
                      suffix: _eye(
                        hide: _hidePass,
                        onTap: () => setState(() => _hidePass = !_hidePass),
                      ),
                    ),
                    if (_passError != null) _errorText(_passError!),
                    const SizedBox(height: 12),

                    // Ulangi kata sandi
                    _label('Ulangi kata sandi'),
                    const SizedBox(height: 6),
                    _field(
                      _confirmC,
                      'Ulangi kata sandi',
                      obscure: _hideConfirm,
                      error: _confirmError != null,
                      onChanged: (_) {
                        if (_confirmError != null) {
                          setState(() => _confirmError = null);
                        }
                      },
                      suffix: _eye(
                        hide: _hideConfirm,
                        onTap: () =>
                            setState(() => _hideConfirm = !_hideConfirm),
                      ),
                    ),
                    if (_confirmError != null) _errorText(_confirmError!),
                    const SizedBox(height: 16),

                    _registerButton(),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text('atau',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    const SizedBox(height: 10),
                    _googleButton(),
                  ],
                ),
              ),
            ),

            // Tombol kembali
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.maybePop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.chevron_left, size: 22),
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

  Widget _tabs() => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => const LoginScreen(),
                    transitionsBuilder: (_, anim, __, child) =>
                        FadeTransition(opacity: anim, child: child),
                    transitionDuration: const Duration(milliseconds: 250),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: const Text('Masuk',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), blurRadius: 4),
                  ],
                ),
                child: const Text('Daftar',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      );

  Widget _label(String t) => Text(t,
      style: const TextStyle(fontSize: 13, color: Color(0xFF374151)));

  Widget _errorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error, size: 14, color: _red),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              msg,
              style: const TextStyle(fontSize: 11, color: _red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eye({required bool hide, required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(
        hide ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        size: 18,
        color: Colors.grey,
      ),
      onPressed: onTap,
    );
  }

  Widget _field(
    TextEditingController c,
    String hint, {
    bool obscure = false,
    bool error = false,
    Widget? suffix,
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: c,
      obscureText: obscure,
      keyboardType: keyboard,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        suffixIcon: suffix,
        isDense: true,
        filled: error,
        fillColor: error ? const Color(0xFFFEF2F2) : null,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error ? _red : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: error ? _red : _green,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_greenLight, _green]),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color(0x4022C55E), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _register,
          child: const Center(
            child: Text('Daftar',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo google.webp',
              width: 20,
              height: 20,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.g_mobiledata, size: 24),
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text('Lanjutkan dengan Google',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}