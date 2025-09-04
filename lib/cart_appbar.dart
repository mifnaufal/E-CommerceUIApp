import 'package:flutter/material.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CartAppBar({
    super.key,
    this.title = 'Cart',
    this.itemCount,
    this.onBack,
    this.onClear,
  });

  final String title;
  final int? itemCount;
  final VoidCallback? onBack;
  final VoidCallback? onClear;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      centerTitle: true,
      // Flat & clean, ikuti warna surface dari theme
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? scheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      // Rounded bawah biar lebih modern
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      // Tombol back dalam kapsul tonal
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton.filledTonal(
          style: IconButton.styleFrom(shape: const CircleBorder()),
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.w800),
      ),
      actions: [
        // Badge item count (opsional)
        if (itemCount != null)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Badge(
              backgroundColor: scheme.primary,
              textColor: scheme.onPrimary,
              label: Text('$itemCount'),
              child: IconButton(
                onPressed: () {
                  // Arahkan ke halaman cart detail jika berbeda
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
            ),
          ),
        PopupMenuButton<String>(
          tooltip: 'More',
          itemBuilder: (ctx) => [
            const PopupMenuItem(value: 'help', child: Text('Help')),
            const PopupMenuItem(value: 'select_all', child: Text('Select all')),
            const PopupMenuItem(value: 'clear', child: Text('Clear cart')),
          ],
          onSelected: (v) {
            switch (v) {
              case 'clear':
                if (onClear != null) {
                  onClear!();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nothing to clear')),
                  );
                }
                break;
              case 'help':
                // TODO: buka help
                break;
              case 'select_all':
                // TODO: select all
                break;
            }
          },
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
