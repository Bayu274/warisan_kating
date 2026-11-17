import 'package:flutter/material.dart';

/// Placeholder profile screen — ready for Sprint 2 auth integration.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 48, color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              Text(
                'Belum masuk',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login untuk melihat profil, riwayat, dan pengaturan.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  // TODO: navigate to login screen
                },
                icon: const Icon(Icons.login),
                label: const Text('Masuk / Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
