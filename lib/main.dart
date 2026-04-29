import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_controller.dart';
import 'controllers/email_controller.dart';
import 'controllers/scan_controller.dart';
import 'controllers/history_controller.dart';
import 'services/api_service.dart';
import 'services/gmail_service.dart';
import 'services/database_service.dart';
import 'utils/theme.dart';
import 'utils/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhishGuardApp());
}

class PhishGuardApp extends StatelessWidget {
  const PhishGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final gmailService = GmailService();
    final apiService = ApiService();
    final databaseService = DatabaseService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController(gmailService)),
        ChangeNotifierProvider(create: (_) => EmailController(gmailService)),
        ChangeNotifierProvider(create: (_) => ScanController(apiService, databaseService)),
        ChangeNotifierProvider(create: (_) => HistoryController(databaseService)),
      ],
      child: MaterialApp(
        title: 'PhishGuard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.onboarding,
        routes: AppRoutes.routes,
      ),
    );
  }
}
