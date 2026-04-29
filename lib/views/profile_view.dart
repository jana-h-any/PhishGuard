import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Consumer<AuthController>(builder: (context, auth, _) {
        final user = auth.user;
        return Padding(padding: const EdgeInsets.all(24), child: Column(children: [
          CircleAvatar(radius: 40, backgroundColor: AppConstants.primaryPurple.withOpacity(0.2),
            backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
            child: user?.photoUrl == null
                ? Text((user?.displayName ?? '?')[0].toUpperCase(), style: const TextStyle(fontSize: 28, color: AppConstants.primaryPurple))
                : null),
          const SizedBox(height: 16),
          Text(user?.displayName ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
          Text(user?.email ?? '', style: const TextStyle(color: AppConstants.textSecondary, fontSize: 14)),
          const SizedBox(height: 32),
          _buildSettingsItem(Icons.notifications_outlined, 'Notifications'),
          _buildSettingsItem(Icons.security, 'Privacy & Security'),
          _buildSettingsItem(Icons.help_outline, 'Help & Support'),
          _buildSettingsItem(Icons.info_outline, 'About'),
          const Spacer(),
          SizedBox(width: double.infinity, child: OutlinedButton(
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
            style: OutlinedButton.styleFrom(foregroundColor: AppConstants.phishingRed,
                side: const BorderSide(color: AppConstants.phishingRed), padding: const EdgeInsets.symmetric(vertical: 14)),
            child: const Text('Sign Out'),
          )),
        ]));
      }),
    );
  }

  static Widget _buildSettingsItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: AppConstants.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppConstants.borderColor)),
      child: ListTile(
        leading: Icon(icon, color: AppConstants.primaryPurple),
        title: Text(title, style: const TextStyle(color: AppConstants.textPrimary, fontSize: 14)),
        trailing: const Icon(Icons.chevron_right, color: AppConstants.textSecondary),
      ),
    );
  }
}
