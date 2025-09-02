// lib/main.dart (Versi Terbaru)
import 'package:flutter/material.dart';

// Impor halaman "wadah" baru kita
import 'main_screen.dart';

// Impor halaman-halaman lain yang masih dibutuhkan untuk routing
import 'login_page.dart';
import 'signup_page.dart';
import 'account_page.dart';
import 'cart_page.dart';
import 'change_password_page.dart';
import 'notifications_page.dart';
import 'help_page.dart';
import 'chat_list_page.dart';
import 'chat_screen_page.dart';

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
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        // Rute '/home' sekarang mengarah ke MainScreen
        '/home': (context) => const MainScreen(),

        // Rute-rute lain tetap sama untuk navigasi internal (misal dari AppBar)
        '/': (context) => const SignUpPage(),
        '/cart': (context) => const CartPage(),
        '/account': (context) => const AccountPage(),
        '/chatlist': (context) => const ChatListPage(),
        '/changePassword': (context) => const ChangePasswordPage(),
        '/notifications': (context) => const NotificationsPage(),
        '/help': (context) => const HelpPage(),
        '/chatscreen': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final contactName = args['contactName'];
          return ChatScreenPage(contactName: contactName);
        },
      },
    );
  }
}