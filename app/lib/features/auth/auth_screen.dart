import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/widgets/glass_card.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _password.text,
      );
      if (mounted) context.go('/');
    } catch (_) {
      if (mounted) context.go('/onboarding');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _biometric() async {
    final auth = LocalAuthentication();
    final ok = await auth.authenticate(localizedReason: 'Unlock Aura Diet');
    if (ok && mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 44),
            Text('Aura Diet', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            Text('Daily nutrition, made calm.', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 36),
            GlassCard(
              child: Column(
                children: [
                  TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email')),
                  const SizedBox(height: 14),
                  TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: _loading ? null : _signIn,
                    child: Text(_loading ? 'Signing in...' : 'Continue'),
                  ),
                  TextButton(onPressed: () {}, child: const Text('Forgot password')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.g_mobiledata), label: const Text('Continue with Google')),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.apple), label: const Text('Continue with Apple')),
            TextButton.icon(onPressed: _biometric, icon: const Icon(Icons.fingerprint), label: const Text('Use biometrics')),
          ],
        ),
      ),
    );
  }
}
