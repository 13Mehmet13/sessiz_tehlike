import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sessiz_tehlike/providers/sound_provider.dart';
import 'package:sessiz_tehlike/screens/home_screen.dart';

void main() {
  testWidgets('Home screen shows core entry points', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => SoundProvider(),
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.text('Sessiz Tehlike'), findsOneWidget);
    expect(find.text('Canlı Ses Algılamayı Başlat'), findsOneWidget);
    expect(find.text('Geçmiş'), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
  });
}
