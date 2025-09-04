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

  // Fungsi untuk menghitung total (tetap, tidak diubah)
  double _calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          const CartAppBar(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: cartItems.isEmpty
                  // Empty state (UI saja)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 64, color: scheme.onSurfaceVariant),
                            const SizedBox(height: 12),
                            Text(
                              "Keranjang Anda Kosong",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Ayo tambahkan produk favorit Anda.",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: scheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    )
                  // Daftar item + section checkout (struktur tetap)
                  : ListView(
                      padding:
                          const EdgeInsets.only(left: 12, right: 12, bottom: 24),
                      children: [
                        for (var cartItem in cartItems)
                          _buildCartItemWidget(context, cartItem),
                        _buildCheckoutSection(context),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan satu item (UI saja)
  Widget _buildCartItemWidget(BuildContext context, CartItem cartItem) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 72,
                width: 72,
                color: scheme.surfaceVariant.withOpacity(.5),
                child: Image.asset(
                  cartItem.product.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info produk
            Expanded(
              child: SizedBox(
                height: 72,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const Spacer(),
                    Text(
                      "\$${cartItem.product.price}",
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Tombol +/-
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => onUpdateQuantity(cartItem.product.id, -1),
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.surfaceVariant,
                    shape: const CircleBorder(),
                    minimumSize: const Size(36, 36),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    cartItem.quantity.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => onUpdateQuantity(cartItem.product.id, 1),
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.surfaceVariant,
                    shape: const CircleBorder(),
                    minimumSize: const Size(36, 36),
                  ),
                ),
              ],
            ),
            // Hapus
            IconButton(
              icon: const Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () => onRemoveFromCart(cartItem.product.id),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian checkout (UI saja)
  Widget _buildCheckoutSection(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: scheme.outlineVariant.withOpacity(.6)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total:",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      )),
              Text(
                "\$${_calculateTotal().toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Tombol visual (tanpa fungsi tambahan)
          Container(
            alignment: Alignment.center,
            height: 52,
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "Check Out",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
