import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static const _green = Color(0xFF22C55E);
  static const _greenLight = Color(0xFF4ADE80);

  final _controllers = List.generate(4, (_) => TextEditingController());
  final _nodes = List.generate(4, (_) => FocusNode());

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
    setState(() {});
  }

  void _verify() {
    // TODO: cek kode _code ke AuthProvider / server, lalu pindah layar
  }

  void _resend() {
    // TODO: kirim ulang kode
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kode baru telah dikirim')),
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
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F3F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, size: 22),
                ),
              ),
              const SizedBox(height: 28),
              const Text('Periksa emailmu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
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
                    const TextSpan(
                        text: '.\nMasukkan 4 digit kode untuk membuat sandi baru.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, _box),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _green, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _verifyButton() {
    return Opacity(
      opacity: _complete ? 1 : 0.5,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [_greenLight, _green]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
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