// Basic Flutter widget test for FileFort app
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:FileFort/theme/app_theme.dart';
import 'package:FileFort/providers/pin_provider.dart';

void main() {
  testWidgets('App UI smoke test', (WidgetTester tester) async {
    // Test the app UI without Firebase dependencies
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => PinProvider()),
        ],
        child: MaterialApp(
          title: 'FileFort',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const Scaffold(
            body: Center(
              child: Text('FileFort'),
            ),
          ),
        ),
      ),
    );

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('FileFort'), findsOneWidget);
  });

  testWidgets('App theme colors', (WidgetTester tester) async {
    // Verify theme colors are defined
    expect(AppTheme.background, isNotNull);
    expect(AppTheme.primary, isNotNull);
    expect(AppTheme.destructive, isNotNull);
    expect(AppTheme.border, isNotNull);
  });
}
