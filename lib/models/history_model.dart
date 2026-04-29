class HistoryModel {
  final int? dbId;
  final String emailId;
  final String sender;
  final String senderEmail;
  final String subject;
  final String label;
  final double confidence;
  final String riskLevel;
  final List<String> reasons;
  final DateTime scannedAt;

  HistoryModel({
    this.dbId,
    required this.emailId,
    required this.sender,
    required this.senderEmail,
    required this.subject,
    required this.label,
    required this.confidence,
    required this.riskLevel,
    required this.reasons,
    required this.scannedAt,
  });

  bool get isPhishing => label == 'phishing';
  bool get isMediumRisk => riskLevel == 'medium';

  factory HistoryModel.fromDb(Map<String, dynamic> map) {
    return HistoryModel(
      dbId: map['id'],
      emailId: map['email_id'],
      sender: map['sender'],
      senderEmail: map['sender_email'],
      subject: map['subject'],
      label: map['label'],
      confidence: map['confidence'],
      riskLevel: map['risk_level'],
      reasons: (map['reasons'] as String).split('|||'),
      scannedAt: DateTime.parse(map['scanned_at']),
    );
  }

  Map<String, dynamic> toDb() => {
        'email_id': emailId,
        'sender': sender,
        'sender_email': senderEmail,
        'subject': subject,
        'label': label,
        'confidence': confidence,
        'risk_level': riskLevel,
        'reasons': reasons.join('|||'),
        'scanned_at': scannedAt.toIso8601String(),
      };
}
