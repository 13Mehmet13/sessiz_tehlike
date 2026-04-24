import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sessiz_tehlike/providers/sound_provider.dart';
import 'package:sessiz_tehlike/widgets/app_card.dart';
import 'package:sessiz_tehlike/widgets/primary_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<SoundProvider>(
      builder: (context, provider, _) {
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
                            child: Text(
                              provider.isListening
                                  ? provider.monitoringLabel
                                  : 'Offline kritik ses algılama',
                              style: const TextStyle(
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
                            provider.isListening
                                ? 'Algılama şu anda aktif. Ekranlar arasında dolaşsan bile uygulama açık kaldığı sürece ses seviyesi izlenmeye devam eder.'
                                : 'Kapı zili, alarm ve korna gibi dikkat gerektiren sesleri canlı olarak algılar; titreşim, bildirim ve görsel uyarı ile destekler.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(
                            label: provider.isListening
                                ? 'Canlı Algılamaya Dön'
                                : 'Canlı Ses Algılamayı Başlat',
                            icon: provider.isListening
                                ? Icons.graphic_eq_rounded
                                : Icons.mic_rounded,
                            foregroundColor: const Color(0xFF1565C0),
                            backgroundColor: Colors.white,
                            semanticsLabel: 'Canlı ses algılama ekranına git',
                            onPressed: () async => context.pushNamed('live'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.isListening) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 18,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${provider.monitoringLabel} • Anlık değer ${provider.currentDb.toStringAsFixed(1)} dB',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  AppCard(
                    title: 'Geçmiş',
                    subtitle: 'Algılanan kritik ses kayıtlarını görüntüle.',
                    icon: Icons.history_rounded,
                    accentColor: const Color(0xFF1565C0),
                    onTap: () => context.pushNamed('history'),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    title: 'Ayarlar',
                    subtitle:
                        'Hassasiyet düzeyini ve sürekli algılama modunu yönet.',
                    icon: Icons.tune_rounded,
                    accentColor: const Color(0xFFFF7043),
                    onTap: () => context.pushNamed('settings'),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    title: 'Proje Hakkında',
                    subtitle:
                        'Problem tanımı, çözüm yaklaşımı ve gizlilik ilkeleri.',
                    icon: Icons.info_outline_rounded,
                    accentColor: const Color(0xFF26A69A),
                    onTap: () => context.pushNamed('about'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
