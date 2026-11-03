import 'package:flutter/material.dart';
import 'screens/auth/verification_screen.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

class QalamkuApp extends StatelessWidget {
  const QalamkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qalamku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const VerificationScreen(email: 'ibu.aisyah@gmail.com'),
    );
  }
}
