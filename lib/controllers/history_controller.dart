import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../services/database_service.dart';

class HistoryController extends ChangeNotifier {
  final DatabaseService _databaseService;

  List<HistoryModel> _history = [];
  Map<String, int> _weeklyStats = {'total': 0, 'phishing': 0, 'safe': 0};
  bool _isLoading = false;
  String _filter = 'all';

  HistoryController(this._databaseService);

  List<HistoryModel> get history => _history;
  Map<String, int> get weeklyStats => _weeklyStats;
  bool get isLoading => _isLoading;
  String get filter => _filter;

  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();

    if (_filter == 'all') {
      _history = await _databaseService.getAllHistory();
    } else {
      _history = await _databaseService.getHistoryByLabel(_filter);
    }

    _weeklyStats = await _databaseService.getWeeklyStats();

    _isLoading = false;
    notifyListeners();
  }

  void setFilter(String filter) {
    _filter = filter;
    loadHistory();
  }

  Future<void> clearHistory() async {
    await _databaseService.clearHistory();
    await loadHistory();
  }
}
