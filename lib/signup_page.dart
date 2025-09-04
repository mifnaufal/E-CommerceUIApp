import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();

  // Focus
  final _nameF = FocusNode();
  final _emailF = FocusNode();
  final _passF = FocusNode();
  final _confirmF = FocusNode();

  bool _isLoading = false;
  bool _showPass = false;
  bool _showConfirm = false;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    _confirmC.dispose();
    _nameF.dispose();
    _emailF.dispose();
    _passF.dispose();
    _confirmF.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final form = _formKey.currentState;
    if (form == null) return;
    if (!form.validate()) return;

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamu harus menyetujui Syarat & Kebijakan.')),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      // TODO: ganti dengan call auth beneran (Firebase/REST)
      await Future<void>.delayed(const Duration(milliseconds: 800));

      if (!mounted) return;
      // contoh sukses → ke home
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftar: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email tidak boleh kosong';
    final email = v.trim();
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!re.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
    if (v.length < 8) return 'Minimal 8 karakter';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth > 520 ? 480.0 : double.infinity;
                  return ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            const Text('Create Account',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Daftar untuk mulai belanja',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                            const SizedBox(height: 32),

                            // Name
                            TextFormField(
                              controller: _nameC,
                              focusNode: _nameF,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.name],
                              decoration: InputDecoration(
                                labelText: 'Nama lengkap',
                                prefixIcon: const Icon(Icons.person_outline),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong';
                                if (v.trim().length < 3) return 'Nama terlalu pendek';
                                return null;
                              },
                              onFieldSubmitted: (_) => _emailF.requestFocus(),
                            ),
                            const SizedBox(height: 16),

                            // Email
                            TextFormField(
                              controller: _emailC,
                              focusNode: _emailF,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email, AutofillHints.username],
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email_outlined),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: _validateEmail,
                              onFieldSubmitted: (_) => _passF.requestFocus(),
                            ),
                            const SizedBox(height: 16),

                            // Password
                            TextFormField(
                              controller: _passC,
                              focusNode: _passF,
                              obscureText: !_showPass,
                              obscuringCharacter: '•',
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.newPassword],
                              autocorrect: false,
                              enableSuggestions: false,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                helperText: 'Minimal 8 karakter. Disarankan campur huruf & angka.',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _showPass ? 'Sembunyikan' : 'Tampilkan',
                                  icon: Icon(_showPass ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _showPass = !_showPass),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: _validatePassword,
                              onFieldSubmitted: (_) => _confirmF.requestFocus(),
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password
                            TextFormField(
                              controller: _confirmC,
                              focusNode: _confirmF,
                              obscureText: !_showConfirm,
                              obscuringCharacter: '•',
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                labelText: 'Konfirmasi password',
                                prefixIcon: const Icon(Icons.lock_reset_outlined),
                                suffixIcon: IconButton(
                                  tooltip: _showConfirm ? 'Sembunyikan' : 'Tampilkan',
                                  icon: Icon(_showConfirm ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () => setState(() => _showConfirm = !_showConfirm),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Konfirmasi tidak boleh kosong';
                                if (v != _passC.text) return 'Password tidak sama';
                                return null;
                              },
                              onFieldSubmitted: (_) => _handleSignUp(),
                            ),
                            const SizedBox(height: 8),

                            // Terms
                            CheckboxListTile(
                              value: _agreeTerms,
                              onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Saya setuju dengan Syarat & Kebijakan Privasi'),
                            ),
                            const SizedBox(height: 8),

                            // Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Text('Buat Akun', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Link ke Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Sudah punya akun?'),
                                TextButton(
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      // fallback bila tidak ada history
                                      Navigator.pushReplacementNamed(context, '/login');
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
