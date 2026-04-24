import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Geri',
        ),
        title: const Text('Proje Hakkında'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: const [
          _AboutSection(
            title: 'Problem tanımı',
            content:
                'İşitme engelli veya ağır işiten bireyler kapı zili, alarm, korna ve benzeri kritik sesleri günlük yaşamda her zaman fark edemeyebilir. Bu durum güvenlik ve bağımsız hareket etme açısından önemli bir boşluk yaratır.',
          ),
          SizedBox(height: 16),
          _AboutSection(
            title: 'Çözüm',
            content:
                'Sessiz Tehlike, çevresel ses şiddetini çevrimdışı olarak izler ve kullanıcı tanımlı eşik aşıldığında görsel alarm, titreşim ve yerel bildirim ile anında uyarı verir.',
          ),
          SizedBox(height: 16),
          _AboutSection(
            title: 'Gizlilik',
            content:
                'Uygulama ses kaydı tutmaz. Yalnızca dB seviyesi, sınıflandırılmış ses tipi ve zaman bilgisi cihaz içinde saklanır.',
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

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
          Text(content, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
