import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'the_map_project_general';
  static const String _channelName = 'The Map Project';
  static const String _channelDescription =
      'Navigation, route, and road alert notifications.';

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      settings: initializationSettings,
    );

    await _createAndroidChannel();
    await _requestAndroidPermission();
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  Future<void> _requestAndroidPermission() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }

  Future<void> showTestNotification() async {
    await showNotification(
      id: 1,
      title: 'The Map Project',
      body: 'Notifications are working successfully!',
    );
  }

  Future<void> showJourneyStarted() async {
    await showNotification(
      id: 100,
      title: 'Journey Started',
      body: 'Navigation has started.',
    );
  }

  Future<void> showJourneyCompleted() async {
    await showNotification(
      id: 101,
      title: 'Journey Completed',
      body: 'You have reached your destination.',
    );
  }

  Future<void> showRouteUpdated() async {
    await showNotification(
      id: 102,
      title: 'Route Updated',
      body: 'Your route has been updated because of a road event.',
    );
  }

  Future<void> showRoadAlert({
    required String title,
    required String body,
  }) async {
    await showNotification(
      id: 103,
      title: title,
      body: body,
    );
  }
}
