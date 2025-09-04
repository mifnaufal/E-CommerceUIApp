import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // --- Password checks
  bool get _lenOK => _newCtrl.text.length >= 8;
  bool get _hasUpper => RegExp(r'[A-Z]').hasMatch(_newCtrl.text);
  bool get _hasLower => RegExp(r'[a-z]').hasMatch(_newCtrl.text);
  bool get _hasDigit => RegExp(r'\d').hasMatch(_newCtrl.text);
  bool get _hasSpecial => RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-\\/\[\];+=~`]').hasMatch(_newCtrl.text);

  double _strength() {
    int s = 0;
    if (_lenOK) s++;
    if (_hasUpper) s++;
    if (_hasLower) s++;
    if (_hasDigit) s++;
    if (_hasSpecial) s++;
    return s / 5.0;
  }

  Color _strengthColor(ColorScheme scheme) {
    final s = _strength();
    if (s < .4) return scheme.error;
    if (s < .7) return scheme.tertiary;
    return scheme.primary;
  }

  String _strengthLabel() {
    final s = _strength();
    if (s < .4) return 'Lemah';
    if (s < .7) return 'Sedang';
    return 'Kuat';
  }

  /// Jangan panggil `validate()` di build — cukup cek isian.
  bool get _canSubmit {
    final currentOK = _currentCtrl.text.isNotEmpty && _currentCtrl.text.length >= 4;
    final newOK = _lenOK && _hasUpper && _hasLower && _hasDigit && _hasSpecial;
    final confirmOK = _confirmCtrl.text.isNotEmpty && _confirmCtrl.text == _newCtrl.text;
    return currentOK && newOK && confirmOK;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.lock_reset, color: scheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Buat kata sandi yang kuat minimal 8 karakter. '
                            'Campurkan huruf besar, huruf kecil, angka, dan simbol.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _currentCtrl,
                  obscureText: !_showCurrent,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password saat ini',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _showCurrent = !_showCurrent),
                      icon: Icon(_showCurrent ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Wajib diisi';
                    if (v.length < 4) return 'Terlalu pendek';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _newCtrl,
                  obscureText: !_showNew,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Password baru',
                    prefixIcon: const Icon(Icons.key_outlined),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _showNew = !_showNew),
                      icon: Icon(_showNew ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Wajib diisi';
                    if (!_lenOK) return 'Minimal 8 karakter';
                    if (!(_hasUpper && _hasLower)) return 'Wajib ada huruf besar & kecil';
                    if (!_hasDigit) return 'Wajib ada angka';
                    if (!_hasSpecial) return 'Wajib ada simbol';
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: _strength().clamp(0, 1),
                          color: _strengthColor(scheme),
                          backgroundColor: scheme.surfaceVariant.withOpacity(.6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _strengthLabel(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _strengthColor(scheme),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _ReqChip('≥ 8 karakter', _lenOK),
                    _ReqChip('Huruf besar', _hasUpper),
                    _ReqChip('Huruf kecil', _hasLower),
                    _ReqChip('Angka', _hasDigit),
                    _ReqChip('Simbol', _hasSpecial),
                  ],
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: !_showConfirm,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi password baru',
                    prefixIcon: const Icon(Icons.check_circle_outline),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _showConfirm = !_showConfirm),
                      icon: Icon(_showConfirm ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Wajib diisi';
                    if (v != _newCtrl.text) return 'Tidak cocok dengan password baru';
                    return null;
                  },
                  onFieldSubmitted: (_) => _submit(context),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _canSubmit ? () => _submit(context) : null,
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur lupa password belum diimplementasikan')),
                      );
                    },
                    child: const Text('Lupa password?'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    // Aman: pakai ?. supaya tidak crash kalau (sangat jarang) state belum ada
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password berhasil diperbarui')),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.of(context).maybePop();
    });
  }
}

class _ReqChip extends StatelessWidget {
  const _ReqChip(this.label, this.ok);
  final String label;
  final bool ok;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = ok ? scheme.primary : scheme.outline;
    final bg = ok ? scheme.primaryContainer : scheme.surfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ok ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ok ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                  fontWeight: ok ? FontWeight.w700 : FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
