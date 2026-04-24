import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> requestNotificationPermission() async {
    final currentStatus = await Permission.notification.status;
    if (currentStatus.isGranted ||
        currentStatus.isLimited ||
        currentStatus.isProvisional) {
      return true;
    }

    final requestedStatus = await Permission.notification.request();
    return requestedStatus.isGranted ||
        requestedStatus.isLimited ||
        requestedStatus.isProvisional;
  }

  Future<bool> requestEssentialPermissions() async {
    final microphoneGranted = await requestMicrophonePermission();
    final notificationGranted = await requestNotificationPermission();
    return microphoneGranted && notificationGranted;
  }
}
