import 'package:ecarrgo/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class FcmTokenProvider with ChangeNotifier {
  final _logger = Logger();
  String? _fcmToken;
  bool _isListening = false;

  String? get fcmToken => _fcmToken;

  Future<void> initFcmToken({BuildContext? context}) async {
    await Future.delayed(const Duration(milliseconds: 100)); // tambah delay

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    _fcmToken = await messaging.getToken();
    _logger.i('📲 FCM Token: $_fcmToken');

    if (_isListening) return;
    _isListening = true;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final data = message.data;

      _logger.i("💡 🔸 Event: ${data['event']}");

      if (notification != null) {
        final scaffoldMessenger = scaffoldMessengerKey.currentState;
        if (scaffoldMessenger != null) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("🔔 ${notification.title ?? 'No Title'}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(notification.body ?? 'No Body'),
                  Text("📦 Event: ${data['event'] ?? 'Tidak ada'}"),
                ],
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          _logger.e("❌ ScaffoldMessenger belum siap.");
        }
      }

      _logger.i("💡 🔸 Title: ${notification?.title}");
      _logger.t("💡 🔸 Body: ${notification?.body}");
      _logger.t("💡 🔸 Data: ${message.data}");
    });
  }
}
