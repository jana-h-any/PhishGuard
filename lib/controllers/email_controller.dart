import 'package:flutter/material.dart';
import '../models/email_model.dart';
import '../services/gmail_service.dart';

class EmailController extends ChangeNotifier {
  final GmailService _gmailService;

  List<EmailModel> _emails = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'inbox';

  EmailController(this._gmailService);

  List<EmailModel> get emails => _emails;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  Future<void> fetchEmails({String? category}) async {
    try {
      _isLoading = true;
      _error = null;
      if (category != null) _selectedCategory = category;
      notifyListeners();

      debugPrint('=== GMAIL: isInitialized=${_gmailService.isInitialized}');
      debugPrint('=== GMAIL: fetching category=$_selectedCategory');

      _emails = await _gmailService.fetchEmails(
        category: _selectedCategory == 'inbox' ? null : _selectedCategory,
      );

      debugPrint('=== GMAIL: fetched ${_emails.length} emails');

      _isLoading = false;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('=== GMAIL ERROR: $e');
      debugPrint('=== GMAIL STACK: $stack');
      _error = 'Failed to fetch emails: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    fetchEmails(category: category);
  }

  Future<EmailModel> getEmail(String emailId) async {
    return await _gmailService.getEmail(emailId);
  }
}
