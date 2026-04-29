import 'package:flutter/material.dart';
import '../models/email_model.dart';
import '../models/scan_result_model.dart';
import '../models/history_model.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class ScanController extends ChangeNotifier {
  final ApiService _apiService;
  final DatabaseService _databaseService;

  ScanResultModel? _currentResult;
  bool _isScanning = false;
  String? _error;
  int _scanStep = 0;

  ScanController(this._apiService, this._databaseService);

  ScanResultModel? get currentResult => _currentResult;
  bool get isScanning => _isScanning;
  String? get error => _error;
  int get scanStep => _scanStep;

  Future<ScanResultModel?> analyzeEmail(EmailModel email) async {
    try {
      _isScanning = true;
      _currentResult = null;
      _error = null;
      _scanStep = 0;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 800));
      _scanStep = 1;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 800));
      _scanStep = 2;
      notifyListeners();

      final result = await _apiService.analyzeEmail(
        sender: email.senderEmail,
        subject: email.subject,
        body: email.body,
      );

      _scanStep = 3;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 600));
      _scanStep = 4;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 400));

      _currentResult = result;
      _isScanning = false;
      notifyListeners();

      final history = HistoryModel(
        emailId: email.id,
        sender: email.sender,
        senderEmail: email.senderEmail,
        subject: email.subject,
        label: result.label,
        confidence: result.confidence,
        riskLevel: result.riskLevel,
        reasons: result.reasons,
        scannedAt: DateTime.now(),
      );
      await _databaseService.insertScanResult(history);

      return result;
    } catch (e) {
      _error = 'Could not analyze this email. Check the model & API connection';
      _isScanning = false;
      notifyListeners();
      return null;
    }
  }

  void reset() {
    _currentResult = null;
    _isScanning = false;
    _error = null;
    _scanStep = 0;
    notifyListeners();
  }
}
