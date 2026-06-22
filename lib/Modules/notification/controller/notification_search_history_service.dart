import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationSearchHistoryService extends GetxService {
  static const String _searchHistoryKey = 'notification_search_history';
  final GetStorage _box = GetStorage();
  final RxList<String> searchHistory = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void _loadHistory() {
    final rawHistory = _box.read(_searchHistoryKey);
    if (rawHistory is List) {
      searchHistory.assignAll(rawHistory.map((e) => e.toString()).toList());
    }
  }

  void addSearchTerm(String term) {
    if (term.trim().isEmpty) return;
    
    // Remove if already exists to put it at the top
    searchHistory.removeWhere((e) => e.toLowerCase() == term.toLowerCase());
    
    // Insert at the beginning
    searchHistory.insert(0, term.trim());
    
    // Keep only last 10 searches
    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }
    
    _box.write(_searchHistoryKey, searchHistory.toList());
  }

  void removeSearchTerm(String term) {
    searchHistory.removeWhere((e) => e.toLowerCase() == term.toLowerCase());
    _box.write(_searchHistoryKey, searchHistory.toList());
  }

  void clearHistory() {
    searchHistory.clear();
    _box.remove(_searchHistoryKey);
  }
}
