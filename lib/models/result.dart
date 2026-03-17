/// 処理結果を表す型
///
/// 例外ではなく戻り値でエラーを表現し、エラーハンドリング漏れを防ぐ。
/// アーキテクチャ設計書: docs/architecture/04_error_handling.md 参照
sealed class Result<T> {
  const Result();

  /// 成功時は [onSuccess]、失敗時は [onFailure] を実行する。
  R when<R>({
    required R Function(T data) onSuccess,
    required R Function(AppError error) onFailure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => onSuccess(data),
      Failure<T>(error: final error) => onFailure(error),
    };
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

/// アプリケーション共通エラー型
///
/// レイヤー間のエラー伝搬に使用する。
/// Infrastructure層で発生した例外をこの型に変換してDomain層に返す。
sealed class AppError {
  final String message;
  final String? code;

  const AppError({required this.message, this.code});

  @override
  String toString() => 'AppError($code: $message)';
}

class NetworkError extends AppError {
  const NetworkError({required super.message, super.code});
}

class ApiError extends AppError {
  final int statusCode;
  const ApiError({
    required super.message,
    required this.statusCode,
    super.code,
  });
}

class ValidationError extends AppError {
  final Map<String, List<String>> fieldErrors;
  const ValidationError({
    required super.message,
    this.fieldErrors = const {},
    super.code,
  });
}

class AuthError extends AppError {
  const AuthError({required super.message, super.code});
}
