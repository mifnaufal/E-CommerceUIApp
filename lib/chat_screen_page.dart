import 'package:flutter/material.dart';

class ChatScreenPage extends StatefulWidget {
  final String contactName;

  const ChatScreenPage({super.key, required this.contactName});

  @override
  State<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  final _listCtrl = ScrollController();
  final TextEditingController _textController = TextEditingController();

  // Contoh data awal
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'other', 'text': 'Halo, ada yang bisa dibantu?', 'time': DateTime.now().subtract(const Duration(minutes: 7))},
    {'sender': 'user',  'text': 'Ya, saya mau tanya tentang produk A.', 'time': DateTime.now().subtract(const Duration(minutes: 5))},
    {'sender': 'other', 'text': 'Tentu, produk A masih tersedia. Silakan.', 'time': DateTime.now().subtract(const Duration(minutes: 4))},
  ];

  @override
  void initState() {
    super.initState();
    // Scroll ke bawah setelah layout pertama
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(jump: true));
  }

  @override
  void dispose() {
    _listCtrl.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool jump = false}) {
    if (!_listCtrl.hasClients) return;
    if (jump) {
      _listCtrl.jumpTo(_listCtrl.position.maxScrollExtent);
    } else {
      _listCtrl.animateTo(
        _listCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'sender': 'user', 'text': text, 'time': DateTime.now()});
      _textController.clear();
    });
    // Pastikan ke pesan paling bawah
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  String _formatTime(DateTime t) {
    final hh = t.hour.toString().padLeft(2, '0');
    final mm = t.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
    // (kalau mau, ganti ke intl DateFormat('HH:mm'))
  }

  Widget _buildChatBubble(BuildContext context, Map<String, dynamic> message) {
    final scheme = Theme.of(context).colorScheme;
    final isUser = message['sender'] == 'user';
    final bubbleColor = isUser ? scheme.primary : scheme.surfaceVariant;
    final textColor = isUser ? scheme.onPrimary : scheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                ),
                child: Text(
                  message['text'] as String,
                  style: TextStyle(color: textColor, height: 1.25),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message['time'] as DateTime),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Column(
        children: [
          // Area Pesan
          Expanded(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView.builder(
                controller: _listCtrl,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildChatBubble(context, _messages[index]);
                },
              ),
            ),
          ),
          // Area Input
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Lampirkan',
                    onPressed: () {
                      // UI only
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lampiran belum diimplementasikan')),
                      );
                    },
                    icon: const Icon(Icons.attach_file),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan…',
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _textController.text.trim().isEmpty ? null : _sendMessage,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: scheme.surface,
    );
  }
}
