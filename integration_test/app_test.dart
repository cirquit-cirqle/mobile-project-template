import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_project_template/main.dart';
import 'package:mobile_project_template/services/mock_auth_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E: 認証フロー', () {
    testWidgets('アプリ起動時にログイン画面が表示されること',
        (WidgetTester tester) async {
      final authService = MockAuthService();
      await tester.pumpWidget(MyApp(authService: authService));
      await tester.pumpAndSettle();

      expect(find.text('Mobile Project Template'), findsOneWidget);
      expect(find.text('ログイン'), findsOneWidget);
    });

    testWidgets('ログイン成功後にホーム画面に遷移すること',
        (WidgetTester tester) async {
      final authService = MockAuthService();
      await tester.pumpWidget(MyApp(authService: authService));
      await tester.pumpAndSettle();

      // メールアドレスとパスワードを入力
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );

      // ログインボタンをタップ
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // ホーム画面が表示される
      expect(find.text('Welcome to Mobile Project Template'), findsOneWidget);
      expect(find.text('ログイン中: test@example.com'), findsOneWidget);
    });

    testWidgets('ログアウト後にログイン画面に戻ること',
        (WidgetTester tester) async {
      final authService = MockAuthService();
      await tester.pumpWidget(MyApp(authService: authService));
      await tester.pumpAndSettle();

      // ログイン
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // ログアウト
      await tester.tap(find.byKey(const Key('logout_button')));
      await tester.pumpAndSettle();

      // ログイン画面に戻る
      expect(find.text('ログイン'), findsOneWidget);
    });
  });
}
