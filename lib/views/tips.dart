import 'package:flutter/material.dart';
import '../utils/constants.dart';

class TipsView extends StatelessWidget {
  const TipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Already Clicked?'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.phishingRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.phishingRed.withOpacity(0.3)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppConstants.phishingRed, size: 48),
                  SizedBox(height: 8),
                  Text('Don\'t Panic — Act Fast',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.phishingRed)),
                  SizedBox(height: 4),
                  Text('Follow these steps to protect your data',
                      style: TextStyle(fontSize: 14, color: AppConstants.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Section 1: Immediate Actions
            _buildSectionHeader('Immediate Actions', 'First 0–60 Minutes', AppConstants.phishingRed),
            const SizedBox(height: 12),
            _buildTipCard(
              Icons.wifi_off,
              'Disconnect Your Device',
              'Disconnect from Wi-Fi or unplug ethernet to stop potential data exfiltration or malware spread.',
            ),
            _buildTipCard(
              Icons.lock_reset,
              'Change Passwords',
              'Immediately change passwords for any account you suspect was compromised. If you used the same password elsewhere, change it there too.',
            ),
            _buildTipCard(
              Icons.security,
              'Enable MFA/2FA',
              'Turn on multi-factor authentication for the affected accounts to prevent future unauthorized access.',
            ),
            _buildTipCard(
              Icons.account_balance,
              'Notify Institutions',
              'If you entered credit card or bank details, contact your bank or credit card company immediately.',
            ),
            const SizedBox(height: 24),

            // Section 2: Securing Device
            _buildSectionHeader('Securing Your Device', 'Protect Your Information', AppConstants.mediumOrange),
            const SizedBox(height: 12),
            _buildTipCard(
              Icons.shield_outlined,
              'Scan for Malware',
              'Use reputable anti-virus software to scan your device. If heavily infected, use a clean machine to download security tools to a USB drive.',
            ),
            _buildTipCard(
              Icons.manage_accounts,
              'Review Account Activity',
              'Check email settings for unauthorized forwarding rules. Review financial statements for unauthorized transactions.',
            ),
            _buildTipCard(
              Icons.system_update,
              'Update Software',
              'Ensure your operating system and applications are fully updated to patch vulnerabilities.',
            ),
            const SizedBox(height: 24),

            // Section 3: Post-Incident
            _buildSectionHeader('Post-Incident Steps', 'After Securing Your Accounts', AppConstants.primaryPurple),
            const SizedBox(height: 12),
            _buildTipCard(
              Icons.flag_outlined,
              'Report the Phish',
              'Report the email to the company being impersonated (e.g., Google, Microsoft, your bank).',
            ),
            _buildTipCard(
              Icons.credit_score,
              'Monitor Credit Reports',
              'Watch for signs of identity theft, such as unexpected credit inquiries, for several months.',
            ),
            _buildTipCard(
              Icons.description_outlined,
              'File a Report',
              'If you lost money or sensitive personal information (like SSN), report to local law enforcement and the FTC.',
            ),
            const SizedBox(height: 24),

            // What NOT to Do
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppConstants.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppConstants.phishingRed.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.block, color: AppConstants.phishingRed, size: 24),
                      SizedBox(width: 8),
                      Text('What NOT to Do',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.phishingRed)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildDontItem('Do not reply to the phishing email'),
                  const SizedBox(height: 8),
                  _buildDontItem('Do not click on any more links or open attachments in the suspicious email'),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  static Widget _buildSectionHeader(String title, String subtitle, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: AppConstants.textSecondary)),
      ],
    );
  }

  static Widget _buildTipCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstants.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppConstants.primaryPurple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppConstants.primaryPurple, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppConstants.textPrimary)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: AppConstants.textSecondary, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDontItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.close, color: AppConstants.phishingRed, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppConstants.textSecondary))),
      ],
    );
  }
}