import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/models/async_state.dart';
import 'package:mobile_project_template/widgets/async_state_builder.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('AsyncStateBuilder', () {
    group('initial状態', () {
      testWidgets('デフォルトでは空のWidgetが表示されること', (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.initial(),
            onSuccess: (data) => Text(data),
          ),
        ));

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('onInitialが指定されている場合にカスタムWidgetが表示されること',
          (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.initial(),
            onSuccess: (data) => Text(data),
            onInitial: () => const Text('初期状態'),
          ),
        ));

        expect(find.text('初期状態'), findsOneWidget);
      });
    });

    group('loading状態', () {
      testWidgets('デフォルトでCircularProgressIndicatorが表示されること',
          (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.loading(),
            onSuccess: (data) => Text(data),
          ),
        ));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('onLoadingが指定されている場合にカスタムWidgetが表示されること',
          (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.loading(),
            onSuccess: (data) => Text(data),
            onLoading: () => const Text('読み込み中...'),
          ),
        ));

        expect(find.text('読み込み中...'), findsOneWidget);
      });
    });

    group('success状態', () {
      testWidgets('onSuccessで構築されたWidgetが表示されること', (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.success('テストデータ'),
            onSuccess: (data) => Text('成功: $data'),
          ),
        ));

        expect(find.text('成功: テストデータ'), findsOneWidget);
      });
    });

    group('failure状態', () {
      testWidgets('デフォルトのエラー表示にエラーメッセージが含まれること',
          (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.failure('接続エラー'),
            onSuccess: (data) => Text(data),
          ),
        ));

        expect(find.text('接続エラー'), findsOneWidget);
      });

      testWidgets('onRetryが指定されている場合にリトライボタンが表示されること',
          (tester) async {
        var retryCount = 0;

        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.failure('エラー'),
            onSuccess: (data) => Text(data),
            onRetry: () => retryCount++,
          ),
        ));

        expect(find.text('再試行'), findsOneWidget);

        await tester.tap(find.text('再試行'));
        expect(retryCount, 1);
      });

      testWidgets('onFailureが指定されている場合にカスタムWidgetが表示されること',
          (tester) async {
        await tester.pumpWidget(createTestableWidget(
          AsyncStateBuilder<String>(
            state: AsyncState.failure('カスタムエラー'),
            onSuccess: (data) => Text(data),
            onFailure: (error, _) => Text('カスタム: $error'),
          ),
        ));

        expect(find.text('カスタム: カスタムエラー'), findsOneWidget);
      });
    });
  });
}
