import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/scan_controller.dart';
import '../models/email_model.dart';
import '../utils/constants.dart';
import 'scan_result_view.dart';

class AnalyzingView extends StatefulWidget {
  final EmailModel email;
  const AnalyzingView({super.key, required this.email});

  @override
  State<AnalyzingView> createState() => _AnalyzingViewState();
}

class _AnalyzingViewState extends State<AnalyzingView> {
  @override
  void initState() {
    super.initState();
    _startAnalysis();
  }

  Future<void> _startAnalysis() async {
    final controller = context.read<ScanController>();
    final result = await controller.analyzeEmail(widget.email);
    if (mounted && result != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => ScanResultView(result: result, email: widget.email),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Consumer<ScanController>(
        builder: (context, controller, _) {
          if (controller.error != null) {
            return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.error_outline, size: 64, color: AppConstants.phishingRed),
              const SizedBox(height: 16),
              Text(controller.error!, textAlign: TextAlign.center, style: const TextStyle(color: AppConstants.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Go Back')),
            ])));
          }
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 32), child: Column(children: [
            const Spacer(flex: 2),
            Container(width: 120, height: 120,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppConstants.primaryPurple.withOpacity(0.4), AppConstants.backgroundDark])),
              child: const Icon(Icons.shield_outlined, size: 60, color: AppConstants.primaryPurple)),
            const SizedBox(height: 32),
            const Text('Analyzing Email...', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstants.textPrimary)),
            const SizedBox(height: 8),
            const Text('Our AI is checking for phishing\nindicators and suspicious patterns.',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: AppConstants.textSecondary)),
            const SizedBox(height: 40),
            _buildStep('Checking sender reputation', controller.scanStep >= 1, controller.scanStep == 1),
            _buildStep('Analyzing email content', controller.scanStep >= 2, controller.scanStep == 2),
            _buildStep('Scanning links and attachments', controller.scanStep >= 3, controller.scanStep == 3),
            _buildStep('Calculating risk score', controller.scanStep >= 4, controller.scanStep == 4),
            const Spacer(flex: 2),
            Container(padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppConstants.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppConstants.borderColor)),
              child: const Row(children: [
                Text('\u{1F4A1}', style: TextStyle(fontSize: 20)),
                SizedBox(width: 12),
                Expanded(child: Text('Tip: Phishing emails often create a sense of urgency. Stay calm and stay safe!',
                    style: TextStyle(fontSize: 12, color: AppConstants.textSecondary))),
              ])),
            const SizedBox(height: 32),
          ]));
        },
      )),
    );
  }

  Widget _buildStep(String label, bool completed, bool active) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [
      if (completed && !active) const Icon(Icons.check_circle, color: AppConstants.safeGreen, size: 20)
      else if (active) const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppConstants.primaryPurple))
      else Icon(Icons.circle_outlined, color: AppConstants.textSecondary.withOpacity(0.4), size: 20),
      const SizedBox(width: 12),
      Text(label, style: TextStyle(fontSize: 14, color: completed || active ? AppConstants.textPrimary : AppConstants.textSecondary.withOpacity(0.4))),
    ]));
  }
}
