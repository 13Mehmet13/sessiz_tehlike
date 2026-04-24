import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sessiz_tehlike/providers/sound_provider.dart';
import 'package:sessiz_tehlike/widgets/primary_button.dart';

class LiveDetectorScreen extends StatelessWidget {
  const LiveDetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SoundProvider>(
      builder: (context, provider, _) {
        final theme = Theme.of(context);
        final bandColor = switch (provider.band) {
          ColorBand.safe => const Color(0xFF2E7D32),
          ColorBand.warning => const Color(0xFFFF8F00),
          ColorBand.critical => const Color(0xFFC62828),
        };

        return Scaffold(
          appBar: AppBar(
            title: const Text('Canlı Algılama'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 24,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Semantics(
                          label:
                              'Anlık ses seviyesi ${provider.currentDb.toStringAsFixed(1)} desibel',
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  bandColor.withValues(alpha: 0.18),
                                  bandColor,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: bandColor.withValues(alpha: 0.22),
                                  blurRadius: 26,
                                  spreadRadius: 4,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    provider.currentDb.toStringAsFixed(1),
                                    style:
                                        theme.textTheme.displaySmall?.copyWith(
                                      color: Colors.white,
                                      fontSize: 44,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'dB',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          provider.detectedType,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          provider.isListening
                              ? 'Mikrofon aktif. Eşik aşıldığında titreşim, bildirim ve kayıt otomatik çalışır.'
                              : 'Canlı ölçüm başlatıldığında cihaz çevresindeki ses şiddeti anlık olarak izlenir.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 24,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ses eşiği', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          provider.thresholdDescription,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Slider(
                          min: 45,
                          max: 100,
                          divisions: 11,
                          value: provider.threshold,
                          label: '${provider.threshold.toStringAsFixed(0)} dB',
                          onChanged: provider.updateThreshold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Daha hassas'),
                            Text('Daha seçici'),
                          ],
                        ),
                        if (provider.errorMessage != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3F0),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFF9F3211),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        PrimaryButton(
                          label: provider.isListening ? 'Durdur' : 'Başlat',
                          icon: provider.isListening
                              ? Icons.pause_circle_rounded
                              : Icons.play_arrow_rounded,
                          semanticsLabel: provider.isListening
                              ? 'Canlı ses algılamayı durdur'
                              : 'Canlı ses algılamayı başlat',
                          onPressed: provider.isListening
                              ? provider.stopListening
                              : provider.startListening,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF4EF), Color(0xFFFFFFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Alarm davranışı', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          'Eşik aşılırsa uygulama yaklaşık her 6 saniyede bir titreşim verir, local notification gösterir ve yalnızca ses türü, dB değeri ile zamanı veritabanına kaydeder.',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
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
