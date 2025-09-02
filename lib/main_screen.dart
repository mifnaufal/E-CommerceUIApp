// lib/main_screen.dart

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// Impor semua halaman yang ingin kita tampilkan di navigasi
import 'home_page.dart';
import 'cart_page.dart';
import 'account_page.dart'; // Ganti dengan halaman list/akun jika perlu
import 'chat_list_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Indeks untuk melacak halaman mana yang sedang aktif
  int _selectedIndex = 0;

  // Daftar semua halaman/widget yang akan ditampilkan
  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const AccountPage(), // Ganti ini jika ikon 'list' menuju halaman lain
    const ChatListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body sekarang akan berubah-ubah sesuai dengan indeks yang dipilih
      body: _pages[_selectedIndex],
      
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        // Atur indeks awal agar sesuai dengan _selectedIndex
        index: _selectedIndex,
        onTap: (index) {
          // Saat item di-tap, perbarui state dengan indeks baru
          setState(() {
            _selectedIndex = index;
          });
        },
        height: 70,
        color: const Color(0xFF4C53A5),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white), // Saya ganti 'list' dengan 'person' untuk AccountPage
          Icon(Icons.chat_bubble_outline, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}