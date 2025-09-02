import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'account_page.dart';
import 'cart_page.dart'; // Tetap diimpor karena dibutuhkan oleh MainScreen
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
        '/home': (context) => const MainScreen(),
        
        // ===== PERBAIKAN DI SINI: Rute '/cart' DIHAPUS =====
        // Rute ini tidak lagi diperlukan karena CartPage adalah bagian dari MainScreen
        
        '/': (context) => const SignUpPage(),
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