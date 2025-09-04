import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // ─────────────────────────── Utils ───────────────────────────
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        final scheme = Theme.of(ctx).colorScheme;
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Yakin ingin keluar dari akun ini?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: FilledButton.styleFrom(
                backgroundColor: scheme.error,
                foregroundColor: scheme.onError,
              ),
              onPressed: () {
                // Tutup dialog dulu → beri feedback → lalu navigasi
                Navigator.of(ctx).pop();
                final messenger = ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Logout berhasil!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                Future.delayed(const Duration(milliseconds: 400), () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  // ──────────────────────── Header Profile ────────────────────────
  Widget _buildHeaderProfile() {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primaryContainer, scheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: const AssetImage('assets/images/poto.jpg'),
                backgroundColor: scheme.onPrimaryContainer.withOpacity(.15),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'john.doe@example.com',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: scheme.onPrimaryContainer.withOpacity(.8),
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: scheme.onPrimaryContainer,
                            side: BorderSide(
                              color:
                                  scheme.onPrimaryContainer.withOpacity(.25),
                            ),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: () {
                            // TODO: arahkan ke halaman edit profil
                          },
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Edit Profil'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          icon: const Icon(Icons.qr_code_2, size: 18),
                          label: const Text('My QR'),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────── Setting Tile ─────────────────────────
  Widget _settingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? tint,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final tileTint = tint ?? scheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: ListTile(
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: tileTint.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: tileTint, size: 22),
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: subtitle != null ? Text(subtitle) : null,
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }

  // ──────────────────────── Section List ─────────────────────────
  Widget _buildSettingSection() {
    return Column(
      children: [
        _settingTile(
          icon: Icons.shopping_cart_outlined,
          title: 'My Cart',
          onTap: () => Navigator.pushNamed(context, '/cart'),
        ),
        _settingTile(
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () => Navigator.pushNamed(context, '/profile'),
        ),
        _settingTile(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => Navigator.pushNamed(context, '/changePassword'),
        ),
        _settingTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'On • Push & Email',
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        _settingTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () => Navigator.pushNamed(context, '/help'),
        ),
        _settingTile(
          icon: Icons.logout,
          title: 'Logout',
          tint: Colors.red,
          onTap: _showLogoutDialog,
        ),
      ],
    );
  }

  // ────────────────────────── Build ──────────────────────────────
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderProfile(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pengaturan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildSettingSection(),
                  const SizedBox(height: 16),
                  Text(
                    'versi 1.0.0',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: scheme.outline),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
