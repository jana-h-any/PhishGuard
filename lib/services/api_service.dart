import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scan_result_model.dart';

class ApiService {
  // Replace 192.168.1.5 with YOUR actual IP from ipconfig
  static const String _baseUrl = 'http://10.130.35.70:8000/';

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
