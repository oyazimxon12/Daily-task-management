import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

const _channelId = 'task_reminders';
const _channelName = 'Task Reminders';

@pragma('vm:entry-point')
void _onBackgroundNotificationTap(NotificationResponse response) {
  if (response.payload != null) {
    NotificationService._pendingTaskId = response.payload;
  }
}

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static String? _pendingTaskId;

  static String? consumePendingTaskId() {
    final id = _pendingTaskId;
    _pendingTaskId = null;
    return id;
  }

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          _pendingTaskId = response.payload;
        }
      },
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTap,
    );

    // Check if app was launched from a notification tap (app was closed)
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) _pendingTaskId = payload;
    }

    // Request Android notification permission
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Schedule a reminder 15 minutes before [taskDateTime].
  static Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime taskDateTime,
  }) async {
    final reminderTime = taskDateTime.subtract(const Duration(minutes: 15));
    if (reminderTime.isBefore(DateTime.now())) return;

    final tzTime = tz.TZDateTime.from(reminderTime, tz.local);

    await _plugin.zonedSchedule(
      _idFromTaskId(taskId),
      '⏰ Vazifa eslatmasi',
      taskTitle,
      tzTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: 'Task deadline reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: taskId,
    );
  }

  static Future<void> cancelTaskReminder(String taskId) async {
    await _plugin.cancel(_idFromTaskId(taskId));
  }

  static int _idFromTaskId(String taskId) => taskId.hashCode & 0x7FFFFFFF;
}
