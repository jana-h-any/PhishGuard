import 'package:flutter/foundation.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:http/http.dart' as http;
import '../models/email_model.dart';
import 'dart:convert';

class _AuthenticatedClient extends http.BaseClient {
  final String accessToken;
  final http.Client _inner = http.Client();
  _AuthenticatedClient(this.accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $accessToken';
    return _inner.send(request);
  }
}

class GmailService {
  gmail.GmailApi? _gmailApi;

  void initialize(String accessToken) {
    final client = _AuthenticatedClient(accessToken);
    _gmailApi = gmail.GmailApi(client);
  }

  bool get isInitialized => _gmailApi != null;

  String _getHeader(List<gmail.MessagePartHeader> headers, String name) {
    final h = headers.firstWhere(
      (h) => (h.name ?? '').toLowerCase() == name.toLowerCase(),
      orElse: () => gmail.MessagePartHeader(name: '', value: ''),
    );
    return h.value ?? '';
  }

  String _extractBody(gmail.MessagePart? payload) {
    if (payload == null) return '';
    if (payload.body?.data != null) return _decodeBase64(payload.body!.data!);
    final parts = payload.parts ?? [];
    for (final part in parts) {
      if (part.mimeType == 'text/plain' && part.body?.data != null) {
        return _decodeBase64(part.body!.data!);
      }
    }
    for (final part in parts) {
      if (part.mimeType == 'text/html' && part.body?.data != null) {
        return _stripHtml(_decodeBase64(part.body!.data!));
      }
    }
    return '';
  }

  String _decodeBase64(String data) {
    String normalized = data.replaceAll('-', '+').replaceAll('_', '/');
    while (normalized.length % 4 != 0) normalized += '=';
    try {
      return utf8.decode(base64Decode(normalized));
    } catch (_) {
      return '';
    }
  }

  String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<List<EmailModel>> fetchEmails(
      {String? category, int maxResults = 20}) async {
    if (_gmailApi == null) throw Exception('Gmail API not initialized');

    String query = 'in:inbox';
    if (category == 'promotions') query = 'category:promotions';
    if (category == 'social') query = 'category:social';

    final messageList = await _gmailApi!.users.messages
        .list('me', q: query, maxResults: maxResults);
    final messages = messageList.messages ?? [];
    debugPrint('=== GMAIL API: got ${messages.length} message IDs');

    final emails = <EmailModel>[];
    for (final msg in messages) {
      try {
        final m =
            await _gmailApi!.users.messages.get('me', msg.id!, format: 'full');
        final headers = m.payload?.headers ?? [];
        final from = _getHeader(headers, 'From');
        final senderName = from.contains('<')
            ? from.substring(0, from.indexOf('<')).trim().replaceAll('"', '')
            : from.split('@').first;
        final senderEmail = from.contains('<')
            ? from.substring(from.indexOf('<') + 1, from.indexOf('>'))
            : from;
        final labels = m.labelIds ?? [];

        String cat = 'inbox';
        if (labels.contains('CATEGORY_PROMOTIONS')) cat = 'promotions';
        if (labels.contains('CATEGORY_SOCIAL')) cat = 'social';

        emails.add(EmailModel(
          id: m.id ?? '',
          sender:
              senderName.isEmpty ? senderEmail.split('@').first : senderName,
          senderEmail: senderEmail,
          subject: _getHeader(headers, 'Subject'),
          body: _extractBody(m.payload),
          snippet: m.snippet ?? '',
          date: DateTime.fromMillisecondsSinceEpoch(
              int.parse(m.internalDate ?? '0')),
          category: cat,
          isRead: !labels.contains('UNREAD'),
        ));
      } catch (e) {
        debugPrint('=== PARSE ERROR ${msg.id}: $e');
        continue;
      }
    }
    debugPrint('=== Parsed ${emails.length} emails successfully');
    return emails;
  }

  Future<EmailModel> getEmail(String emailId) async {
    if (_gmailApi == null) throw Exception('Gmail API not initialized');
    final m =
        await _gmailApi!.users.messages.get('me', emailId, format: 'full');
    final headers = m.payload?.headers ?? [];
    final from = _getHeader(headers, 'From');
    final senderName = from.contains('<')
        ? from.substring(0, from.indexOf('<')).trim().replaceAll('"', '')
        : from.split('@').first;
    final senderEmail = from.contains('<')
        ? from.substring(from.indexOf('<') + 1, from.indexOf('>'))
        : from;

    return EmailModel(
      id: m.id ?? '',
      sender: senderName.isEmpty ? senderEmail.split('@').first : senderName,
      senderEmail: senderEmail,
      subject: _getHeader(headers, 'Subject'),
      body: _extractBody(m.payload),
      snippet: m.snippet ?? '',
      date:
          DateTime.fromMillisecondsSinceEpoch(int.parse(m.internalDate ?? '0')),
    );
  }
}
