class EmailModel {
  final String id;
  final String sender;
  final String senderEmail;
  final String subject;
  final String body;
  final String snippet;
  final DateTime date;
  final String category;
  final bool isRead;
  final String? avatarColor;

  EmailModel({
    required this.id,
    required this.sender,
    required this.senderEmail,
    required this.subject,
    required this.body,
    required this.snippet,
    required this.date,
    this.category = 'inbox',
    this.isRead = false,
    this.avatarColor,
  });

  factory EmailModel.fromGmailApi(Map<String, dynamic> json) {
    final headers = (json['payload']?['headers'] as List<dynamic>?) ?? [];

    String getHeader(String name) {
      final header = headers.firstWhere(
        (h) => h['name'].toString().toLowerCase() == name.toLowerCase(),
        orElse: () => {'value': ''},
      );
      return header['value'] ?? '';
    }

    final from = getHeader('From');
    final senderName = from.contains('<')
        ? from.substring(0, from.indexOf('<')).trim().replaceAll('"', '')
        : from.split('@').first;
    final senderEmail = from.contains('<')
        ? from.substring(from.indexOf('<') + 1, from.indexOf('>'))
        : from;

    final labels = (json['labelIds'] as List<dynamic>?) ?? [];
    String category = 'inbox';
    if (labels.contains('CATEGORY_PROMOTIONS')) {
      category = 'promotions';
    } else if (labels.contains('CATEGORY_SOCIAL')) {
      category = 'social';
    }

    return EmailModel(
      id: json['id'] ?? '',
      sender: senderName.isEmpty ? senderEmail.split('@').first : senderName,
      senderEmail: senderEmail,
      subject: getHeader('Subject'),
      body: _extractBody(json['payload']),
      snippet: json['snippet'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(
        int.parse(json['internalDate'] ?? '0'),
      ),
      category: category,
      isRead: !(labels.contains('UNREAD')),
    );
  }

  static String _extractBody(Map<String, dynamic>? payload) {
    if (payload == null) return '';
    if (payload['body']?['data'] != null) {
      return _decodeBase64(payload['body']['data']);
    }
    final parts = payload['parts'] as List<dynamic>?;
    if (parts != null) {
      for (final part in parts) {
        if (part['mimeType'] == 'text/plain' && part['body']?['data'] != null) {
          return _decodeBase64(part['body']['data']);
        }
      }
      for (final part in parts) {
        if (part['mimeType'] == 'text/html' && part['body']?['data'] != null) {
          return _stripHtml(_decodeBase64(part['body']['data']));
        }
      }
    }
    return '';
  }

  static String _decodeBase64(String data) {
    String normalized = data.replaceAll('-', '+').replaceAll('_', '/');
    while (normalized.length % 4 != 0) {
      normalized += '=';
    }
    try {
      final bytes = Uri.parse('data:;base64,\$normalized').data?.contentAsBytes();
      return bytes != null ? String.fromCharCodes(bytes) : '';
    } catch (_) {
      return '';
    }
  }

  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'senderEmail': senderEmail,
        'subject': subject,
        'body': body,
        'snippet': snippet,
        'date': date.toIso8601String(),
        'category': category,
        'isRead': isRead,
      };
}
