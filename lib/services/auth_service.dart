import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // ── Google Sign-In ────────────────────────────────────────────────────────
  // Replace this with your Web Client ID from Google Cloud Console.
  // Dashboard → APIs & Services → Credentials → OAuth 2.0 Client IDs (Web).
  static const _webClientId =
      'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

  /// Sign in via Google, then pass the ID token to Supabase.
  /// Returns `true` on success.
  Future<bool> signInWithGoogle() async {
    final googleUser = await GoogleSignIn(serverClientId: _webClientId).signIn();
    if (googleUser == null) return false; // user cancelled

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) return false;

    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
    return true;
  }

  /// Sign in with email + password. Throws [AuthException] on failure.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  /// Register a new account, then insert a profile row with [name].
  /// Returns `true` if the user is immediately active (no email confirmation
  /// needed), or `false` if Supabase sent a confirmation email first.
  /// Throws [AuthException] on failure.
  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    final userId = response.user?.id;
    if (userId != null) {
      // Store extra profile info — best-effort, ignore if profiles table
      // doesn't exist yet.
      try {
        await _client.from('profiles').upsert({
          'id': userId,
          'full_name': name,
          'email': email,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {}
    }

    // session is null when Supabase requires email confirmation first.
    return response.session != null;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Currently authenticated user, null if not signed in.
  User? get currentUser => _client.auth.currentUser;
}
