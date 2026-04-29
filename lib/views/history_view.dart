import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/history_controller.dart';
import '../utils/constants.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});
  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryController>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('History'),
        actions: [IconButton(icon: const Icon(Icons.calendar_today), onPressed: () {})],
      ),
      body: Consumer<HistoryController>(builder: (context, controller, _) {
        return Column(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
            _buildFilterTab('All', 'all', controller),
            const SizedBox(width: 8),
            _buildFilterTab('Phishing', 'phishing', controller),
            const SizedBox(width: 8),
            _buildFilterTab('Safe', 'safe', controller),
          ])),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppConstants.cardDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppConstants.borderColor)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Your Overview', style: TextStyle(fontWeight: FontWeight.w600, color: AppConstants.textPrimary)),
              const SizedBox(height: 4),
              const Text('This Week', style: TextStyle(fontSize: 12, color: AppConstants.textSecondary)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _buildStatItem(controller.weeklyStats['total'].toString(), 'Emails Scanned', AppConstants.primaryPurple),
                _buildStatItem(controller.weeklyStats['phishing'].toString(), 'Phishing Detected', AppConstants.phishingRed),
                _buildStatItem(controller.weeklyStats['safe'].toString(), 'Safe Emails', AppConstants.safeGreen),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: controller.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryPurple))
                : controller.history.isEmpty
                    ? const Center(child: Text('No scan history yet', style: TextStyle(color: AppConstants.textSecondary)))
                    : ListView.builder(
                        itemCount: controller.history.length,
                        itemBuilder: (context, index) {
                          final item = controller.history[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppConstants.primaryPurple.withOpacity(0.2),
                              child: Text(item.sender[0].toUpperCase(), style: const TextStyle(color: AppConstants.primaryPurple, fontWeight: FontWeight.bold))),
                            title: Text(item.sender, style: const TextStyle(color: AppConstants.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Text(item.senderEmail, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12)),
                            trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text(_formatDate(item.scannedAt), style: const TextStyle(color: AppConstants.textSecondary, fontSize: 11)),
                              const SizedBox(height: 4),
                              _buildLabelBadge(item.label, item.riskLevel),
                            ]),
                          );
                        }),
          ),
        ]);
      }),
    );
  }

  Widget _buildFilterTab(String label, String filter, HistoryController controller) {
    final isSelected = controller.filter == filter;
    return GestureDetector(
      onTap: () => controller.setFilter(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryPurple : AppConstants.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppConstants.primaryPurple : AppConstants.borderColor)),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : AppConstants.textSecondary,
            fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 11, color: AppConstants.textSecondary)),
    ]);
  }

  Widget _buildLabelBadge(String label, String riskLevel) {
    Color color; String text;
    if (label == 'phishing') { color = AppConstants.phishingRed; text = 'Phishing'; }
    else if (riskLevel == 'medium') { color = AppConstants.mediumOrange; text = 'Medium Risk'; }
    else { color = AppConstants.safeGreen; text = 'Safe'; }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withOpacity(0.3))),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return DateFormat('h:mm a').format(date);
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(date);
  }
}
