import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sessiz_tehlike/providers/sound_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Geri',
            ),
            title: const Text('Ayarlar'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _SettingsSection(
                title: 'Algılama modu',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: provider.continuousMonitoring,
                      onChanged: provider.setContinuousMonitoring,
                      title: const Text('Sürekli algılama açık'),
                      subtitle: const Text(
                        'Uygulama içinde ekran değiştirsen bile dinleme aktif kalsın.',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.monitoringLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SettingsSection(
                title: 'Ses hassasiyeti',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${provider.threshold.toStringAsFixed(0)} dB',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Düşük eşik daha küçük seslerde uyarı üretir. Yüksek eşik yalnızca daha güçlü seslerde alarm verir.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      min: 45,
                      max: 100,
                      divisions: 11,
                      value: provider.threshold,
                      onChanged: provider.updateThreshold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const _SettingsSection(
                title: 'Erişilebilirlik',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoLine('Minimum 48dp dokunma alanı ile rahat kullanım'),
                    _InfoLine('Yüksek kontrastlı renk geçişleri ile görsel alarm'),
                    _InfoLine('Bildirim ve titreşim ile çoklu uyarı yaklaşımı'),
                    _InfoLine('Basit bilgi mimarisi ve sade navigasyon'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const _SettingsSection(
                title: 'Gizlilik notu',
                child: Text(
                  'Uygulama ses kaydı saklamaz. Yalnızca dB değeri, algılanan ses türü ve zaman damgası cihaz içinde tutulur.',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4, right: 10),
            child: Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: Color(0xFF1565C0),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
