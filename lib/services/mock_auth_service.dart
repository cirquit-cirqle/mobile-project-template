import 'dart:async';

import '../models/result.dart';
import '../models/user.dart';
import '../utils/validators.dart';
import 'auth_service.dart';

/// AuthService のインメモリ実装（テンプレート用）
///
/// 実プロジェクトでは、Firebase Auth / Auth0 / 自社API 等に差し替える。
/// Data層の実装であり、Domain層のインターフェース（AuthService）に依存する。
/// レイヤー設計: docs/architecture/01_layer_design.md 参照
class MockAuthService implements AuthService {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();
  bool _isDisposed = false;

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<Result<User>> login(String email, String password) async {
    // バリデーション
    final emailError = Validators.email(email);
    if (emailError != null) {
      return Failure(ValidationError(message: emailError));
    }

    final passwordError = Validators.password(password);
    if (passwordError != null) {
      return Failure(ValidationError(message: passwordError));
    }

    // API呼び出しのシミュレーション
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final user = User(
      id: 'user-${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    _authStateController.add(user);

    return Success(user);
  }

  @override
  Future<Result<void>> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    _currentUser = null;
    _authStateController.add(null);

    return const Success(null);
  }

  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _authStateController.close();
    }
  }
}
