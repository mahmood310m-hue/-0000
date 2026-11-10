import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  Map<String, dynamic> _settings = {};
  bool _isLoading = false;

  Map<String, dynamic> get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _client
          .from('school_settings')
          .select()
          .limit(1);

      if (result.isNotEmpty) {
        _settings = Map<String, dynamic>.from(result.first);
      }
    } catch (e) {
      debugPrint('خطأ تحميل إعدادات المدرسة: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSettings(Map<String, dynamic> data) async {
    try {
      if (_settings['id'] != null) {
        await _client
            .from('school_settings')
            .update(data)
            .eq('id', _settings['id']);
      } else {
        await _client.from('school_settings').insert(data);
      }

      await loadSettings();
      return true;
    } catch (e) {
      debugPrint('خطأ تحديث إعدادات المدرسة: $e');
      return false;
    }
  }
}
