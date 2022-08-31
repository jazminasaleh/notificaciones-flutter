import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messagestream =
      new StreamController.broadcast();
  static Stream<String> get messageStream => _messagestream.stream;

  static Future _backgrounHandler(RemoteMessage message) async {
    //print('background Handler ${message.messageId}');
    print(message.data);
    _messagestream.add(message.data['producto']?? 'No title');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    //print('onMessage Handler ${message.messageId}');
     print(message.data);
    _messagestream.add(message.data['producto']?? 'No title');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    //print('onMessageOpenApp Handler ${message.messageId}');
    print(message.data);
    _messagestream.add(message.data['producto']?? 'No title');
  }

  static Future initializeApp() async {
    //push notificaciones
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('token $token');

    //Handles
    FirebaseMessaging.onBackgroundMessage(_backgrounHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    //local notificaciones
  }

  static closeStreams() {
    _messagestream.close();
  }
}
