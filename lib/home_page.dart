// lib/home_page.dart

import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'main_screen.dart'; // Impor untuk mengakses class Item

// Halaman HomePage sekarang menerima fungsi onAddToCart
class HomePage extends StatelessWidget {
  final Function(Item) onAddToCart;
  const HomePage({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFEDECF2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                // ... (Search Widget dan Categories tidak berubah)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(children: [
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search here..."),
                    )),
                    const Icon(Icons.camera_alt,
                        size: 27, color: Color(0xFF4C53A5))
                  ]),
                ),
                const CategoriesWidget(),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 10),
                  child: const Text("Best Selling",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5))),
                ),
                // Kirim fungsi onAddToCart ke ItemsWidget
                ItemsWidget(onAddToCart: onAddToCart),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget AppBar (tidak berubah)
class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Container( /* ... kode tidak berubah ... */ );
  }
}

// Widget Kategori (tidak berubah)
class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( /* ... kode tidak berubah ... */ );
  }
}

// Widget Daftar Item (DENGAN PERUBAHAN PENTING)
// Salin dan ganti class ItemsWidget di dalam file lib/home_page.dart

// Salin dan ganti seluruh class ItemsWidget di dalam file lib/home_page.dart

class ItemsWidget extends StatelessWidget {
  final Function(Item) onAddToCart;

  // ===== PERBAIKAN DI SINI: Kata 'const' DIHAPUS dari constructor =====
  ItemsWidget({super.key, required this.onAddToCart});

  // Daftar produk ini sekarang tidak akan menyebabkan error lagi
  final List<Item> products = [
    Item(id: 1, name: "Product Title 1", imagePath: "assets/images/carts/1.jpeg", price: 55),
    Item(id: 2, name: "Product Title 2", imagePath: "assets/images/carts/2.jpeg", price: 60),
    Item(id: 3, name: "Product Title 3", imagePath: "assets/images/carts/3.jpeg", price: 45),
    Item(id: 4, name: "Product Title 4", imagePath: "assets/images/carts/4.jpeg", price: 90),
    Item(id: 5, name: "Product Title 5", imagePath: "assets/images/carts/5.jpeg", price: 75),
    Item(id: 6, name: "Sandal", imagePath: "assets/images/carts/9.jpeg", price: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xFF4C53A5),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text("-50%",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold))),
                const Icon(Icons.favorite_border, color: Colors.red)
              ]),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: Image.asset(product.imagePath, height: 120, width: 120),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft,
                child: Text(product.name,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF4C53A5),
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text("Short Description",
                    style: TextStyle(fontSize: 15, color: Color(0xFF4C53A5))),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("\$${product.price}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4C53A5))),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_checkout,
                          color: Color(0xFF4C53A5)),
                      onPressed: () {
                        onAddToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${product.name} ditambahkan ke keranjang!"),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}