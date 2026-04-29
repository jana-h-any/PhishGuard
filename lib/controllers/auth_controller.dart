import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/gmail_service.dart';

class AuthController extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/gmail.readonly',
    ],
    serverClientId: '88793191194-2i9hsd0754047jd395shp0qklsfqpn5b.apps.googleusercontent.com',
  );

  final GmailService _gmailService;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  AuthController(this._gmailService);

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<bool> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final account = await _googleSignIn.signIn();
      if (account == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Request Gmail scope explicitly
      await _googleSignIn.requestScopes([
        'https://www.googleapis.com/auth/gmail.readonly',
      ]);

      // Get access token directly
      final auth = await account.authentication;
      final accessToken = auth.accessToken;
      debugPrint('=== ACCESS TOKEN: ${accessToken != null ? "present" : "NULL"}');

      if (accessToken == null) {
        _error = 'Failed to get access token';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Initialize Gmail with the access token directly
      _gmailService.initialize(accessToken);

      _user = UserModel(
        id: account.id,
        email: account.email,
        displayName: account.displayName ?? account.email.split('@').first,
        photoUrl: account.photoUrl,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Sign in failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }

  Future<bool> checkExistingSignIn() async {
    try {
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        final auth = await account.authentication;
        if (auth.accessToken != null) {
          _gmailService.initialize(auth.accessToken!);
          _user = UserModel(
            id: account.id,
            email: account.email,
            displayName: account.displayName ?? account.email.split('@').first,
            photoUrl: account.photoUrl,
          );
          notifyListeners();
          return true;
        }
      }
    } catch (_) {}
    return false;
  }
}