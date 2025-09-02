import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // Method untuk menampilkan dialog konfirmasi logout (Section 2.2.7)
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Hapus semua rute sebelumnya dan kembali ke halaman login
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (Route<dynamic> route) => false);

                // Menampilkan notifikasi bahwa logout berhasil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout successful!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Widget untuk Header Profil (Section 2.2.4)
  Widget _buildHeaderProfile() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade300, Colors.blue.shade800],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/profile.jpg'), // Ganti dengan path gambar Anda
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget reusable untuk item menu (Section 2.2.5)
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // Widget untuk bagian menu settings (Section 2.2.6)
  Widget _buildSettingSection() {
    return Column(
      children: [
        _buildSettingItem(
          icon: Icons.shopping_cart_outlined,
          title: 'My Cart',
          onTap: () => Navigator.pushNamed(context, '/cart'),
        ),
        _buildSettingItem(
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () {
            // Aksi untuk Profile
          },
        ),
        _buildSettingItem(
          icon: Icons.lock_outline,
          title: 'Change Password',
          onTap: () => Navigator.pushNamed(context, '/changePassword'),
        ),
        _buildSettingItem(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          onTap: () => Navigator.pushNamed(context, '/notifications'),
        ),
        _buildSettingItem(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () => Navigator.pushNamed(context, '/help'),
        ),
        _buildSettingItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: _showLogoutDialog, // Memanggil dialog logout
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Aksi untuk settings
            },
          ),
        ],
      ),
      // Gabungan semua komponen (Section 2.2.8)
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderProfile(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingSection(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}