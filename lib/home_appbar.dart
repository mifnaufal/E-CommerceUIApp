import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    this.title = 'DP Shop',
    this.cartCount = 0,
    this.onMenuTap,
    this.onSearchTap,
    this.onCartTap,
  });

  final String title;
  final int cartCount;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onCartTap;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
          Theme.of(context).appBarTheme.backgroundColor ?? scheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      leadingWidth: 64,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton.filledTonal(
          style: IconButton.styleFrom(shape: const CircleBorder()),
          onPressed: onMenuTap, // biar fleksibel; pasang callback dari luar
          icon: const Icon(Icons.menu),
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
        IconButton(
          tooltip: 'Cari',
          onPressed: onSearchTap,
          icon: const Icon(Icons.search),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: badges.Badge(
            showBadge: cartCount > 0,
            badgeContent: Text(
              '$cartCount',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: scheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            ),
            child: IconButton(
              tooltip: 'Keranjang',
              onPressed: onCartTap ??
                  () {
                    // default: navigasi ke /cart jika ada route
                    Navigator.pushNamed(context, '/cart');
                  },
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ),
      ],
    );
  }
}
