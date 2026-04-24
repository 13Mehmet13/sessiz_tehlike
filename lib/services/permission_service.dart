import 'package:permission_handler/permission_handler.dart';
import 'package:sessiz_tehlike/services/notification_service.dart';

class PermissionService {
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    await NotificationService.instance.requestPermission();
    final status = await Permission.notification.request();
    return status.isGranted || status.isLimited || status.isProvisional;
  }

  Future<bool> requestEssentialPermissions() async {
    final microphoneGranted = await requestMicrophonePermission();
    final notificationGranted = await requestNotificationPermission();
    return microphoneGranted && notificationGranted;
  }
}
