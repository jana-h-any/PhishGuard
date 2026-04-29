import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/scan_controller.dart';
import '../models/email_model.dart';
import '../utils/constants.dart';
import 'analyzing_view.dart';

class EmailDetailView extends StatelessWidget {
  final EmailModel email;
  const EmailDetailView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(icon: const Icon(Icons.delete_outline), onPressed: () {}),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ]),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(radius: 22, backgroundColor: AppConstants.primaryPurple.withOpacity(0.2),
                child: Text(email.sender[0].toUpperCase(), style: const TextStyle(color: AppConstants.primaryPurple, fontWeight: FontWeight.bold))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(email.sender, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppConstants.textPrimary)),
                Text(email.senderEmail, style: const TextStyle(fontSize: 12, color: AppConstants.textSecondary)),
              ])),
            ]),
            const SizedBox(height: 20),
            const Text('Subject', style: TextStyle(fontSize: 12, color: AppConstants.primaryPurple, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(email.subject, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppConstants.textPrimary)),
            const SizedBox(height: 20),
            const Text('Message', style: TextStyle(fontSize: 12, color: AppConstants.primaryPurple, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(email.body, style: const TextStyle(fontSize: 14, color: AppConstants.textPrimary, height: 1.6)),
          ]),
        )),
        Container(
          padding: const EdgeInsets.all(16),
          child: SizedBox(width: double.infinity, child: ElevatedButton.icon(
            onPressed: () {
              context.read<ScanController>().reset();
              Navigator.push(context, MaterialPageRoute(builder: (_) => AnalyzingView(email: email)));
            },
            icon: const Icon(Icons.shield, size: 20),
            label: const Text('Analyze Email'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          )),
        ),
      ]),
    );
  }
}
