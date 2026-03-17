import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/models/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('isSuccessがtrueを返すこと', () {
        // Arrange & Act
        const result = Success<String>('データ');

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.isFailure, isFalse);
      });

      test('dataにアクセスできること', () {
        // Arrange & Act
        const result = Success<int>(42);

        // Assert
        expect(result.data, 42);
      });
    });

    group('Failure', () {
      test('isFailureがtrueを返すこと', () {
        // Arrange & Act
        const result = Failure<String>(
          NetworkError(message: '接続エラー'),
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.isSuccess, isFalse);
      });

      test('errorにアクセスできること', () {
        // Arrange & Act
        const result = Failure<String>(
          ApiError(message: 'Not Found', statusCode: 404),
        );

        // Assert
        expect(result.error, isA<ApiError>());
        expect((result.error as ApiError).statusCode, 404);
      });
    });

    group('when', () {
      test('Successの場合にonSuccessが呼ばれること', () {
        // Arrange
        const Result<String> result = Success('データ');

        // Act
        final output = result.when(
          onSuccess: (data) => 'success: $data',
          onFailure: (error) => 'failure: ${error.message}',
        );

        // Assert
        expect(output, 'success: データ');
      });

      test('Failureの場合にonFailureが呼ばれること', () {
        // Arrange
        const Result<String> result = Failure(
          NetworkError(message: 'タイムアウト'),
        );

        // Act
        final output = result.when(
          onSuccess: (data) => 'success: $data',
          onFailure: (error) => 'failure: ${error.message}',
        );

        // Assert
        expect(output, 'failure: タイムアウト');
      });
    });
  });

  group('AppError', () {
    group('NetworkError', () {
      test('message と code が正しく設定されること', () {
        const error = NetworkError(message: '接続エラー', code: 'TIMEOUT');

        expect(error.message, '接続エラー');
        expect(error.code, 'TIMEOUT');
      });
    });

    group('ApiError', () {
      test('statusCode が正しく設定されること', () {
        const error = ApiError(
          message: 'Not Found',
          statusCode: 404,
          code: 'NOT_FOUND',
        );

        expect(error.statusCode, 404);
        expect(error.message, 'Not Found');
        expect(error.code, 'NOT_FOUND');
      });
    });

    group('ValidationError', () {
      test('fieldErrors が正しく設定されること', () {
        const error = ValidationError(
          message: 'バリデーションエラー',
          fieldErrors: {
            'email': ['有効なメールアドレスを入力してください'],
            'password': ['8文字以上で入力してください'],
          },
        );

        expect(error.fieldErrors, hasLength(2));
        expect(error.fieldErrors['email'], contains('有効なメールアドレスを入力してください'));
      });

      test('fieldErrors のデフォルトが空マップであること', () {
        const error = ValidationError(message: 'エラー');

        expect(error.fieldErrors, isEmpty);
      });
    });

    group('AuthError', () {
      test('認証エラーが正しく生成されること', () {
        const error = AuthError(message: 'トークン期限切れ', code: 'TOKEN_EXPIRED');

        expect(error.message, 'トークン期限切れ');
        expect(error.code, 'TOKEN_EXPIRED');
      });
    });

    group('toString', () {
      test('読みやすい文字列が返ること', () {
        const error = NetworkError(message: '接続エラー', code: 'TIMEOUT');

        expect(error.toString(), 'AppError(TIMEOUT: 接続エラー)');
      });

      test('codeがnullの場合もエラーにならないこと', () {
        const error = NetworkError(message: '接続エラー');

        expect(error.toString(), 'AppError(null: 接続エラー)');
      });
    });
  });
}
