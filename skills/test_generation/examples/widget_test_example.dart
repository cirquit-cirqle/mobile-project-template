/// テスト生成スキル: ウィジェットテストの出力例
///
/// 入力: docs/specifications/01_screen_login.md（ログイン画面仕様）
/// テスト種別: widget
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:provider/provider.dart';
// import 'package:mobile_project_template/screens/login/login_screen.dart';
// import 'package:mobile_project_template/services/auth_service.dart';

// @GenerateMocks([AuthService])
// import 'login_screen_test.mocks.dart';

void main() {
  group('LoginScreen', () {
    // late MockAuthService mockAuthService;

    // setUp(() {
    //   mockAuthService = MockAuthService();
    // });

    // Widget buildSubject() {
    //   return MaterialApp(
    //     home: Provider<AuthService>.value(
    //       value: mockAuthService,
    //       child: const LoginScreen(),
    //     ),
    //   );
    // }

    group('初期表示', () {
      testWidgets('メールアドレスとパスワードの入力フィールドが表示されること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // expect(find.byType(TextFormField), findsNWidgets(2));
        // expect(find.text('メールアドレス'), findsOneWidget);
        // expect(find.text('パスワード'), findsOneWidget);
      });

      testWidgets('ログインボタンが表示されること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // expect(find.widgetWithText(ElevatedButton, 'ログイン'), findsOneWidget);
      });

      testWidgets('「パスワードを忘れた方」リンクが表示されること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // expect(find.text('パスワードを忘れた方'), findsOneWidget);
      });
    });

    group('バリデーション', () {
      testWidgets('メールアドレスが空の場合にエラーが表示されること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // // パスワードのみ入力してログインタップ
        // await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        // await tester.tap(find.text('ログイン'));
        // await tester.pumpAndSettle();
        //
        // expect(find.text('メールアドレスを入力してください'), findsOneWidget);
      });

      testWidgets('不正なメールアドレス形式の場合にエラーが表示されること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // await tester.enterText(find.byKey(const Key('email_field')), 'invalid-email');
        // await tester.tap(find.text('ログイン'));
        // await tester.pumpAndSettle();
        //
        // expect(find.text('有効なメールアドレスを入力してください'), findsOneWidget);
      });

      testWidgets('パスワードが8文字未満の場合にエラーが表示されること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
        // await tester.enterText(find.byKey(const Key('password_field')), 'short');
        // await tester.tap(find.text('ログイン'));
        // await tester.pumpAndSettle();
        //
        // expect(find.text('パスワードは8文字以上で入力してください'), findsOneWidget);
      });
    });

    group('ログイン操作', () {
      testWidgets('有効な入力でログインボタンをタップするとログイン処理が呼ばれること', (tester) async {
        // when(mockAuthService.login(any, any))
        //     .thenAnswer((_) async => User(...));
        //
        // await tester.pumpWidget(buildSubject());
        //
        // await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
        // await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        // await tester.tap(find.text('ログイン'));
        //
        // verify(mockAuthService.login('test@example.com', 'password123')).called(1);
      });

      testWidgets('ログイン処理中にローディング表示されること', (tester) async {
        // when(mockAuthService.login(any, any))
        //     .thenAnswer((_) async {
        //       await Future.delayed(const Duration(seconds: 1));
        //       return User(...);
        //     });
        //
        // await tester.pumpWidget(buildSubject());
        //
        // await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
        // await tester.enterText(find.byKey(const Key('password_field')), 'password123');
        // await tester.tap(find.text('ログイン'));
        // await tester.pump();
        //
        // expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('ログイン失敗時にエラーメッセージがSnackBarで表示されること', (tester) async {
        // when(mockAuthService.login(any, any))
        //     .thenThrow(AuthError(message: 'メールアドレスまたはパスワードが正しくありません'));
        //
        // await tester.pumpWidget(buildSubject());
        //
        // await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
        // await tester.enterText(find.byKey(const Key('password_field')), 'wrongpassword');
        // await tester.tap(find.text('ログイン'));
        // await tester.pumpAndSettle();
        //
        // expect(find.byType(SnackBar), findsOneWidget);
        // expect(find.text('メールアドレスまたはパスワードが正しくありません'), findsOneWidget);
      });
    });

    group('アクセシビリティ', () {
      testWidgets('メールアドレスフィールドにSemanticsラベルが設定されていること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // final semantics = tester.getSemantics(find.byKey(const Key('email_field')));
        // expect(semantics.label, 'メールアドレス入力欄');
      });

      testWidgets('ログインボタンにSemanticsラベルが設定されていること', (tester) async {
        // await tester.pumpWidget(buildSubject());
        //
        // final semantics = tester.getSemantics(find.text('ログイン'));
        // expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
      });
    });
  });
}
