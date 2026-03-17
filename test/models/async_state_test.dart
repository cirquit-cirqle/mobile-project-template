import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/models/async_state.dart';

void main() {
  group('AsyncState', () {
    group('ファクトリコンストラクタ', () {
      test('initial状態が正しく生成されること', () {
        final state = AsyncState<String>.initial();

        expect(state.isInitial, isTrue);
        expect(state.isLoading, isFalse);
        expect(state.isSuccess, isFalse);
        expect(state.isFailure, isFalse);
        expect(state.data, isNull);
        expect(state.error, isNull);
      });

      test('loading状態が正しく生成されること', () {
        final state = AsyncState<String>.loading();

        expect(state.isLoading, isTrue);
        expect(state.isInitial, isFalse);
        expect(state.data, isNull);
      });

      test('success状態がデータ付きで正しく生成されること', () {
        final state = AsyncState<String>.success('データ');

        expect(state.isSuccess, isTrue);
        expect(state.data, 'データ');
        expect(state.error, isNull);
      });

      test('failure状態がエラーメッセージ付きで正しく生成されること', () {
        final state = AsyncState<String>.failure('エラー発生');

        expect(state.isFailure, isTrue);
        expect(state.error, 'エラー発生');
        expect(state.data, isNull);
      });
    });

    group('status プロパティ', () {
      test('各状態でstatusが正しいenum値を返すこと', () {
        expect(AsyncState<String>.initial().status, AsyncStatus.initial);
        expect(AsyncState<String>.loading().status, AsyncStatus.loading);
        expect(AsyncState<String>.success('x').status, AsyncStatus.success);
        expect(AsyncState<String>.failure('e').status, AsyncStatus.failure);
      });
    });

    group('when', () {
      test('initial状態で正しいコールバックが呼ばれること', () {
        final state = AsyncState<String>.initial();

        final result = state.when(
          initial: () => 'initial',
          loading: () => 'loading',
          success: (data) => 'success: $data',
          failure: (error) => 'failure: $error',
        );

        expect(result, 'initial');
      });

      test('loading状態で正しいコールバックが呼ばれること', () {
        final state = AsyncState<String>.loading();

        final result = state.when(
          initial: () => 'initial',
          loading: () => 'loading',
          success: (data) => 'success: $data',
          failure: (error) => 'failure: $error',
        );

        expect(result, 'loading');
      });

      test('success状態でデータが渡されること', () {
        final state = AsyncState<String>.success('テストデータ');

        final result = state.when(
          initial: () => 'initial',
          loading: () => 'loading',
          success: (data) => 'success: $data',
          failure: (error) => 'failure: $error',
        );

        expect(result, 'success: テストデータ');
      });

      test('failure状態でエラーメッセージが渡されること', () {
        final state = AsyncState<String>.failure('接続エラー');

        final result = state.when(
          initial: () => 'initial',
          loading: () => 'loading',
          success: (data) => 'success: $data',
          failure: (error) => 'failure: $error',
        );

        expect(result, 'failure: 接続エラー');
      });
    });

    group('型パラメータ', () {
      test('int型で正しく動作すること', () {
        final state = AsyncState<int>.success(42);

        expect(state.data, 42);
        expect(state.isSuccess, isTrue);
      });

      test('List型で正しく動作すること', () {
        final state = AsyncState<List<String>>.success(['a', 'b', 'c']);

        expect(state.data, hasLength(3));
        expect(state.data, contains('b'));
      });
    });
  });
}
