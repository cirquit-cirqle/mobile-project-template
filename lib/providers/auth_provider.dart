import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/result.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/mock_auth_service.dart';

/// 認証状態を管理するProvider
///
/// Presentation層とDomain層の橋渡し。
/// 状態管理方針: docs/architecture/02_state_management.md 参照
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService) {
    _authSubscription = _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
    _user = _authService.currentUser;
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);
      result.when(
        onSuccess: (user) {
          _user = user;
        },
        onFailure: (error) {
          _error = error.message;
        },
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.logout();
      result.when(
        onSuccess: (_) {
          _user = null;
        },
        onFailure: (error) {
          _error = error.message;
        },
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    // MockAuthService の StreamController を確実に閉じる
    final service = _authService;
    if (service is MockAuthService) {
      service.dispose();
    }
    super.dispose();
  }
}
