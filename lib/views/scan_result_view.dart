import 'package:flutter/material.dart';
import '../models/scan_result_model.dart';
import '../models/email_model.dart';
import '../utils/constants.dart';

class ScanResultView extends StatelessWidget {
  final ScanResultModel result;
  final EmailModel email;
  const ScanResultView({super.key, required this.result, required this.email});

  @override
  Widget build(BuildContext context) {
    final isPhishing = result.isPhishing;
    final color =
        isPhishing ? AppConstants.phishingRed : AppConstants.safeGreen;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Result')),
      body: Column(children: [
        Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(children: [
                  const SizedBox(height: 16),
                  Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.15)),
                      child: Icon(isPhishing ? Icons.close : Icons.check,
                          size: 60, color: color)),
                  const SizedBox(height: 20),
                  Text(isPhishing ? 'Phishing Detected!' : 'Safe Email',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color)),
                  const SizedBox(height: 8),
                  Text(
                      isPhishing
                          ? 'This email looks suspicious'
                          : 'This email looks safe',
                      style: const TextStyle(
                          color: AppConstants.textSecondary, fontSize: 14)),
                  const SizedBox(height: 32),
                  _buildInfoRow('Risk Level', result.riskLevel.toUpperCase(),
                      _getRiskColor(result.riskLevel)),
                  const SizedBox(height: 16),
                  _buildConfidenceBar(result.confidence, color),
                  const SizedBox(height: 32),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          isPhishing
                              ? 'Why is this email suspicious?'
                              : 'Why is this email safe?',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textPrimary))),
                  const SizedBox(height: 16),
                  ...result.reasons
                      .map((reason) => _buildReasonTile(reason, isPhishing)),
                  const SizedBox(height: 32),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'What should you do?',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isPhishing) ...[
                    _buildAdviceTile(
                        Icons.close, "Don't click any links", true),
                    _buildAdviceTile(
                        Icons.close, "Don't download attachments", true),
                    _buildAdviceTile(Icons.check, 'Report this email', false),
                    _buildAdviceTile(Icons.check, 'Block sender', false),
                  ] else ...[
                    _buildAdviceTile(Icons.check,
                        'Looks safe, but always verify sender', false),
                    _buildAdviceTile(
                        Icons.check, 'Avoid sharing sensitive info', false),
                  ],
                ]))),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppConstants.borderColor))),
          child: Row(children: [
            Expanded(
                child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.description_outlined, size: 18),
                    label: const Text('View Email Headers'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.textSecondary,
                        side: const BorderSide(color: AppConstants.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 12)))),
            const SizedBox(width: 12),
            Expanded(
                child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                        isPhishing ? Icons.flag_outlined : Icons.star_outline,
                        size: 18),
                    label:
                        Text(isPhishing ? 'Report Email' : 'Mark as Important'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppConstants.textSecondary,
                        side: const BorderSide(color: AppConstants.borderColor),
                        padding: const EdgeInsets.symmetric(vertical: 12)))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: AppConstants.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: const TextStyle(
                color: AppConstants.textSecondary, fontSize: 14)),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                color: valueColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            child: Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12))),
      ]),
    );
  }

  Widget _buildConfidenceBar(double confidence, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppConstants.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppConstants.borderColor)),
          ),
          child: Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('Headers', overflow: TextOverflow.ellipsis),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.textSecondary,
                  side: const BorderSide(color: AppConstants.borderColor),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(
                  result.isPhishing ? Icons.flag_outlined : Icons.star_outline,
                  size: 16,
                ),
                label: Text(
                  result.isPhishing ? 'Report' : 'Important',
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppConstants.textSecondary,
                  side: const BorderSide(color: AppConstants.borderColor),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
                value: confidence,
                backgroundColor: AppConstants.borderColor,
                color: color,
                minHeight: 8)),
      ]),
    );
  }

  Widget _buildReasonTile(String reason, bool isPhishing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
          color: AppConstants.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor)),
      child: Row(children: [
        Icon(isPhishing ? Icons.warning_amber : Icons.check_circle_outline,
            color:
                isPhishing ? AppConstants.phishingRed : AppConstants.safeGreen,
            size: 20),
        const SizedBox(width: 12),
        Expanded(
            child: Text(reason,
                style: const TextStyle(
                    color: AppConstants.textPrimary, fontSize: 14))),
        const Icon(Icons.chevron_right,
            color: AppConstants.textSecondary, size: 20),
      ]),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'high':
        return AppConstants.phishingRed;
      case 'medium':
        return AppConstants.mediumOrange;
      default:
        return AppConstants.safeGreen;
    }
  }
}

Widget _buildAdviceTile(IconData icon, String text, bool isDanger) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    decoration: BoxDecoration(
      color: AppConstants.cardDark,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppConstants.borderColor),
    ),
    child: Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDanger
                ? AppConstants.phishingRed.withOpacity(0.15)
                : AppConstants.safeGreen.withOpacity(0.15),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isDanger ? AppConstants.phishingRed : AppConstants.safeGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppConstants.textPrimary,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );
}
