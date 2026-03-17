/// 共通バリデーション関数
///
/// クライアント側のバリデーションルールを集約する。
/// フォームのバリデーションおよびサービス層での入力検証に使用。
class Validators {
  Validators._();

  /// メールアドレスの形式チェック
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスを入力してください';
    }
    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return '有効なメールアドレスを入力してください';
    }
    return null;
  }

  /// パスワードの形式チェック
  ///
  /// 最低8文字以上を要求する。
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    if (value.length < 8) {
      return 'パスワードは8文字以上で入力してください';
    }
    return null;
  }

  /// 必須入力チェック
  static String? required(String? value, [String fieldName = '']) {
    if (value == null || value.trim().isEmpty) {
      return fieldName.isNotEmpty ? '$fieldNameを入力してください' : '入力してください';
    }
    return null;
  }

  /// 最大文字数チェック
  static String? maxLength(String? value, int max) {
    if (value != null && value.length > max) {
      return '$max文字以内で入力してください';
    }
    return null;
  }

  /// 最小文字数チェック
  static String? minLength(String? value, int min) {
    if (value != null && value.isNotEmpty && value.length < min) {
      return '$min文字以上で入力してください';
    }
    return null;
  }
}
