import 'package:flutter/material.dart';

import '../models/async_state.dart';

/// AsyncState の4状態に応じたWidgetの出し分けを標準化する共通コンポーネント
///
/// コンポーネント仕様: docs/specifications/02_component_async_state_builder.md 参照
/// 状態管理方針: docs/architecture/02_state_management.md 参照
class AsyncStateBuilder<T> extends StatelessWidget {
  final AsyncState<T> state;
  final Widget Function(T data) onSuccess;
  final Widget Function()? onLoading;
  final Widget Function(String error, VoidCallback? retry)? onFailure;
  final Widget Function()? onInitial;
  final VoidCallback? onRetry;

  const AsyncStateBuilder({
    super.key,
    required this.state,
    required this.onSuccess,
    this.onLoading,
    this.onFailure,
    this.onInitial,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => onInitial?.call() ?? const SizedBox.shrink(),
      loading: () =>
          onLoading?.call() ??
          const Center(child: CircularProgressIndicator()),
      success: (data) => onSuccess(data),
      failure: (error) =>
          onFailure?.call(error, onRetry) ??
          _DefaultErrorWidget(error: error, onRetry: onRetry),
    );
  }
}

class _DefaultErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const _DefaultErrorWidget({required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('再試行'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
