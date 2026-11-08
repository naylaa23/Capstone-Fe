import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../dashboard/dashboard_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);
  static const _red = Color(0xFFE53935);

  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _hide = true;
  bool _remember = false;
  bool _loading = false;
  bool _emailError = false;
  bool _passError = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  bool _isValidEmail(String e) {
    return RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(e);
  }

  // --- INTEGRASI HTTP API NESTJS ---
  Future<void> _login() async {
    final email = _emailC.text.trim();
    final pass = _passC.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() => _emailError = true);
      return;
    }

    setState(() {
      _loading = true;
      _emailError = false;
      _passError = false;
    });

    // CATATAN HOST IP:
    // 1. Android Emulator    -> 'http://10.0.2.2:3000/api'
    // 2. HP Fisik (Samsung)  -> 'http://<IP_WIFI_LAPTOP>:3000/api' (Contoh: 'http://192.168.1.15:3000/api')
    const String baseUrl = 'http://192.168.1.13:3000/api';

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': pass,
        }),
      );

      if (!mounted) return;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() => _loading = false);

        // Ambil nama pengguna dan token dari respon backend NestJS
        final String userName = data['user']['fullName'] ?? 'Pengguna';
        // final String token = data['accessToken'] ?? '';

        // Pindah ke Dashboard dengan membawa nama pengguna dari database
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(nama: userName),
          ),
        );
      } else {
        // Sandi/Email salah atau belum verifikasi OTP
        setState(() {
          _loading = false;
          _passError = true;
        });

        final dynamic rawMsg = data['message'];
        final String errorMsg =
            rawMsg is List ? rawMsg.first : (rawMsg ?? 'Login gagal');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: _red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat terhubung ke server backend'),
          backgroundColor: _red,
        ),
      );
    }
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
            // Gambar header
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
              padding:
                  EdgeInsets.only(top: headerH - overlap, left: 12, right: 12),
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
                    _buildTabs(),
                    const SizedBox(height: 16),

                    // Email
                    _label('Email'),
                    const SizedBox(height: 6),
                    _field(
                      controller: _emailC,
                      hint: 'nama@email.com',
                      keyboard: TextInputType.emailAddress,
                      error: _emailError,
                      onChanged: (_) {
                        if (_emailError) setState(() => _emailError = false);
                      },
                    ),
                    if (_emailError)
                      _errorText(
                          'Format email belum benar. Contoh: nama@email.com.'),
                    const SizedBox(height: 12),

                    // Kata sandi
                    _label('Kata sandi'),
                    const SizedBox(height: 6),
                    _field(
                      controller: _passC,
                      hint: 'Masukkan kata sandi',
                      obscure: _hide,
                      error: _passError,
                      onChanged: (_) {
                        if (_passError) setState(() => _passError = false);
                      },
                      suffix: IconButton(
                        icon: Icon(
                          _hide
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => _hide = !_hide),
                      ),
                    ),
                    if (_passError)
                      _errorText('Kata sandi salah. Coba lagi ya.'),
                    const SizedBox(height: 10),

                    // Baris Checkbox & Lupa Sandi
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _remember,
                                  activeColor: _green,
                                  onChanged: (v) =>
                                      setState(() => _remember = v ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  'Ingat saya',
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          ),
                          child: const Text(
                            'Lupa sandi?',
                            style: TextStyle(
                              fontSize: 12,
                              color: _green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    _loginButton(),
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

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
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
              child: const Text('Masuk',
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const RegisterScreen(),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: const Duration(milliseconds: 250),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child:
                    const Text('Daftar', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String t) =>
      Text(t, style: const TextStyle(fontSize: 13, color: Color(0xFF374151)));

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

  Widget _field({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
    bool error = false,
    Widget? suffix,
    TextInputType? keyboard,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
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
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: error ? _red : const Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: error ? _red : _green,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_greenLight, _green]),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Color(0x4022C55E), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _loading ? null : _login,
          child: Center(
            child: _loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5, color: Colors.white),
                  )
                : const Text(
                    'Masuk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo google.webp',
                width: 20, height: 20),
            const SizedBox(width: 12),
            const Text('Lanjutkan dengan Google',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
