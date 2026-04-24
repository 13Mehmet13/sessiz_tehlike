import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:sessiz_tehlike/models/alert_record.dart';
import 'package:sessiz_tehlike/services/db_service.dart';
import 'package:sessiz_tehlike/services/notification_service.dart';
import 'package:sessiz_tehlike/services/permission_service.dart';
import 'package:vibration/vibration.dart';

class SoundProvider extends ChangeNotifier {
  final NoiseMeter _noiseMeter = NoiseMeter();
  final PermissionService _permissionService = PermissionService();
  StreamSubscription<NoiseReading>? _noiseSubscription;

  bool _isListening = false;
  bool _isStarting = false;
  bool _permissionsReady = false;
  bool _continuousMonitoring = true;
  double _currentDb = 0;
  double _threshold = 75;
  String _detectedType = 'Sessiz ortam';
  String? _errorMessage;
  int _historyRevision = 0;
  DateTime? _lastAlertAt;

  bool get isListening => _isListening;
  bool get isStarting => _isStarting;
  bool get permissionsReady => _permissionsReady;
  bool get continuousMonitoring => _continuousMonitoring;
  double get currentDb => _currentDb;
  double get threshold => _threshold;
  String get detectedType => _detectedType;
  String? get errorMessage => _errorMessage;
  int get historyRevision => _historyRevision;

  String get monitoringLabel => _continuousMonitoring
      ? 'Sürekli algılama modu açık'
      : 'Standart canlı algılama modu';

  Future<void> initialize() async {
    await NotificationService.instance.initialize();
    await DbService.instance.database;
    notifyListeners();
  }

  void setContinuousMonitoring(bool value) {
    _continuousMonitoring = value;
    notifyListeners();
  }

  Future<void> startListening() async {
    if (_isListening || _isStarting) {
      return;
    }

    _isStarting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final microphoneGranted =
          await _permissionService.requestMicrophonePermission();
      _permissionsReady = microphoneGranted;

      if (!microphoneGranted) {
        _errorMessage =
            'Mikrofon izni verilmediği için algılama başlatılamadı.';
        return;
      }

      _noiseSubscription = _noiseMeter.noise.listen(
        _onNoiseData,
        onError: _onNoiseError,
        cancelOnError: false,
      );

      _isListening = true;
      _errorMessage = null;

      unawaited(_prepareOptionalNotificationPermission());
    } catch (error) {
      _errorMessage = 'Algılama başlatılırken hata oluştu: $error';
    } finally {
      _isStarting = false;
      notifyListeners();
    }
  }

  Future<void> _prepareOptionalNotificationPermission() async {
    final notificationGranted =
        await _permissionService.requestNotificationPermission();
    if (!notificationGranted && _isListening) {
      _errorMessage =
          'Algılama aktif. Ancak bildirim izni verilmediği için yalnızca titreşim ve geçmiş kaydı kullanılabilir.';
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    await _noiseSubscription?.cancel();
    _noiseSubscription = null;
    _isListening = false;
    notifyListeners();
  }

  void updateThreshold(double value) {
    _threshold = value;
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await DbService.instance.clearAlerts();
    _historyRevision++;
    notifyListeners();
  }

  ColorBand get band {
    if (_currentDb >= 80) {
      return ColorBand.critical;
    }
    if (_currentDb >= 65) {
      return ColorBand.warning;
    }
    return ColorBand.safe;
  }

  String get thresholdDescription =>
      'Uyarı eşiği ${_threshold.toStringAsFixed(0)} dB olarak ayarlı';

  String classifyDecibel(double decibel) {
    if (decibel >= 90) {
      return 'Çok yüksek kritik ses';
    }
    if (decibel >= 80) {
      return 'Alarm / korna benzeri ses';
    }
    if (decibel >= 70) {
      return 'Kapı zili / yüksek ortam sesi';
    }
    if (decibel >= 55) {
      return 'Normal konuşma / ortam sesi';
    }
    return 'Sessiz ortam';
  }

  Future<List<AlertRecord>> loadAlerts() {
    return DbService.instance.getAlerts();
  }

  void _onNoiseData(NoiseReading reading) {
    final normalizedDb = max<double>(0, reading.meanDecibel.toDouble());
    _currentDb = normalizedDb;
    _detectedType = classifyDecibel(normalizedDb);
    notifyListeners();

    if (normalizedDb >= _threshold) {
      unawaited(_triggerCriticalAlert(normalizedDb));
    }
  }

  void _onNoiseError(Object error) {
    _errorMessage = 'Ses algılama sırasında bir hata oluştu: $error';
    _isListening = false;
    _isStarting = false;
    notifyListeners();
  }

  Future<void> _triggerCriticalAlert(double decibel) async {
    final now = DateTime.now();
    if (_lastAlertAt != null &&
        now.difference(_lastAlertAt!) < const Duration(seconds: 6)) {
      return;
    }

    _lastAlertAt = now;
    final soundType = classifyDecibel(decibel);

    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(
          pattern: const <int>[0, 300, 150, 500],
          intensities: const <int>[128, 255],
        );
      }
    } catch (_) {
      // Some devices may restrict custom vibration patterns.
    }

    try {
      await NotificationService.instance.showCriticalSoundNotification(
        soundType: soundType,
        decibel: decibel,
      );
    } catch (_) {
      // Notification failures should not block history logging.
    }

    await DbService.instance.insertAlert(
      AlertRecord(
        soundType: soundType,
        decibel: decibel,
        createdAt: now,
      ),
    );

    _historyRevision++;
    notifyListeners();
  }

  @override
  void dispose() {
    _noiseSubscription?.cancel();
    super.dispose();
  }
}

enum ColorBand { safe, warning, critical }
