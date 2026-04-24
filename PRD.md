# Sessiz Tehlike - Product Requirements Document

## 1. Problem Tanımı
- Hedef kullanıcı: İşitme engelli ve ağır işiten bireyler
- İkincil kullanıcı: Yakınlar, bakım sağlayıcılar, yalnız yaşayan kullanıcılar
- Problem: Kullanıcılar kapı zili, alarm, korna ve benzeri kritik çevresel sesleri zamanında fark edemeyebiliyor.
- Sonuç: Günlük yaşam akışı bozuluyor, güvenlik riski doğuyor, kullanıcı bağımsızlığı azalabiliyor.

### Problem Doğrulama Özeti
- Kullanıcı araştırması notlarında üç farklı profil üzerinden ortak ihtiyaç doğrulandı.
- Ortak bulgu: sesin kendisinden çok, kritik bir olayın fark edilmesi gerekiyor.
- Ek bulgu: offline kullanım güven ve erişilebilirlik açısından önemli.

Detaylar için: [docs/user-research.md](docs/user-research.md)

## 2. Çözüm Önerisi
Sessiz Tehlike, cihaz mikrofonunu kullanarak canlı dB ölçümü yapar. Kullanıcı tarafından belirlenen eşik aşıldığında:
- titreşim üretir,
- local notification gösterir,
- görsel alarm etkisi oluşturur,
- olayı cihaz içi veritabanına kaydeder.

### Mobilin Rolü Neden Kritik?
- Mikrofon ile anlık çevresel veri alınır.
- Haptic feedback ile ses yerine dokunsal uyarı sunulur.
- Local notification ile uygulama dışında da kritik uyarı görünür olur.
- Offline-first yapı sayesinde internet olmadan temel deneyim devam eder.

### Değer Önermesi
“Çevrendeki kritik sesleri duymasam da telefonum titreşim, bildirim ve görsel alarm ile bana hissettirsin.”

## 3. Benzersizlik ve Farklılaşma
Bu proje sıradan bir desibel ölçer uygulaması olarak tasarlanmamıştır. Farklılaşma noktaları:
- Net hedef kitle odaklıdır.
- Erişilebilirlik ana senaryonun merkezindedir.
- Sadece ölçüm değil, alarm davranışı ve geçmiş kaydı sunar.
- Ses kaydı saklamadan gizlilik öncelikli bir yaklaşım benimser.
- Ek donanım istemeden sadece mobil cihazla çalışır.

## 4. Rakip Analizi

| Rakip | Eksiği | Sessiz Tehlike Farkı |
| --- | --- | --- |
| Genel dB ölçer uygulamaları | Erişilebilir alarm deneyimi zayıf | Titreşim + bildirim + görsel alarm |
| Akıllı ev çözümleri | Ek cihaz ve maliyet gerekir | Sadece akıllı telefon ile çalışır |
| Giyilebilir cihaz çözümleri | Ek cihaz bağımlılığı vardır | Düşük giriş bariyeri, tek cihaz kullanımı |

## 5. Kullanıcı Hikayeleri
- US-1: İşitme engelli kullanıcı olarak kapı zili veya alarm benzeri kritik bir ses olduğunda telefonumun titreşimle beni uyarmasını istiyorum.
- US-2: Ağır işiten kullanıcı olarak farklı ortamlar için alarm eşiğini kendim ayarlamak istiyorum.
- US-3: Kullanıcı yakını olarak kritik olayların cihaz içinde kayıt altına alınmasını istiyorum.
- US-4: Öğrenci kullanıcı olarak internet olmadan da temel algılama işlevinin çalışmasını istiyorum.

## 6. MVP Kapsamı
- [x] Mikrofon ile canlı dB ölçümü
- [x] Ayarlanabilir eşik değeri
- [x] Renk tabanlı görsel alarm
- [x] Eşik aşımında titreşim
- [x] Eşik aşımında local notification
- [x] Kritik olayları sqflite ile cihaz içinde saklama
- [x] Geçmiş ekranında kayıt listeleme
- [x] Geçmiş temizleme
- [x] Semantics odaklı temel erişilebilir arayüz
- [x] Offline-first çalışma mantığı

## 7. MVP Dışı Gelecek Aşamalar
- Kritik ses türlerini daha akıllı sınıflandırmak
- Akıllı saat entegrasyonu
- Türkçe ve İngilizce dil desteği
- Kullanıcıya özel titreşim profilleri
- Belirli ses türleri için ayrı alarm şablonları

## 8. Teknik Mimari
- Framework: Flutter
- State management: Provider
- Routing: GoRouter
- Local DB: sqflite
- Mikrofon / dB algılama: noise_meter
- Bildirim: flutter_local_notifications
- İzinler: permission_handler
- Titreşim: vibration
- Veri yaklaşımı: offline-first

### Veri Modeli
`alerts` tablosu alanları:
- `id`
- `soundType`
- `decibel`
- `createdAt`

### Alarm Mantığı
- dB seviyesi eşik ile karşılaştırılır.
- Eşik aşıldığında yaklaşık 6 saniyelik koruma aralığıyla tekrar alarm üretilir.
- Alarm akışı: titreşim → bildirim → veritabanı kaydı

## 9. dB Sınıflandırma Kuralları
- `90+ dB`: Çok yüksek kritik ses
- `80+ dB`: Alarm / korna benzeri ses
- `70+ dB`: Kapı zili / yüksek ortam sesi
- `55+ dB`: Normal konuşma / ortam sesi
- `55 altı`: Sessiz ortam

## 10. Erişilebilirlik (a11y) Beyanı
- [x] Kritik eylem butonlarında Semantics kullanıldı
- [x] Büyük dokunma alanları hedeflendi
- [x] Yüksek kontrastlı açık tema tasarlandı
- [x] Alarm yalnızca işitsel değil, dokunsal ve görsel de veriliyor
- [x] Karmaşık ekran hiyerarşisinden kaçınıldı
- [ ] TalkBack/VoiceOver ile gerçek cihaz testi teslim öncesi doğrulanmalı

## 11. Gizlilik ve Güvenlik
- Uygulama ses kaydı tutmaz.
- Ham ses verisi saklanmaz.
- Yalnızca dB değeri, ses tipi ve zaman damgası cihaz içinde tutulur.
- Veri harici sunucuya gönderilmez.
- Kullanıcı gizliliği gereği kayıtlar cihaz dışına çıkarılmaz.

## 12. Başarı Ölçütleri
- Uygulama `flutter run` ile açılmalı
- Kullanıcı canlı ölçümü başlatabilmeli
- Eşik aşıldığında alarm davranışı tetiklenmeli
- Geçmiş ekranında kayıtlar listelenmeli
- Uygulama internet bağlantısı olmadan temel işlevi sürdürebilmeli

## 13. Riskler
- Farklı cihazlarda mikrofon dB değerleri değişken olabilir
- Android sürümlerinde bildirim izni davranışı farklılık gösterebilir
- Gürültülü ortamlar yanlış pozitif üretme riski taşıyabilir

## 14. Kaynaklar
- WHO hearing loss fact sheet: [who.int](https://www.who.int/en/news-room/fact-sheets/detail/deafness-and-hearing-loss)
- T.C. Aile ve Sosyal Hizmetler Bakanlığı erişilebilir iletişim hizmetleri: [aile.gov.tr](https://www.aile.gov.tr/haberler/ailem-isitme-engelliler-engelsiz-iletisim-merkezi-268-bin-719-cagriya-ceviri-destegi-sagladi/)
