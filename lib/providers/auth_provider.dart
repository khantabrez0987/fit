import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  // Initialize auth state listener
  void initialize() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      
      if (result?.user != null) {
        _user = result!.user;
        _setLoading(false);
        return true;
      }
      return false;
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
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result?.user != null) {
        _user = result!.user;
        _setLoading(false);
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _user = null;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
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

