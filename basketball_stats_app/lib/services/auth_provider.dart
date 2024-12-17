// lib/services/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> register(String username, String email, String password) async {
    _user = await _apiService.register(username, email, password);
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _user = await _apiService.login(email, password);
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
