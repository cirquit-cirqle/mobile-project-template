import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/models/result.dart';
import 'package:mobile_project_template/models/user.dart';
import 'package:mobile_project_template/services/auth_service.dart';
import 'package:mobile_project_template/services/mock_auth_service.dart';

void main() {
  group('MockAuthService', () {
    late MockAuthService authService;

    setUp(() {
      authService = MockAuthService();
    });

    group('login', () {
      test('正しい認証情報でログインが成功すること', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        // Act
        final result = await authService.login(email, password);

        // Assert
        expect(result.isSuccess, isTrue);
        result.when(
          onSuccess: (user) {
            expect(user.email, email);
            expect(user.name, isNotEmpty);
          },
          onFailure: (_) => fail('ログインが成功すべき'),
        );
      });

      test('空のメールアドレスでバリデーションエラーが返ること', () async {
        // Act
        final result = await authService.login('', 'password123');

        // Assert
        expect(result.isFailure, isTrue);
        result.when(
          onSuccess: (_) => fail('エラーが返るべき'),
          onFailure: (error) {
            expect(error, isA<ValidationError>());
          },
        );
      });

      test('空のパスワードでバリデーションエラーが返ること', () async {
        // Act
        final result = await authService.login('test@example.com', '');

        // Assert
        expect(result.isFailure, isTrue);
        result.when(
          onSuccess: (_) => fail('エラーが返るべき'),
          onFailure: (error) {
            expect(error, isA<ValidationError>());
          },
        );
      });

      test('不正なメールアドレスでバリデーションエラーが返ること', () async {
        // Act
        final result = await authService.login('invalid', 'password123');

        // Assert
        expect(result.isFailure, isTrue);
        result.when(
          onSuccess: (_) => fail('エラーが返るべき'),
          onFailure: (error) {
            expect(error, isA<ValidationError>());
          },
        );
      });

      test('8文字未満のパスワードでバリデーションエラーが返ること', () async {
        // Act
        final result = await authService.login('test@example.com', 'short');

        // Assert
        expect(result.isFailure, isTrue);
        result.when(
          onSuccess: (_) => fail('エラーが返るべき'),
          onFailure: (error) {
            expect(error, isA<ValidationError>());
          },
        );
      });

      test('ログイン成功後にcurrentUserが設定されること', () async {
        // Arrange
        expect(authService.currentUser, isNull);

        // Act
        await authService.login('test@example.com', 'password123');

        // Assert
        expect(authService.currentUser, isNotNull);
        expect(authService.currentUser!.email, 'test@example.com');
      });

      test('ログイン成功後にauthStateChangesがUserを通知すること', () async {
        // Arrange
        final states = <User?>[];
        authService.authStateChanges.listen(states.add);

        // Act
        await authService.login('test@example.com', 'password123');
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states, isNotEmpty);
        expect(states.last, isNotNull);
        expect(states.last!.email, 'test@example.com');
      });
    });

    group('logout', () {
      test('ログアウト後にcurrentUserがnullになること', () async {
        // Arrange
        await authService.login('test@example.com', 'password123');
        expect(authService.currentUser, isNotNull);

        // Act
        final result = await authService.logout();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(authService.currentUser, isNull);
      });

      test('ログアウト後にauthStateChangesがnullを通知すること', () async {
        // Arrange
        await authService.login('test@example.com', 'password123');
        final states = <User?>[];
        authService.authStateChanges.listen(states.add);

        // Act
        await authService.logout();
        await Future<void>.delayed(Duration.zero);

        // Assert
        expect(states.last, isNull);
      });
    });
  });
}
