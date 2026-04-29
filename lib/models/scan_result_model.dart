class ScanResultModel {
  final String label;
  final double confidence;
  final String riskLevel;
  final bool hasUrl;
  final List<String> reasons;
  final String modelUsed;

  ScanResultModel({
    required this.label,
    required this.confidence,
    required this.riskLevel,
    required this.hasUrl,
    required this.reasons,
    required this.modelUsed,
  });

  bool get isPhishing => label == 'phishing';
  String get confidencePercent => '\${(confidence * 100).toStringAsFixed(0)}%';

  factory ScanResultModel.fromJson(Map<String, dynamic> json) {
    return ScanResultModel(
      label: json['label'] ?? 'safe',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      riskLevel: json['risk_level'] ?? 'low',
      hasUrl: json['has_url'] ?? false,
      reasons: List<String>.from(json['reasons'] ?? []),
      modelUsed: json['model_used'] ?? 'unknown',
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'confidence': confidence,
        'risk_level': riskLevel,
        'has_url': hasUrl,
        'reasons': reasons,
        'model_used': modelUsed,
      };
}
