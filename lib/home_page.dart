// lib/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'home_appbar.dart';        // gunakan versi AppBar yang sudah kita buat
import 'categories_widget.dart';  // gunakan CategoriesWidget yang sudah ada
import 'main_screen.dart';        // untuk akses class Item

class HomePage extends StatelessWidget {
  final Function(Item) onAddToCart;
  const HomePage({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const HomeAppBar(), // kalau mau versi container di body, pindahkan sesuai kebutuhan
      body: ListView(
        children: [
          // Header area (search + categories)
          Container(
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search here...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        onPressed: () {
                          // UI only
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Search by image belum diimplementasikan')),
                          );
                        },
                        icon: const Icon(Icons.camera_alt),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // Categories
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: CategoriesWidget(),
                ),

                // Section title
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                    child: Text(
                      'Best Selling',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ),

                // Produk grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ItemsWidget(onAddToCart: onAddToCart),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================
// ItemsWidget – kartu produk modern (M3)
// =======================================

class ItemsWidget extends StatelessWidget {
  final Function(Item) onAddToCart;

  ItemsWidget({super.key, required this.onAddToCart});

  final List<Item> products = [
    Item(id: 1, name: "Product Title 1", imagePath: "assets/images/carts/1.jpeg", price: 55),
    Item(id: 2, name: "Product Title 2", imagePath: "assets/images/carts/2.jpeg", price: 60),
    Item(id: 3, name: "Product Title 3", imagePath: "assets/images/carts/3.jpeg", price: 45),
    Item(id: 4, name: "Product Title 4", imagePath: "assets/images/carts/4.jpeg", price: 90),
    Item(id: 5, name: "Product Title 5", imagePath: "assets/images/carts/5.jpeg", price: 75),
    Item(id: 6, name: "Sandal",          imagePath: "assets/images/carts/9.jpeg", price: 30),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .72,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // UI only: detail produk
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka detail: ${p.name} (simulasi)')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge diskon + favorit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-50%',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Tambah ke favorit',
                        onPressed: () {
                          // UI only
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${p.name} ditandai (simulasi)')),
                          );
                        },
                        icon: const Icon(Icons.favorite_border),
                        color: Colors.red,
                      ),
                    ],
                  ),

                  // Gambar
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          p.imagePath,
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            color: scheme.surfaceVariant,
                            child: Icon(Icons.image_not_supported_outlined,
                                color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Nama
                  Text(
                    p.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                  ),

                  const SizedBox(height: 2),

                  // Deskripsi singkat
                  Text(
                    'Short Description',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),

                  const SizedBox(height: 6),

                  // Rating
                  RatingBarIndicator(
                    rating: 4.2, // statis contoh
                    itemSize: 16,
                    unratedColor: scheme.outlineVariant,
                    itemBuilder: (context, _) => Icon(Icons.star, color: scheme.tertiary),
                  ),

                  const SizedBox(height: 6),

                  // Harga + tombol add-to-cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${p.price}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Tambah ke keranjang',
                        onPressed: () {
                          onAddToCart(p);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${p.name} ditambahkan ke keranjang!'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart_checkout),
                        style: IconButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
