// lib/cart_page.dart

import 'package:flutter/material.dart';
import 'cart_appbar.dart';
import 'main_screen.dart'; // Impor untuk mengakses class Item

// Data model untuk item di dalam keranjang, termasuk jumlahnya
class CartItem {
  final Item product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

// Halaman Cart sekarang hanya menerima data dari luar
class CartPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(int) onRemoveFromCart;
  final Function(int, int) onUpdateQuantity;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.onUpdateQuantity,
  });

  // Fungsi untuk menghitung total
  double _calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CartAppBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: cartItems.isEmpty
                  // Tampilkan pesan jika keranjang kosong
                  ? const Center(
                      child: Text(
                        "Keranjang Anda Kosong",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  // Tampilkan daftar jika ada isinya
                  : ListView(
                      children: [
                        for (var cartItem in cartItems)
                          _buildCartItemWidget(cartItem),
                        _buildCheckoutSection(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan satu item
  Widget _buildCartItemWidget(CartItem cartItem) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(right: 15),
            child: Image.asset(cartItem.product.imagePath, fit: BoxFit.cover),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(cartItem.product.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4C53A5))),
                Text("\$${cartItem.product.price}",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)),
              ],
            ),
          ),
          // Tombol +/-
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => onUpdateQuantity(cartItem.product.id, -1),
              ),
              Text(cartItem.quantity.toString().padLeft(2, '0'),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onUpdateQuantity(cartItem.product.id, 1),
              ),
            ],
          ),
          // TOMBOL HAPUS
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onRemoveFromCart(cartItem.product.id),
          ),
        ],
      ),
    );
  }

  // Widget untuk bagian checkout
  Widget _buildCheckoutSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total:",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text("\$${_calculateTotal().toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue))
            ],
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: const Text("Check Out",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}