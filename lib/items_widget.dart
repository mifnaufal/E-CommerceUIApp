// lib/items_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({
    super.key,
    this.onAddToCart, // opsional; biar gak error walau belum di-wire
  });

  /// Callback opsional saat tombol cart ditekan.
  /// Terima index item (0-based) agar mudah di-handle oleh parent.
  final void Function(int index)? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .72,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 7, // asset 1.jpeg .. 7.jpeg
      itemBuilder: (context, idx) {
        final i = idx + 1;
        final title = 'Product Title $i';
        final price = 45 + (i * 5); // contoh harga
        final rating = 3.5 + (i % 2); // contoh rating 3.5 atau 4.5

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // UI only: buka detail (simulasi)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Buka detail: $title (simulasi)')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge & favorit
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
                            SnackBar(content: Text('$title ditandai (simulasi)')),
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
                          'assets/images/carts/$i.jpeg',
                          height: 120,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            color: scheme.surfaceVariant,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),

                  const SizedBox(height: 2),

                  // Deskripsi
                  Text(
                    'Write description of product',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),

                  const SizedBox(height: 6),

                  // Rating (read-only)
                  RatingBarIndicator(
                    rating: rating.clamp(0, 5).toDouble(),
                    itemSize: 16,
                    unratedColor: scheme.outlineVariant,
                    itemBuilder: (_, __) => Icon(Icons.star_rounded, color: scheme.tertiary),
                  ),

                  const SizedBox(height: 6),

                  // Harga + tombol cart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$price',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Tambah ke keranjang',
                        onPressed: () {
                          if (onAddToCart != null) {
                            onAddToCart!(idx);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title ditambahkan ke keranjang! (demo)'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
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
