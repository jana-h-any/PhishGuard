import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                   const SizedBox(height: 70),
                  // const Icon(
                  //   Icons.shield,
                  //   size: 80,
                  //   color: AppConstants.primaryPurple,
                  // ),
                  const SizedBox(height: 16),
                  const Text(
                    'PhishGuard',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'AI-Powered Phishing Detection',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppConstants.primaryPurple.withOpacity(0.3),
                          AppConstants.backgroundDark,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.verified_user,
                      size: 100,
                      color: AppConstants.primaryPurple,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Protect yourself from\nphishing attacks',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect your Gmail and let AI\nkeep you safe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/connect-gmail');
                      },
                      child: const Text('Get Started'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(color: AppConstants.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
