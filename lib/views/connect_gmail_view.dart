import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../utils/constants.dart';

class ConnectGmailView extends StatelessWidget {
  const ConnectGmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Connect Gmail'),
      ),
      body: Consumer<AuthController>(
        builder: (context, auth, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Securely connect your Gmail account\nto scan your emails automatically.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppConstants.cardDark,
                        border: Border.all(color: AppConstants.borderColor),
                      ),
                      child: const Icon(
                        Icons.mail,
                        size: 60,
                        color: AppConstants.primaryPurple,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildFeatureRow(
                      Icons.lock_outline,
                      'Read your emails securely',
                      'We only read emails to analyze them for phishing.',
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureRow(
                      Icons.privacy_tip_outlined,
                      'Your data is private',
                      'We never store your emails or share your data.',
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureRow(
                      Icons.tune,
                      "You're in control",
                      'You can disconnect anytime.',
                    ),
                    const SizedBox(height: 40),
                    // Connect button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: auth.isLoading
                            ? null
                            : () async {
                                final success = await auth.signInWithGoogle();
                                if (success && context.mounted) {
                                  Navigator.pushReplacementNamed(
                                      context, '/home');
                                }
                              },
                        icon: auth.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.g_mobiledata, size: 28),
                        label: Text(auth.isLoading
                            ? 'Connecting...'
                            : 'Connect with Google'),
                      ),
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        auth.error!,
                        style: const TextStyle(
                          color: AppConstants.phishingRed,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Widget _buildFeatureRow(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppConstants.cardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppConstants.primaryPurple, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppConstants.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
