import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mobile_project_template/providers/auth_provider.dart';
import 'package:mobile_project_template/screens/home_screen.dart';
import 'package:mobile_project_template/services/mock_auth_service.dart';

void main() {
  group('HomeScreen', () {
    late MockAuthService mockAuthService;
    late AuthProvider authProvider;

    setUp(() async {
      mockAuthService = MockAuthService();
      authProvider = AuthProvider(mockAuthService);
      // ログイン状態にする
      await authProvider.login('test@example.com', 'password123');
    });

    tearDown(() {
      authProvider.dispose();
    });

    Widget buildSubject() {
      return MaterialApp(
        home: ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
          child: const HomeScreen(),
        ),
      );
    }

    group('初期表示', () {
      testWidgets('AppBarにタイトルが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.text('Mobile Project Template'), findsOneWidget);
      });

      testWidgets('ウェルカムメッセージが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.text('Welcome to Mobile Project Template'), findsOneWidget);
      });

      testWidgets('ログイン中のユーザーメールが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.text('ログイン中: test@example.com'), findsOneWidget);
      });

      testWidgets('ログアウトボタンが表示されること', (tester) async {
        await tester.pumpWidget(buildSubject());

        expect(find.byKey(const Key('logout_button')), findsOneWidget);
      });
    });

    group('ログアウト', () {
      testWidgets('ログアウトボタンタップでisLoggedInがfalseになること',
          (tester) async {
        await tester.pumpWidget(buildSubject());

        await tester.tap(find.byKey(const Key('logout_button')));
        await tester.pumpAndSettle();

        expect(authProvider.isLoggedIn, isFalse);
      });
    });
  });
}
