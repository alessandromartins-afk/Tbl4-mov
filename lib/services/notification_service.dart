
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> iniciar({
    required void Function(String pedidoId) aoAbrirPedido,
    required void Function(String mensagem) aoReceberMensagem,
  }) async {
    await Firebase.initializeApp();

    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await messaging.getToken();
    debugPrint('Token FCM: $token');

    FirebaseMessaging.onMessage.listen((message) {
      final titulo = message.notification?.title ?? 'Nova mensagem';
      final corpo = message.notification?.body ?? '';

      aoReceberMensagem('$titulo - $corpo');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final pedidoId = message.data['pedidoId'];

      if (pedidoId != null) {
        aoAbrirPedido(pedidoId.toString());
      }
    });

    final initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      final pedidoId = initialMessage.data['pedidoId'];

      if (pedidoId != null) {
        aoAbrirPedido(pedidoId.toString());
      }
    }
  }
}
