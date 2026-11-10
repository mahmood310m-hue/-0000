import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  User? get currentUser => Supabase.instance.client.auth.currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthProvider() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }

  Future<String?> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'حدث خطأ أثناء تسجيل الدخول';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signUp(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'حدث خطأ أثناء إنشاء الحساب';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    notifyListeners();
  }
}
