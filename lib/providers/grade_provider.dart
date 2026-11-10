import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GradeProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _grades = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get grades => _grades;
  bool get isLoading => _isLoading;

  Future<void> loadGrades() async {
    _isLoading = true;
    notifyListeners();

    try {
      _grades = await _client
          .from('grades')
          .select()
          .order('created_at', ascending: false);
    } catch (e) {
      debugPrint('خطأ تحميل الدرجات: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addGrade(Map<String, dynamic> grade) async {
    try {
      await _client.from('grades').insert(grade);
      await loadGrades();
      return true;
    } catch (e) {
      debugPrint('خطأ إضافة الدرجة: $e');
      return false;
    }
  }

  Future<bool> updateGrade(
    String id,
    Map<String, dynamic> grade,
  ) async {
    try {
      await _client.from('grades').update(grade).eq('id', id);
      await loadGrades();
      return true;
    } catch (e) {
      debugPrint('خطأ تحديث الدرجة: $e');
      return false;
    }
  }

  Future<bool> deleteGrade(String id) async {
    try {
      await _client.from('grades').delete().eq('id', id);
      await loadGrades();
      return true;
    } catch (e) {
      debugPrint('خطأ حذف الدرجة: $e');
      return false;
    }
  }
}
