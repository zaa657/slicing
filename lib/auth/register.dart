import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart';
import '../service/api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  bool get _valid =>
      _name.text.trim().isNotEmpty &&
      _email.text.contains('@') &&
      _password.text.length >= 8;

  @override
  void initState() {
    super.initState();
    _name.addListener(_refresh);
    _email.addListener(_refresh);
    _password.addListener(_refresh);
  }

  /// Pesan error dibersihkan begitu pengguna menyunting isian lagi.
  void _refresh() => setState(() => _error = null);

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiService.post('/auth/register', {
        'name': _name.text.trim(),
        'email': _email.text.trim(),
        'password': _password.text,
      });
      // Register langsung membalas token, jadi pengguna tidak perlu login lagi.
      await ApiService.saveToken(res['data']['token'].toString());
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainPage()),
        (route) => false,
      );
    } on ApiException catch (e) {
      // Mis. "Email sudah terdaftar" (409) — ditampilkan apa adanya.
      if (mounted) setState(() => _error = e.message);
    } on TimeoutException {
      if (mounted) {
        setState(() => _error = 'Server tidak merespons. Coba lagi.');
      }
    } catch (_) {
      // Umumnya koneksi ditolak: API-nya belum jalan di port 3000.
      if (mounted) {
        setState(() => _error = 'Tidak bisa terhubung ke server API.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AuthHeader(),
              const SizedBox(height: 40),
              AppTextField(
                label: 'Your full name',
                controller: _name,
                hint: 'Sigit H.P',
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Your email address',
                controller: _email,
                hint: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              AppTextField(
                label: 'Choose a password',
                controller: _password,
                hint: 'min. 8 characters',
                obscure: _obscure,
                suffix: IconButton(
                  iconSize: 16,
                  color: AppColors.muted,
                  icon: Icon(_obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 18),
                AuthMessage(message: _error!),
              ],
              const SizedBox(height: 22),
              PillButton(
                label: 'Create Account',
                loading: _loading,
                onTap: _valid ? _submit : null,
              ),
              const SizedBox(height: 20),
              const OrDivider(),
              const SizedBox(height: 20),
              const SocialButton(
                icon: Text(
                  'G',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4285F4),
                  ),
                ),
                label: 'Sign up with Google',
              ),
              const SizedBox(height: 12),
              const SocialButton(
                icon: Icon(Icons.apple, size: 17, color: AppColors.ink),
                label: 'Sign up with Apple',
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
