import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> initialize() async {
    await loadUser();
  }

  Future<void> loadUser() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      
      if (userJson != null) {
        _user = User.fromJson(json.decode(userJson));
      }
    } catch (e) {
      _setError('Failed to load user: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> createUser({
    required String name,
    required String email,
    required DateTime dateOfBirth,
    required String gender,
    required double height,
    required double weight,
    required String fitnessLevel,
    required List<String> goals,
  }) async {
    _setLoading(true);
    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        dateOfBirth: dateOfBirth,
        gender: gender,
        height: height,
        weight: weight,
        fitnessLevel: fitnessLevel,
        goals: goals,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _saveUser(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      _setError('Failed to create user: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUser(User updatedUser) async {
    _setLoading(true);
    try {
      final user = updatedUser.copyWith(updatedAt: DateTime.now());
      await _saveUser(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      _setError('Failed to update user: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    double? weight,
    double? height,
    String? fitnessLevel,
    List<String>? goals,
  }) async {
    if (_user == null) return;

    final updatedUser = _user!.copyWith(
      name: name ?? _user!.name,
      weight: weight ?? _user!.weight,
      height: height ?? _user!.height,
      fitnessLevel: fitnessLevel ?? _user!.fitnessLevel,
      goals: goals ?? _user!.goals,
    );

    await updateUser(updatedUser);
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      _user = null;
      notifyListeners();
    } catch (e) {
      _setError('Failed to logout: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toJson()));
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
