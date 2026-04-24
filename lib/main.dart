import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessiz_tehlike/providers/sound_provider.dart';
import 'package:sessiz_tehlike/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SessizTehlikeApp());
}

class SessizTehlikeApp extends StatelessWidget {
  const SessizTehlikeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SoundProvider()..initialize(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Sessiz Tehlike',
        theme: _buildTheme(),
        routerConfig: appRouter,
      ),
    );
  }

  ThemeData _buildTheme() {
    const background = Color(0xFFF6F7FB);
    const surface = Colors.white;
    const primary = Color(0xFF1565C0);
    const secondary = Color(0xFFFF7043);

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        surface: surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Segoe UI',
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF10233D),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        margin: EdgeInsets.zero,
      ),
      sliderTheme: base.sliderTheme.copyWith(
        activeTrackColor: primary,
        thumbColor: primary,
        inactiveTrackColor: const Color(0xFFD7DDEA),
        overlayColor: primary.withValues(alpha: 0.12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      textTheme: base.textTheme.copyWith(
        displaySmall: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Color(0xFF10233D),
          height: 1.1,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFF10233D),
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Color(0xFF10233D),
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFF4C607A),
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          height: 1.45,
          color: Color(0xFF5E738F),
        ),
      ),
    );
  }
}
