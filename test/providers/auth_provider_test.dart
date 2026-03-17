import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/models/result.dart';
import 'package:mobile_project_template/providers/auth_provider.dart';
import 'package:mobile_project_template/services/mock_auth_service.dart';

void main() {
  group('AuthProvider', () {
    late MockAuthService mockAuthService;
    late AuthProvider authProvider;

    setUp(() {
      mockAuthService = MockAuthService();
      authProvider = AuthProvider(mockAuthService);
    });

    tearDown(() {
      authProvider.dispose();
    });

    group('初期状態', () {
      test('isLoggedInがfalseであること', () {
        expect(authProvider.isLoggedIn, isFalse);
      });

      test('userがnullであること', () {
        expect(authProvider.user, isNull);
      });

      test('isLoadingがfalseであること', () {
        expect(authProvider.isLoading, isFalse);
      });

      test('errorがnullであること', () {
        expect(authProvider.error, isNull);
      });
    });

    group('login', () {
      test('正しい認証情報でログインが成功しisLoggedInがtrueになること', () async {
        // Act
        await authProvider.login('test@example.com', 'password123');

        // Assert
        expect(authProvider.isLoggedIn, isTrue);
        expect(authProvider.user, isNotNull);
        expect(authProvider.user!.email, 'test@example.com');
        expect(authProvider.error, isNull);
      });

      test('不正な認証情報でerrorが設定されること', () async {
        // Act
        await authProvider.login('', 'password123');

        // Assert
        expect(authProvider.isLoggedIn, isFalse);
        expect(authProvider.user, isNull);
        expect(authProvider.error, isNotNull);
      });

      test('ログイン中にisLoadingがtrueになること', () async {
        // Arrange
        final loadingStates = <bool>[];
        authProvider.addListener(() {
          loadingStates.add(authProvider.isLoading);
        });

        // Act
        await authProvider.login('test@example.com', 'password123');

        // Assert
        expect(loadingStates, contains(true));
        expect(authProvider.isLoading, isFalse);
      });
    });

    group('logout', () {
      test('ログアウト後にisLoggedInがfalseになること', () async {
        // Arrange
        await authProvider.login('test@example.com', 'password123');
        expect(authProvider.isLoggedIn, isTrue);

        // Act
        await authProvider.logout();

        // Assert
        expect(authProvider.isLoggedIn, isFalse);
        expect(authProvider.user, isNull);
      });
    });

    group('clearError', () {
      test('errorがクリアされること', () async {
        // Arrange
        await authProvider.login('', 'password123');
        expect(authProvider.error, isNotNull);

        // Act
        authProvider.clearError();

        // Assert
        expect(authProvider.error, isNull);
      });
    });
  });
}
