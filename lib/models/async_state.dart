/// 非同期処理の状態を表す型
///
/// 全ての非同期データ取得はこの型で状態管理を統一する。
/// UI側の分岐を標準化し、Loading / Success / Empty / Error を漏れなく扱う。
/// アーキテクチャ設計書: docs/architecture/02_state_management.md 参照
enum AsyncStatus { initial, loading, success, failure }

class AsyncState<T> {
  final AsyncStatus status;
  final T? data;
  final String? error;

  const AsyncState._({
    required this.status,
    this.data,
    this.error,
  });

  factory AsyncState.initial() =>
      const AsyncState._(status: AsyncStatus.initial);

  factory AsyncState.loading() =>
      const AsyncState._(status: AsyncStatus.loading);

  factory AsyncState.success(T data) =>
      AsyncState._(status: AsyncStatus.success, data: data);

  factory AsyncState.failure(String error) =>
      AsyncState._(status: AsyncStatus.failure, error: error);

  bool get isInitial => status == AsyncStatus.initial;
  bool get isLoading => status == AsyncStatus.loading;
  bool get isSuccess => status == AsyncStatus.success;
  bool get isFailure => status == AsyncStatus.failure;

  /// 状態に応じたWidgetの出し分けに使用する。
  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String error) failure,
  }) {
    return switch (status) {
      AsyncStatus.initial => initial(),
      AsyncStatus.loading => loading(),
      AsyncStatus.success => success(data as T),
      AsyncStatus.failure => failure(error!),
    };
  }
}
