import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // type: 'Toko' atau 'Pembeli' biar filter jalan
  final List<Map<String, dynamic>> _chatData = [
    {
      "name": "Admin Official",
      "message": "Halo, selamat datang di toko kami!",
      "time": "10:30 AM",
      "unread": 2,
      "avatar": "assets/images/carts/1.png",
      "type": "Toko",
    },
    {
      "name": "John Doe",
      "message": "Apakah produk ini masih tersedia?",
      "time": "09:45 AM",
      "unread": 0,
      "avatar": "assets/images/carts/2.png",
      "type": "Pembeli",
    },
    {
      "name": "Jane Smith",
      "message": "Terima kasih atas bantuannya.",
      "time": "Kemarin",
      "unread": 1,
      "avatar": "assets/images/carts/3.png",
      "type": "Pembeli",
    },
    {
      "name": "Customer Service",
      "message": "Ada yang bisa kami bantu?",
      "time": "2 hari lalu",
      "unread": 0,
      "avatar": "assets/images/carts/4.png",
      "type": "Toko",
    },
  ];

  String _selectedFilter = "Semua"; // Semua | Belum Dibaca | Toko | Pembeli
  String _query = "";

  List<Map<String, dynamic>> get _filteredChats {
    return _chatData.where((c) {
      final byFilter = switch (_selectedFilter) {
        "Semua" => true,
        "Belum Dibaca" => (c["unread"] as int) > 0,
        "Toko" => c["type"] == "Toko",
        "Pembeli" => c["type"] == "Pembeli",
        _ => true,
      };
      final byQuery = _query.isEmpty
          ? true
          : (c["name"] as String).toLowerCase().contains(_query.toLowerCase()) ||
              (c["message"] as String).toLowerCase().contains(_query.toLowerCase());
      return byFilter && byQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pesan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari nama atau pesan…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                isDense: true,
              ),
            ),
          ),

          // Filter chips
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Semua", "Belum Dibaca", "Toko", "Pembeli"].map((filter) {
                  final selected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: selected,
                      onSelected: (s) => setState(() {
                        if (s) _selectedFilter = filter;
                      }),
                      selectedColor: scheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: selected ? scheme.onPrimaryContainer : null,
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Daftar chat + pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // UI only: simulasi refresh sebentar
                await Future.delayed(const Duration(milliseconds: 700));
                if (mounted) setState(() {});
              },
              child: _filteredChats.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 80),
                        Icon(Icons.chat_bubble_outline,
                            size: 64, color: scheme.onSurfaceVariant),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Tidak ada chat',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            'Coba ubah filter atau pencarian.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 12),
                      itemCount: _filteredChats.length,
                      separatorBuilder: (_, __) => const Divider(height: 0),
                      itemBuilder: (context, index) {
                        final chat = _filteredChats[index];
                        return Dismissible(
                          key: ValueKey('${chat["name"]}-$index'),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.red,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (_) async {
                            // UI only: hapus item lokal
                            setState(() {
                              _chatData.remove(chat);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Chat "${chat["name"]}" dihapus')),
                            );
                            return false; // return false agar animasi snap-back (tidak permanen)
                          },
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/chatscreen',
                                arguments: {'contactName': chat['name']},
                              );
                            },
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              leading: _Avatar(path: chat['avatar'], unread: chat['unread']),
                              title: Text(
                                chat['name'],
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                chat['message'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    chat['time'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(color: scheme.onSurfaceVariant),
                                  ),
                                  const SizedBox(height: 6),
                                  if ((chat['unread'] as int) > 0)
                                    Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: scheme.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${chat['unread']}',
                                        style: TextStyle(
                                          color: scheme.onPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  else
                                    const SizedBox(height: 18),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// Avatar dengan fallback & indikator unread kecil
class _Avatar extends StatelessWidget {
  const _Avatar({required this.path, required this.unread});
  final String path;
  final int unread;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: Image.asset(
            path,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 48,
              height: 48,
              color: scheme.surfaceVariant,
              alignment: Alignment.center,
              child: Icon(Icons.person_outline, color: scheme.onSurfaceVariant),
            ),
          ),
        ),
        if (unread > 0)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
              ),
              child: SizedBox(
                width: 0,
                height: 0,
                // titik kecil saja; badge angka ada di trailing
              ),
            ),
          ),
      ],
    );
  }
}
