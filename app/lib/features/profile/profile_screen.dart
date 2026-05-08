import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../shared/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Goal settings', Icons.flag_rounded),
      ('Notifications', Icons.notifications_rounded),
      ('Theme and accent', Icons.palette_rounded),
      ('Connected apps', Icons.watch_rounded),
      ('Subscription', Icons.workspace_premium_rounded),
      ('Export data', Icons.file_download_rounded),
      ('Privacy and deletion', Icons.lock_rounded),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
        children: [
          const GlassCard(
            child: Row(
              children: [
                CircleAvatar(radius: 32, child: Icon(Icons.person_rounded)),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Yogesh', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                      Text('High protein • Indian diet • Premium'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GlassCard(
            child: Column(
              children: [
                for (final item in items)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(item.$2),
                    title: Text(item.$1),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () => Supabase.instance.client.auth.signOut(),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
