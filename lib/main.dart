import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';
import 'providers/progress_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat sesi login & progres lebih dulu supaya splash tahu harus ke mana.
  final auth = AuthProvider();
  final progress = ProgressProvider();
  await auth.load();
  if (auth.currentUser != null) {
    await progress.load(auth.currentUser!.email);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ChangeNotifierProvider<ProgressProvider>.value(value: progress),
      ],
      child: const QalamkuApp(),
    ),
  );
}