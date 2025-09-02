import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (Route<dynamic> route) => false);
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              // PASTIKAN NAMA FILE GAMBAR PROFIL ANDA BENAR DI SINI
              backgroundImage: AssetImage('assets/images/poto.jpg'),
            ),
            const SizedBox(width: 20),
            const Column(
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
          onTap: () {},
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
          onTap: _showLogoutDialog,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // AppBar tidak diperlukan jika halaman ini bagian dari MainScreen
      // Namun jika diakses terpisah, AppBar bisa ditambahkan kembali.
      // appBar: AppBar( ... ), 
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