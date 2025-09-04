import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _searchCtrl = TextEditingController();

  final List<_Faq> _faqs = const [
    _Faq(
      'Bagaimana cara melacak pesanan?',
      'Buka menu Pesanan → pilih pesanan → ketuk Lacak untuk melihat status terbaru.',
    ),
    _Faq(
      'Metode pembayaran apa saja yang didukung?',
      'Kami mendukung kartu debit/kredit, transfer bank, dan e-wallet tertentu (OVO/DANA/GoPay).',
    ),
    _Faq(
      'Bagaimana jika barang belum diterima?',
      'Periksa status pengiriman terlebih dahulu. Jika melebihi estimasi, hubungi CS dengan menyertakan nomor pesanan.',
    ),
    _Faq(
      'Bagaimana cara mengembalikan barang?',
      'Ajukan permohonan retur pada detail pesanan dalam 7 hari setelah barang diterima dan ikuti instruksi pengembalian.',
    ),
  ];

  List<_Faq> get _filteredFaqs {
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return _faqs;
    return _faqs
        .where((f) => f.q.toLowerCase().contains(q) || f.a.toLowerCase().contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _openReportSheet() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final insets = MediaQuery.of(ctx).viewInsets;
        return Padding(
          padding: EdgeInsets.only(bottom: insets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Laporkan Masalah',
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Judul masalah',
                      prefixIcon: Icon(Icons.flag_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Deskripsi',
                      hintText: 'Jelaskan apa yang terjadi…',
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                    maxLines: 5,
                    validator: (v) => (v == null || v.length < 10) ? 'Minimal 10 karakter' : null,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      Navigator.of(ctx).pop();
                      _snack(context, 'Laporan dikirim (simulasi)');
                      titleCtrl.dispose();
                      descCtrl.dispose();
                    },
                    child: const Text('Kirim Laporan'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        centerTitle: true,
        scrolledUnderElevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          children: [
            // Search
            TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari bantuan atau FAQ…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            // Quick actions
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.support_agent,
                    title: 'Kontak CS',
                    subtitle: '08.00–20.00',
                    onTap: () => _snack(context, 'Membuka kontak CS (simulasi)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.chat_bubble_outline,
                    title: 'Live Chat',
                    subtitle: 'Balasan cepat',
                    onTap: () => _snack(context, 'Memulai live chat (simulasi)'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _QuickActionCard(
                    icon: Icons.report_gmailerrorred_outlined,
                    title: 'Laporan',
                    subtitle: 'Bug/masalah',
                    onTap: _openReportSheet,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Kontak lain
            Text('Kontak Kami',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 8),
            _ContactTile(
              icon: Icons.email_outlined,
              title: 'Email',
              value: 'support@tokomu.com',
              actionLabel: 'Salin',
              onTap: () => _snack(context, 'Email disalin: support@tokomu.com'),
            ),
            _ContactTile(
              icon: Icons.phone_outlined,
              title: 'Telepon',
              value: '0800-123-456',
              actionLabel: 'Panggil',
              onTap: () => _snack(context, 'Memanggil 0800-123-456 (simulasi)'),
            ),
            // ganti blok WhatsApp ini
_ContactTile(
  icon: Icons.chat_bubble_outline, // <— was Icons.whatsapp (tidak ada)
  title: 'WhatsApp',
  value: '+62 812-3456-7890',
  actionLabel: 'Buka',
  onTap: () => _snack(context, 'Membuka WhatsApp (simulasi)'),
),


            const SizedBox(height: 16),

            // FAQ
            Text('FAQ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 8),
            ..._filteredFaqs.map((f) => _FaqTile(f)).toList(),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, size: 26, color: scheme.primary),
              const SizedBox(height: 8),
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundColor: scheme.primaryContainer,
          child: Icon(icon, color: scheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(value),
        trailing: FilledButton.tonal(
          onPressed: onTap,
          child: Text(actionLabel),
        ),
      ),
    );
  }
}

class _Faq {
  final String q;
  final String a;
  const _Faq(this.q, this.a);
}

class _FaqTile extends StatelessWidget {
  final _Faq faq;
  const _FaqTile(this.faq);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          collapsedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: Text(
            faq.q,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          iconColor: scheme.primary,
          collapsedIconColor: scheme.primary,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                faq.a,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(height: 1.35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
