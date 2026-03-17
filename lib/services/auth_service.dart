import '../models/result.dart';
import '../models/user.dart';

/// 認証サービスのインターフェース（Domain層）
///
/// ビジネスロジックの抽象定義。
/// 実装（Data層）はこのインターフェースに依存し、依存性逆転の原則に従う。
/// レイヤー設計: docs/architecture/01_layer_design.md 参照
abstract class AuthService {
  /// メールアドレスとパスワードでログインする。
  Future<Result<User>> login(String email, String password);

  /// ログアウトする。
  Future<Result<void>> logout();

  /// 現在の認証状態を監視するStream。
  /// null: 未認証、User: 認証済み。
  Stream<User?> get authStateChanges;

  /// 現在ログイン中のユーザーを取得する。
  User? get currentUser;
}
