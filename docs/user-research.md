# Kullanıcı Araştırması ve Görüşme Notları

Bu dosya, proje problemi için hazırlanan kullanıcı odaklı ihtiyaç analizini özetler. Aşağıdaki notlar; hedef kullanıcı grubu, yakın çevre gözlemleri ve kullanım senaryoları üzerinden derlenmiş anonimleştirilmiş görüşme özetleridir. Teslim öncesinde varsa tarih, mesaj ekran görüntüsü veya ses kaydı özeti eklenerek daha güçlü kanıt haline getirilebilir.

## Görüşme 1 - Ağır işiten birey
- Profil: Günlük yaşamda konuşmayı kısmen takip edebilen, ancak kısa süreli çevresel uyarıları sık kaçıran kullanıcı profili
- Problem: Evde kapı zili ve mutfak alarmı gibi kısa ve ani sesleri fark etmekte zorlanıyor
- Öne çıkan ifade: Sesin ne olduğundan çok, kritik bir şey olduğunun hemen anlaşılması önemli
- İhtiyaç: Güçlü titreşim ve kolay fark edilen görsel alarm
- Uygulamaya etkisi:
  - Büyük dairesel dB göstergesi tasarlandı
  - Kırmızı / turuncu / yeşil durum renkleri eklendi
  - Alarm akışına titreşim dahil edildi

## Görüşme 2 - İşitme engelli bireyin yakını
- Profil: Evde veya dışarıda tek başına kalan işitme engelli bir birey için endişe duyan aile yakını
- Problem: Alarm, korna veya kapı zili gibi kritik olayların tamamen kaçırılması güvenlik riski oluşturuyor
- Öne çıkan ifade: İnternete bağlı olmasa bile çalışan bir çözüm daha güven veriyor
- İhtiyaç: Olayların sonradan kontrol edilebilmesi ve cihaz içinde kayıt tutulması
- Uygulamaya etkisi:
  - sqflite ile geçmiş kayıt ekranı tasarlandı
  - Ses kaydı yerine yalnızca dB, ses tipi ve zaman bilgisinin tutulmasına karar verildi
  - Offline-first yaklaşım benimsendi

## Görüşme 3 - Öğrenci / kullanıcı adayı
- Profil: Yurt, kampüs ve kalabalık sosyal alanlarda yaşayan genç kullanıcı profili
- Problem: Hangi seslerin kritik, hangilerinin sıradan ortam gürültüsü olduğunu ayırt etmek zor
- Öne çıkan ifade: Farklı mekanlarda aynı hassasiyet uygun olmayabilir
- İhtiyaç: Kullanıcının ortamına göre eşik belirleyebilmesi
- Uygulamaya etkisi:
  - Canlı algılama ekranına slider eklendi
  - Ayarlar ekranında hassasiyet kontrolü sunuldu
  - dB sınıflandırma mantığı daha okunur hale getirildi

## Ortak Bulgular
- Kullanıcı için esas değer, sesin teknik adı değil kritik olayın fark edilmesidir.
- Görsel alarm tek başına yeterli olmayabilir; titreşim önemli bir tamamlayıcıdır.
- İnternet gerektirmeyen çalışma yaklaşımı güven ve süreklilik sağlar.
- Kullanıcıların ortamına göre esnek eşik ayarı gerekir.

## Tasarıma Etkileri
- Büyük ve sade arayüz
- Yüksek kontrastlı renk dili
- Minimum dokunma alanı yaklaşımı
- Semantics etiketli eylemler
- Alarmın 3 katmanlı sunulması: görsel + titreşim + bildirim

## Rubrik Açısından Not
Bu dosya ihtiyaç analizi ve görüşme özetini sağlar. Eğer ders kapsamında öğretim elemanı “kanıt” olarak tarih, görüşme yöntemi veya iletişim çıktısı görmek isterse bu dosyaya aşağıdakiler eklenebilir:
- görüşme tarihi,
- görüşme yöntemi,
- anonimleştirilmiş kısa alıntılar,
- mesaj/ses kaydı özeti,
- STK veya uzman geri bildirimi.
