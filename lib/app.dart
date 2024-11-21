import 'package:flutter/material.dart';
import 'package:score_app/ui/screens/live_score_screen.dart';

class LiveScoreApp extends StatelessWidget {
  const LiveScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveScoreScreen(),
    );
  }
}
