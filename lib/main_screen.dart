// lib/main_screen.dart

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// Impor semua halaman yang kita butuhkan
import 'home_page.dart';
import 'cart_page.dart';
import 'account_page.dart';
import 'chat_list_page.dart';

// Data Model untuk Item. Kita letakkan di sini agar bisa diakses semua halaman.
class Item {
  final int id;
  final String name;
  final String imagePath;
  final double price;

  Item({required this.id, required this.name, required this.imagePath, required this.price});
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // =======================================================
  // PUSAT KENDALI KERANJANG BELANJA
  // =======================================================
  final List<CartItem> _cartItems = [];

  void _addToCart(Item product) {
    setState(() {
      // Cek apakah produk sudah ada di keranjang
      for (var item in _cartItems) {
        if (item.product.id == product.id) {
          item.quantity++; // Jika ada, tambah jumlahnya
          return;
        }
      }
      // Jika tidak ada, tambahkan sebagai item baru
      _cartItems.add(CartItem(product: product));
    });
  }

  void _removeFromCart(int productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  void _updateQuantity(int productId, int change) {
    setState(() {
      final item = _cartItems.firstWhere((item) => item.product.id == productId);
      if (item.quantity + change > 0) {
        item.quantity += change;
      }
    });
  }
  // =======================================================

  // Kita buat daftar halaman di dalam build agar bisa passing fungsi
  @override
  Widget build(BuildContext context) {
    // Daftar halaman sekarang menerima data & fungsi keranjang
    final List<Widget> pages = [
      HomePage(onAddToCart: _addToCart), // Kirim fungsi _addToCart ke HomePage
      CartPage( // Kirim semua data & fungsi yang relevan ke CartPage
        cartItems: _cartItems,
        onRemoveFromCart: _removeFromCart,
        onUpdateQuantity: _updateQuantity,
      ),
      const AccountPage(),
      const ChatListPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        height: 70,
        color: const Color(0xFF4C53A5),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.chat_bubble_outline, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}