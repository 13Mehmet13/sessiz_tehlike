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
  bool _permissionsReady = false;
  double _currentDb = 0;
  double _threshold = 75;
  String _detectedType = 'Sessiz ortam';
  String? _errorMessage;
  int _historyRevision = 0;
  DateTime? _lastAlertAt;

  bool get isListening => _isListening;
  bool get permissionsReady => _permissionsReady;
  double get currentDb => _currentDb;
  double get threshold => _threshold;
  String get detectedType => _detectedType;
  String? get errorMessage => _errorMessage;
  int get historyRevision => _historyRevision;

  Future<void> initialize() async {
    await NotificationService.instance.initialize();
    await DbService.instance.database;
    notifyListeners();
  }

  Future<void> startListening() async {
    if (_isListening) {
      return;
    }

    _permissionsReady = await _permissionService.requestEssentialPermissions();
    if (!_permissionsReady) {
      _errorMessage =
          'Mikrofon veya bildirim izni olmadan canlı algılama başlatılamıyor.';
      notifyListeners();
      return;
    }

    _errorMessage = null;
    _noiseSubscription = _noiseMeter.noise.listen(
      _onNoiseData,
      onError: _onNoiseError,
      cancelOnError: false,
    );

    _isListening = true;
    notifyListeners();
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

    await NotificationService.instance.showCriticalSoundNotification(
      soundType: soundType,
      decibel: decibel,
    );

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
