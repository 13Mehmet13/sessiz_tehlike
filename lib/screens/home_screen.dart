import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sessiz_tehlike/widgets/app_card.dart';
import 'package:sessiz_tehlike/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessiz Tehlike'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF4FC3F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x261565C0),
                      blurRadius: 28,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                child: Semantics(
                  label: 'Sessiz Tehlike giriş kartı',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Offline kritik ses algılama',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Kritik sesleri\ntitreşimle fark et',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Kapı zili, alarm ve korna gibi dikkat gerektiren sesleri canlı olarak algılar; titreşim, bildirim ve görsel uyarı ile destekler.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Canlı Ses Algılamayı Başlat',
                        icon: Icons.mic_rounded,
                        foregroundColor: const Color(0xFF1565C0),
                        backgroundColor: Colors.white,
                        semanticsLabel:
                            'Canlı ses algılamayı başlat ekranına git',
                        onPressed: () async => context.goNamed('live'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppCard(
                title: 'Geçmiş',
                subtitle: 'Algılanan kritik ses kayıtlarını görüntüle.',
                icon: Icons.history_rounded,
                accentColor: const Color(0xFF1565C0),
                onTap: () => context.goNamed('history'),
              ),
              const SizedBox(height: 16),
              AppCard(
                title: 'Ayarlar',
                subtitle: 'Hassasiyet düzeyini ve erişilebilirlik notlarını yönet.',
                icon: Icons.tune_rounded,
                accentColor: const Color(0xFFFF7043),
                onTap: () => context.goNamed('settings'),
              ),
              const SizedBox(height: 16),
              AppCard(
                title: 'Proje Hakkında',
                subtitle: 'Problem tanımı, çözüm yaklaşımı ve gizlilik ilkeleri.',
                icon: Icons.info_outline_rounded,
                accentColor: const Color(0xFF26A69A),
                onTap: () => context.goNamed('about'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
