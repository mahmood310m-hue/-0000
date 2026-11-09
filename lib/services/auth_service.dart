import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;
  
  Future<AuthResponse> signInWithPhone(String phone, String password) async {
    try {
      return await _client.auth.signInWithPassword(
        email: '$phone@kauthar.school',
        password: password,
      );
    } catch (e) {
      throw Exception('فشل تسجيل الدخول: $e');
    }
  }
  
  Future<AuthResponse> signUpWithPhone({
    required String phone,
    required String password,
    required String fullName,
    required String role,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: '$phone@kauthar.school',
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'role': role,
        },
      );
      
      // إنشاء ملف المستخدم
      if (response.user != null) {
        await _client.from('profiles').insert({
          'id': response.user!.id,
          'full_name': fullName,
          'phone': phone,
          'role': role,
        });
      }
      
      return response;
    } catch (e) {
      throw Exception('فشل إنشاء الحساب: $e');
    }
  }
  
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  User? get currentUser => _client.auth.currentUser;
  
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();
    
    return response;
  }
  
  Future<bool> isAdmin(String userId) async {
    final profile = await getUserProfile(userId);
    return profile?['role'] == 'admin' || profile?['role'] == 'super_admin';
  }
}
