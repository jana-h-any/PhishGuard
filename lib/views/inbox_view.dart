import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/email_controller.dart';
import '../models/email_model.dart';
import '../utils/constants.dart';
import 'email_detail_view.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmailController>().fetchEmails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: const Text('My Gmail'),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: () {})],
      ),
      body: Consumer<EmailController>(
        builder: (context, controller, _) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Select an email to analyze', style: TextStyle(color: AppConstants.textSecondary, fontSize: 13)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  _buildTab('Inbox', 'inbox', controller),
                  const SizedBox(width: 8),
                  _buildTab('Promotions', 'promotions', controller),
                  const SizedBox(width: 8),
                  _buildTab('Social', 'social', controller),
                ]),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: controller.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppConstants.primaryPurple))
                    : controller.error != null
                        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.error_outline, color: AppConstants.phishingRed, size: 48),
                            const SizedBox(height: 12),
                            Text(controller.error!, style: const TextStyle(color: AppConstants.textSecondary)),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: () => controller.fetchEmails(), child: const Text('Retry')),
                          ]))
                        : ListView.builder(
                            itemCount: controller.emails.length,
                            itemBuilder: (context, index) => _buildEmailTile(context, controller.emails[index]),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(String label, String category, EmailController controller) {
    final isSelected = controller.selectedCategory == category;
    return GestureDetector(
      onTap: () => controller.setCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.primaryPurple : AppConstants.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppConstants.primaryPurple : AppConstants.borderColor),
        ),
        child: Text(label, style: TextStyle(
          color: isSelected ? Colors.white : AppConstants.textSecondary,
          fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        )),
      ),
    );
  }

  Widget _buildEmailTile(BuildContext context, EmailModel email) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmailDetailView(email: email))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppConstants.borderColor, width: 0.5))),
        child: Row(children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppConstants.primaryPurple.withOpacity(0.2),
            child: Text(email.sender[0].toUpperCase(), style: const TextStyle(color: AppConstants.primaryPurple, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(child: Text(email.sender, style: TextStyle(fontWeight: email.isRead ? FontWeight.normal : FontWeight.w600, color: AppConstants.textPrimary, fontSize: 14), overflow: TextOverflow.ellipsis)),
              Text(_formatDate(email.date), style: const TextStyle(color: AppConstants.textSecondary, fontSize: 11)),
            ]),
            const SizedBox(height: 2),
            Text(email.subject, style: const TextStyle(color: AppConstants.textPrimary, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(email.snippet, style: const TextStyle(color: AppConstants.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
        ]),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return DateFormat('h:mm a').format(date);
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('MMM d').format(date);
  }
}
