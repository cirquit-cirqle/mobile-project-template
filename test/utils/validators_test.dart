import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/utils/validators.dart';

void main() {
  group('Validators', () {
    group('email', () {
      test('有効なメールアドレスの場合にnullを返すこと', () {
        expect(Validators.email('test@example.com'), isNull);
        expect(Validators.email('user.name@domain.co.jp'), isNull);
        expect(Validators.email('user-name@domain.com'), isNull);
      });

      test('空文字の場合にエラーメッセージを返すこと', () {
        expect(Validators.email(''), 'メールアドレスを入力してください');
      });

      test('nullの場合にエラーメッセージを返すこと', () {
        expect(Validators.email(null), 'メールアドレスを入力してください');
      });

      test('不正な形式の場合にエラーメッセージを返すこと', () {
        expect(Validators.email('invalid'), isNotNull);
        expect(Validators.email('invalid@'), isNotNull);
        expect(Validators.email('@domain.com'), isNotNull);
        expect(Validators.email('user@.com'), isNotNull);
      });
    });

    group('password', () {
      test('8文字以上の場合にnullを返すこと', () {
        expect(Validators.password('12345678'), isNull);
        expect(Validators.password('password123!'), isNull);
      });

      test('空文字の場合にエラーメッセージを返すこと', () {
        expect(Validators.password(''), 'パスワードを入力してください');
      });

      test('nullの場合にエラーメッセージを返すこと', () {
        expect(Validators.password(null), 'パスワードを入力してください');
      });

      test('8文字未満の場合にエラーメッセージを返すこと', () {
        expect(Validators.password('1234567'), 'パスワードは8文字以上で入力してください');
        expect(Validators.password('a'), 'パスワードは8文字以上で入力してください');
      });

      test('ちょうど8文字の場合にnullを返すこと（境界値）', () {
        expect(Validators.password('abcdefgh'), isNull);
      });
    });

    group('required', () {
      test('値がある場合にnullを返すこと', () {
        expect(Validators.required('値あり'), isNull);
      });

      test('空文字の場合にエラーメッセージを返すこと', () {
        expect(Validators.required(''), '入力してください');
      });

      test('空白のみの場合にエラーメッセージを返すこと', () {
        expect(Validators.required('   '), '入力してください');
      });

      test('nullの場合にエラーメッセージを返すこと', () {
        expect(Validators.required(null), '入力してください');
      });

      test('フィールド名を指定した場合にフィールド名入りメッセージを返すこと', () {
        expect(Validators.required('', '名前'), '名前を入力してください');
        expect(Validators.required(null, 'メールアドレス'), 'メールアドレスを入力してください');
      });
    });

    group('maxLength', () {
      test('最大文字数以内の場合にnullを返すこと', () {
        expect(Validators.maxLength('abc', 5), isNull);
        expect(Validators.maxLength('abcde', 5), isNull);
      });

      test('最大文字数を超える場合にエラーメッセージを返すこと', () {
        expect(Validators.maxLength('abcdef', 5), '5文字以内で入力してください');
      });

      test('nullの場合にnullを返すこと（任意項目対応）', () {
        expect(Validators.maxLength(null, 5), isNull);
      });
    });

    group('minLength', () {
      test('最小文字数以上の場合にnullを返すこと', () {
        expect(Validators.minLength('abcde', 3), isNull);
        expect(Validators.minLength('abc', 3), isNull);
      });

      test('最小文字数未満の場合にエラーメッセージを返すこと', () {
        expect(Validators.minLength('ab', 3), '3文字以上で入力してください');
      });

      test('空文字の場合にnullを返すこと（requiredと組み合わせて使用）', () {
        expect(Validators.minLength('', 3), isNull);
      });

      test('nullの場合にnullを返すこと', () {
        expect(Validators.minLength(null, 3), isNull);
      });
    });
  });
}
