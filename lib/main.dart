import 'package:flutter/material.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:project_m/helpers/notification_service.dart';
import 'package:project_m/socendscreen.dart';

void main() {
  // AwesomeNotifications().initialize(
  //     null,
  //     [
  //       NotificationChannel(
  //         channelKey: 'basic_channel',
  //         channelName: 'Basic notifications',
  //         channelDescription: 'Notification channel for basic tests',
  //       ),
  //     ],
  //     debug: true);

  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationsServices notificationsServices = NotificationsServices();

  @override
  void initState() {
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   }
    // });

    notificationsServices.initialiseNotifications();

    super.initState();
  }

  // triggerNotification() async {
  //   await AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: 10,
  //       channelKey: 'basic_channel',
  //       title: 'Simple Notification',
  //       body: 'Simple body',
  //       notificationLayout: NotificationLayout.Default,
  //       bigPicture: 'https://picsum.photos/300/200?random=1',
  //       badge: 10,
  //       showWhen: true,
  //       autoDismissible: true,
  //       displayOnForeground: true,
  //       displayOnBackground: true,
  //       locked: true,
  //       color: Colors.deepPurple,
  //       backgroundColor: Colors.deepPurple,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                notificationsServices.sendNotification('Title', 'Body');
              },
              child: const Text('Send Notification')),
          ElevatedButton(
              onPressed: () {
                notificationsServices.scheduleNotification('Title', 'Body');
              },
              child: const Text('Schedule Notification')),
          ElevatedButton(
              onPressed: () {
                notificationsServices.stopNotification();
              },
              child: const Text('Stop Notification')),
          ElevatedButton(
              onPressed: () {
                // triggerNotification();
              },
              child: const Text('Trigger Notification')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // notificationsServices.stopNotification();

          final snackBar = SnackBar(
            content: Text('Notification Scheduled'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(snackBar);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
