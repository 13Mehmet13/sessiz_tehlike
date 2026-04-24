import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const androidSettings = AndroidInitializationSettings('ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);
    _initialized = true;
  }

  Future<void> requestPermission() async {
    await initialize();
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showCriticalSoundNotification({
    required String soundType,
    required double decibel,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'critical_sound_channel',
      'Kritik Ses Uyarıları',
      channelDescription: 'Kritik sesler algılandığında gösterilen uyarılar',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Kritik ses algılandı',
      playSound: true,
      enableVibration: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Kritik ses algılandı',
      '$soundType • ${decibel.toStringAsFixed(1)} dB',
      details,
    );
  }
}
