import 'package:flutter/material.dart';

class CartBottomNavBar extends StatelessWidget {
  const CartBottomNavBar({
    super.key,
    required this.total,
    required this.onCheckout,
    this.currencySymbol = 'Rp',
    this.buttonLabel = 'Check Out',
    this.isLoading = false,
    this.enabled = true,
    this.note,
  });

  /// Total harga cart
  final num total;

  /// Simbol currency (default: 'Rp', bisa ganti ke '$', 'IDR', dll)
  final String currencySymbol;

  /// Handler saat tombol checkout ditekan
  final VoidCallback onCheckout;

  /// Teks tombol
  final String buttonLabel;

  /// State loading tombol
  final bool isLoading;

  /// Aktif/nonaktif tombol
  final bool enabled;

  /// Catatan kecil di bawah total (opsional), mis. "Termasuk PPN"
  final String? note;

  String _formatCurrency(num value) {
    // Format sederhana: 1500000 -> "Rp 1.500.000"
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    var count = 0;
    for (var i = s.length - 1; i >= 0; i--) {
      buf.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buf.write('.');
        count = 0;
      }
    }
    final rev = buf.toString().split('').reversed.join();
    return '$currencySymbol $rev';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BottomAppBar(
      color: Theme.of(context).bottomAppBarTheme.color ?? scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(.12),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Text(
                  _formatCurrency(total),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
            if (note != null) ...[
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  note!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
            const SizedBox(height: 12),
            // Tombol checkout
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: (enabled && !isLoading) ? onCheckout : null,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        buttonLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
