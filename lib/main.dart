import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'account_page.dart';
import 'change_password_page.dart';
import 'notifications_page.dart';
import 'help_page.dart';
import 'home_page.dart';
import 'cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/home',
      // Tambahkan rute-rute baru di sini
      routes: {
        '/': (context) => const SignUpPage(),
        '/login': (context) => const LoginPage(),
        '/account': (context) => const AccountPage(),
        '/changePassword': (context) => const ChangePasswordPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/help': (context) => const HelpPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}