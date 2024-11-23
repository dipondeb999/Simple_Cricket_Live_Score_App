import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:score_app/app.dart';
import 'package:score_app/firebase_notification_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotificationService.initialize();
  print(await FirebaseNotificationService.getFcmToken());
  runApp(const LiveScoreApp());
}
