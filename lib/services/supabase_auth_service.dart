import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  SupabaseAuthService._();

  static final SupabaseAuthService instance =
      SupabaseAuthService._();

  SupabaseClient get _client =>
      Supabase.instance.client;

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser =>
      _client.auth.currentUser;

  // ============================================================
  // SIGN UP
  // ============================================================

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email.trim(),
      password: password,
    );
  }

  // ============================================================
  // SIGN IN
  // ============================================================

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // ============================================================
  // AUTH STATE
  // ============================================================

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;
}