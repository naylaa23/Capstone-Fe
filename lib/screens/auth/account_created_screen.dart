  import 'package:flutter/material.dart';

  import '../dashboard/dashboard_screen.dart';

  class AccountCreatedScreen extends StatelessWidget {
    final String nama;

    const AccountCreatedScreen({
      super.key,
      required this.nama,
    });

    static const Color _background = Color(0xFFFFF3D6);
    static const Color _green = Color(0xFF1FA64A);
    static const Color _purple = Color(0xFF6C3FD6);
    static const Color _textDark = Color(0xFF2B2B2B);

    void _mulaiBelajar(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo
                Image.asset(
                  'assets/images/logo_qalamku.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),

                // Judul
                const Text(
                  'Akun sudah jadi!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: _green,
                  ),
                ),
                const SizedBox(height: 16),

                // Sambutan
                Text(
                  'Selamat datang, $nama.\nAyo mulai membaca dan menulis.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 28),

                // Pengingat kata sandi
                const Text(
                  'Ingat kata sandimu yo. Simpan bersama ibu atau ayah.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: _textDark),
                ),

                const Spacer(flex: 3),

                // Tombol
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _mulaiBelajar(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _purple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Mulai belajar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    }
  }