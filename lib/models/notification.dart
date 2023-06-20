import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  final int id;
  final String title;
  final String body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });

}

class NotificationService {
  late FlutterLocalNotificationsPlugin _localNotificationsPlugin;
  late AndroidNotificationDetails _androidNotificationDetails;

  NotificationService() {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupAndroidDetails();
    _setupNotifications();
  }

  void _setupAndroidDetails() {
    _androidNotificationDetails = const AndroidNotificationDetails(
      'cefetmg_automation',
      'cefenotifications',
      channelDescription: 'Canal de notificações do CefetMG Automation',
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
    );
  }

  void _setupNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _localNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
    );
  }

  Future<void> showNotification(CustomNotification notification) async {
    await _localNotificationsPlugin.show(
      notification.id,
      notification.title,
      notification.body,
      NotificationDetails(android: _androidNotificationDetails),
      payload: notification.payload,
    );
  }
}
