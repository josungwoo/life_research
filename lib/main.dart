import 'dart:async'; // Timer
import 'package:flutter/material.dart';
// 파이어베이스
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// 페이지
import 'package:life_research/Auth/LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'life-research',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: SplashPage()));
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Wait 3 seconds, then navigate to loginPage.
    // no animation when navigating to loginPage.
    Timer(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite),
            Text('Life Research'),
          ],
        ),
      ),
    );
  }
}
