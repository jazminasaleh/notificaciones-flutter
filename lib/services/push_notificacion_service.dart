import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  //obtener la istancia de firbase messaging
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messagestream =new StreamController.broadcast();
  static Stream<String> get messageStream => _messagestream.stream;

  static Future _backgrounHandler(RemoteMessage message) async {
    _messagestream.add(message.notification?.body?? 'No title');
     print(message.data);
     
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print(message.data);
    _messagestream.add(message.data['producto'] ?? 'No title');
    
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print(message.data);
    _messagestream.add(message.data['producto'] ?? 'No title');
    
  }

  static Future initializeApp() async {
    //push notificaciones
    //inicializacion de la app
    await Firebase.initializeApp();
    await requestPermission();
    //lo que se necsita para enviar las notificaciones al dispossitivo
    //es lo que se pide en firbase a la hora de neviar un mensaje
    token = await FirebaseMessaging.instance.getToken();
    print('token $token');

    //Handles
    FirebaseMessaging.onBackgroundMessage(_backgrounHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
    //local notificaciones
  }
   static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true
    );

    print('User push notification status ${ settings.authorizationStatus }');

  }

  static closeStreams() {
    _messagestream.close();
  }
}
