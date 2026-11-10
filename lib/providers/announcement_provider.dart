import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AnnouncementProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Map<String, dynamic>> _announcements = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get announcements => _announcements;
  bool get isLoading => _isLoading;

  Future<void> loadAnnouncements() async {
    _isLoading = true;
    notifyListeners();

    try {
      _announcements = await _client
          .from('announcements')
          .select()
          .order('created_at', ascending: false);
    } catch (e) {
      debugPrint('خطأ تحميل الإعلانات: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addAnnouncement(
    Map<String, dynamic> announcement,
  ) async {
    try {
      await _client.from('announcements').insert(announcement);
      await loadAnnouncements();
      return true;
    } catch (e) {
      debugPrint('خطأ إضافة الإعلان: $e');
      return false;
    }
  }

  Future<bool> updateAnnouncement(
    String id,
    Map<String, dynamic> announcement,
  ) async {
    try {
      await _client
          .from('announcements')
          .update(announcement)
          .eq('id', id);

      await loadAnnouncements();
      return true;
    } catch (e) {
      debugPrint('خطأ تحديث الإعلان: $e');
      return false;
    }
  }

  Future<bool> deleteAnnouncement(String id) async {
    try {
      await _client
          .from('announcements')
          .delete()
          .eq('id', id);

      await loadAnnouncements();
      return true;
    } catch (e) {
      debugPrint('خطأ حذف الإعلان: $e');
      return false;
    }
  }
}
