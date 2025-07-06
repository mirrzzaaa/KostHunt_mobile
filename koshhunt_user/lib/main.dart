import 'package:flutter/material.dart';
import 'screen/home.dart';
import 'screen/login_screen.dart';
import 'screen/register.dart';
import 'screen/splash_screen.dart';
import 'services/session_manager.dart'; // <- path utils

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await SessionManager.isLoggedIn();

  runApp(MyApp(isLoggedIn: loggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const MyHomePage() : const SplashScreen(),
      routes: {
        '/home': (_) => const MyHomePage(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterPage(),
      },
    );
  }
}
