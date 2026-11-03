import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:qalamku/app.dart';
import 'package:qalamku/providers/auth_provider.dart';
import 'package:qalamku/providers/progress_provider.dart';

void main() {
  testWidgets('App berhasil dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ],
        child: const QalamkuApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}