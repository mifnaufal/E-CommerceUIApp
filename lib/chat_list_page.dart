import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<Map<String, dynamic>> _chatData = [
    {
      "name": "Admin Official",
      "message": "Halo, selamat datang di toko kami!",
      "time": "10:30 AM",
      "unread": 2,
      "avatar": "assets/images/carts/1.png"
    },
    {
      "name": "John Doe",
      "message": "Apakah produk ini masih tersedia?",
      "time": "09:45 AM",
      "unread": 0,
      "avatar": "assets/images/carts/2.png"
    },
    {
      "name": "Jane Smith",
      "message": "Terima kasih atas bantuannya.",
      "time": "Kemarin",
      "unread": 1,
      "avatar": "assets/images/carts/3.png"
    },
    {
      "name": "Customer Service",
      "message": "Ada yang bisa kami bantu?",
      "time": "2 hari lalu",
      "unread": 0,
      "avatar": "assets/images/carts/4.png"
    },
  ];

  String _selectedFilter = "Semua";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesan", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
        elevation: 1,
      ),
      body: Column(
        children: [
          // Tombol Filter
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["Semua", "Belum Dibaca", "Toko", "Pembeli"].map((filter) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedFilter = filter;
                          }
                        });
                      },
                      selectedColor: Colors.blue.shade100,
                      labelStyle: TextStyle(
                          color: _selectedFilter == filter
                              ? Colors.blue.shade800
                              : Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          // Daftar Chat
          Expanded(
            child: ListView.builder(
              itemCount: _chatData.length,
              itemBuilder: (context, index) {
                final chat = _chatData[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/chatscreen',
                        arguments: {'contactName': chat['name']});
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(chat['avatar']),
                      radius: 25,
                    ),
                    title: Text(chat['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      chat['message'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(chat['time'], style: const TextStyle(fontSize: 12)),
                        if (chat['unread'] > 0)
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              chat['unread'].toString(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )
                        else
                          const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}