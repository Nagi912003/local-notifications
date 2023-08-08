import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';

class NotificationsServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('logo_m');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    scheduleDailyNotifications('لمحة', 'معجزة كل يوم');
  }

  void sendNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo_m',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void scheduleNotification(String title, String body) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo_m',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0, title, body, RepeatInterval.everyMinute, notificationDetails);
  }

  void scheduleDailyNotifications(String title, String body) async {
    // Initialize the timezone library
    tz.initializeTimeZones();

    // Get the local timezone
    tz.Location local = tz.getLocation(await FlutterNativeTimezone.getLocalTimezone());

    // Calculate the time for the notifications
    tz.TZDateTime now = tz.TZDateTime.now(local);
    tz.TZDateTime scheduledTimeMorning = tz.TZDateTime(local, now.year, now.month, now.day, 8);
    tz.TZDateTime scheduledTimeEvening = tz.TZDateTime(local, now.year, now.month, now.day, 18);

    // Schedule the notifications
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo_m',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, title, body, scheduledTimeMorning, notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      1, title, body, scheduledTimeEvening, notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  void stopNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}

class NotificationAPI {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    final settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'));

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        onNotifications.add(payload.payload);
      },
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo_m',
    );

    var platformChannel = NotificationDetails(android: androidChannel);

    await _notifications.show(id, title, body, platformChannel,
        payload: payload);
  }

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var androidChannel = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo_m',
    );

    var platformChannel = NotificationDetails(android: androidChannel);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduleDaily(DateTime(14,53,30)),
      platformChannel,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );


  }
  static tz.TZDateTime _scheduleDaily(DateTime time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
