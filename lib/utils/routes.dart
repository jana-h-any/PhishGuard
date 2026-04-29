import 'package:flutter/material.dart';
import '../views/onboarding_view.dart';
import '../views/connect_gmail_view.dart';
import '../views/home_shell.dart';

class AppRoutes {
  static const String onboarding = '/';
  static const String connectGmail = '/connect-gmail';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingView(),
        connectGmail: (context) => const ConnectGmailView(),
        home: (context) => const HomeShell(),
      };
}
