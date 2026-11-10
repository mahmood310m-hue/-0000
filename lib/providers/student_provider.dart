import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _students = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get students => _students;
  bool get isLoading => _isLoading;

  Future<void> loadStudents() async {
    _isLoading = true;
    notifyListeners();

    try {
      _students = await _client
          .from('students')
          .select()
          .order('created_at', ascending: false);
    } catch (e) {
      debugPrint('خطأ تحميل الطلاب: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStudent(Map<String, dynamic> student) async {
    try {
      await _client.from('students').insert(student);
      await loadStudents();
      return true;
    } catch (e) {
      debugPrint('خطأ إضافة الطالب: $e');
      return false;
    }
  }

  Future<bool> updateStudent(
    String id,
    Map<String, dynamic> student,
  ) async {
    try {
      await _client.from('students').update(student).eq('id', id);
      await loadStudents();
      return true;
    } catch (e) {
      debugPrint('خطأ تحديث الطالب: $e');
      return false;
    }
  }

  Future<bool> deleteStudent(String id) async {
    try {
      await _client.from('students').delete().eq('id', id);
      await loadStudents();
      return true;
    } catch (e) {
      debugPrint('خطأ حذف الطالب: $e');
      return false;
    }
  }
}
