import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project_template/providers/auth_provider.dart';
import 'package:mobile_project_template/screens/login_screen.dart';
import 'package:mobile_project_template/services/auth_service.dart';
import 'package:mobile_project_template/services/mock_auth_service.dart';

void main() {
  group('LoginScreen', () {
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
    });

    Widget buildSubject({NavigatorObserver? observer}) {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(mockAuthService),
          child: const LoginScreen(),
        ),
        navigatorObservers: observer != null ? [observer] : [],
      );
    }

    group('初期表示', () {
      testWidgets('メールアドレスとパスワードの入力フィールドが表示されること',
          (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.byKey(const Key('email_field')), findsOneWidget);
        expect(find.byKey(const Key('password_field')), findsOneWidget);
      });

      testWidgets('ログインボタンが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.byKey(const Key('login_button')), findsOneWidget);
        expect(find.text('ログイン'), findsOneWidget);
      });
    });

    group('バリデーション', () {
      testWidgets('メールアドレスが空の場合にエラーが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        // パスワードのみ入力
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        expect(find.text('メールアドレスを入力してください'), findsOneWidget);
      });

      testWidgets('パスワードが空の場合にエラーが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        // メールアドレスのみ入力
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        expect(find.text('パスワードを入力してください'), findsOneWidget);
      });

      testWidgets('不正なメールアドレスの場合にエラーが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        await tester.enterText(
          find.byKey(const Key('email_field')),
          'invalid-email',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        expect(find.text('有効なメールアドレスを入力してください'), findsOneWidget);
      });

      testWidgets('8文字未満のパスワードの場合にエラーが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'short',
        );
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pumpAndSettle();

        expect(find.text('パスワードは8文字以上で入力してください'), findsOneWidget);
      });
    });

    group('ログイン操作', () {
      testWidgets('有効な入力でログイン処理が実行されること', (tester) async {
        await tester.pumpWidget(buildSubject());

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

        // AuthProviderのログイン状態が変わっていること
        final context = tester.element(find.byType(LoginScreen));
        final provider = Provider.of<AuthProvider>(context, listen: false);
        expect(provider.isLoggedIn, isTrue);
      });

      testWidgets('ログイン処理中にローディング表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        await tester.enterText(
          find.byKey(const Key('email_field')),
          'test@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.byKey(const Key('login_button')));
        await tester.pump();

        // ローディング中はCircularProgressIndicatorが表示される
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    });
  });
}
