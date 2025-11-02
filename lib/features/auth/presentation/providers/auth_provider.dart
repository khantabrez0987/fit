import 'package:flutter/material.dart';
import '../../../../shared/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize auth state listener
  void initialize() {}

  // Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // In-memory fake user creation
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        profileImageUrl: null,
        dateOfBirth: DateTime(2000, 1, 1),
        gender: 'unspecified',
        height: 170,
        weight: 70,
        fitnessLevel: 'beginner',
        goals: const ['Stay fit'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Accept any credentials and sign in as an in-memory user
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@').first,
        email: email,
        profileImageUrl: null,
        dateOfBirth: DateTime(2000, 1, 1),
        gender: 'unspecified',
        height: 170,
        weight: 70,
        fitnessLevel: 'beginner',
        goals: const ['Stay fit'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    _user = null;
    _setLoading(false);
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    // No-op for in-memory auth
    await Future.delayed(const Duration(milliseconds: 300));
    _setLoading(false);
    return true;
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    _setLoading(true);
    _clearError();

    if (_user == null) {
      _setLoading(false);
      return false;
    }
    _user = _user!.copyWith(
      name: displayName ?? _user!.name,
      profileImageUrl: photoURL ?? _user!.profileImageUrl,
      updatedAt: DateTime.now(),
    );
    _setLoading(false);
    notifyListeners();
    return true;
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

