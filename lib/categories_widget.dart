import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String assetPath;
  const Category({
    required this.id,
    required this.name,
    required this.assetPath,
  });
}

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({
    super.key,
    this.categories,
    this.initialSelectedId,
    this.onSelected,
    this.height = 84,
    this.itemSpacing = 10,
  });

  /// Kalau null, widget akan pakai default:
  /// [Sandal (9.jpeg), 1.jpeg..8.jpeg]
  final List<Category>? categories;

  /// ID kategori yang dipilih awal (opsional)
  final int? initialSelectedId;

  /// Callback saat user memilih kategori (opsional)
  final ValueChanged<Category>? onSelected;

  /// Tinggi baris kategori
  final double height;

  /// Spasi antar item
  final double itemSpacing;

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late final List<Category> _items;
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _items = widget.categories ?? _buildDefaultItems();
    _selectedId = widget.initialSelectedId ?? (_items.isNotEmpty ? _items.first.id : null);
  }

  List<Category> _buildDefaultItems() {
    // Urutan: Sandal (9.jpeg) dulu, lalu 1..8.jpeg
    const sandal = Category(
      id: 9,
      name: 'Sandal',
      assetPath: 'assets/images/carts/9.jpeg',
    );

    final others = <Category>[
      for (int i = 1; i <= 8; i++)
        Category(
          id: i,
          name: 'Category $i',
          assetPath: 'assets/images/carts/$i.jpeg',
        ),
    ];

    return [sandal, ...others];
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, __) => SizedBox(width: widget.itemSpacing),
        itemBuilder: (context, index) {
          final cat = _items[index];
          final selected = cat.id == _selectedId;

          final bg = selected
              ? scheme.primaryContainer
              : Theme.of(context).cardColor;

          final borderColor = selected
              ? scheme.primary
              : scheme.outlineVariant.withOpacity(.7);

          final textColor = selected
              ? scheme.onPrimaryContainer
              : Theme.of(context).textTheme.bodyMedium?.color;

          return Semantics(
            button: true,
            selected: selected,
            label: 'Kategori ${cat.name}',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  setState(() => _selectedId = cat.id);
                  widget.onSelected?.call(cat);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: scheme.primary.withOpacity(.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gambar kategori (dengan fallback)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          cat.assetPath,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            color: scheme.surfaceVariant.withOpacity(.6),
                            child: Icon(Icons.image_not_supported_outlined,
                                size: 22, color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        cat.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle,
                            size: 18, color: scheme.primary),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
