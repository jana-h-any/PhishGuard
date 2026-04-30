import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scan_result_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://phishguard-api-88793191194.europe-west1.run.app/';

  Future<ScanResultModel> analyzeEmail({
    required String sender,
    required String subject,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender': sender,
          'subject': subject,
          'body': body,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ScanResultModel.fromJson(data);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to analyze email: $e');
    }
  }
}
