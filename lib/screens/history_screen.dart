import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sessiz_tehlike/models/alert_record.dart';
import 'package:sessiz_tehlike/providers/sound_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final revision = context.watch<SoundProvider>().historyRevision;
    final provider = context.read<SoundProvider>();
    final formatter = DateFormat('dd MMM yyyy • HH:mm', 'tr_TR');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Geri',
        ),
        title: const Text('Geçmiş'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton.icon(
              onPressed: () async {
                await provider.clearHistory();
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Temizle'),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<AlertRecord>>(
        key: ValueKey(revision),
        future: provider.loadAlerts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final alerts = snapshot.data ?? const <AlertRecord>[];
          if (alerts.isEmpty) {
            return const _EmptyHistory();
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return Container(
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
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1EB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_rounded,
                        color: Color(0xFFFF7043),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alert.soundType,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${alert.decibel.toStringAsFixed(1)} dB',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            formatter.format(alert.createdAt),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemCount: alerts.length,
          );
        },
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_toggle_off_rounded,
                size: 42,
                color: Color(0xFF1565C0),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Henüz kritik ses kaydı yok',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Canlı algılama sırasında eşik aşılırsa burada ses tipi, dB değeri ve tarih bilgisi listelenir.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
