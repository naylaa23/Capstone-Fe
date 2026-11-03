import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_text_field.dart';

/// Pemulihan kata sandi. Saat ini masih simulasi (belum ada server email).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lupa kata sandi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Masukkan email orang tua. Kami akan mengirim petunjuk untuk membuat kata sandi baru.',
                  style: TextStyle(color: AppColors.textMuted),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Email orang tua',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  textInputAction: TextInputAction.done,
                  validator: Validators.email,
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Kirim petunjuk', onPressed: _send),
                if (_sent)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      'Petunjuk pemulihan dikirim ke ${_email.text.trim()} (simulasi).',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.success),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
