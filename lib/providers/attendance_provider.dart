import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _records = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get records => _records;
  bool get isLoading => _isLoading;

  Future<void> loadAttendance() async {
    _isLoading = true;
    notifyListeners();

    try {
      _records = await _client
          .from('attendance')
          .select()
          .order('created_at', ascending: false);
    } catch (e) {
      debugPrint('خطأ تحميل الحضور: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAttendance(Map<String, dynamic> attendance) async {
    try {
      await _client.from('attendance').insert(attendance);
      await loadAttendance();
      return true;
    } catch (e) {
      debugPrint('خطأ إضافة الحضور: $e');
      return false;
    }
  }

  Future<bool> updateAttendance(
    String id,
    Map<String, dynamic> attendance,
  ) async {
    try {
      await _client
          .from('attendance')
          .update(attendance)
          .eq('id', id);
      await loadAttendance();
      return true;
    } catch (e) {
      debugPrint('خطأ تحديث الحضور: $e');
      return false;
    }
  }

  Future<bool> deleteAttendance(String id) async {
    try {
      await _client.from('attendance').delete().eq('id', id);
      await loadAttendance();
      return true;
    } catch (e) {
      debugPrint('خطأ حذف الحضور: $e');
      return false;
    }
  }
}
