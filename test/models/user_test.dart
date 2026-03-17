import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_project_template/models/user.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('User', () {
    final testDate = TestFixtures.testDate;

    group('コンストラクタ', () {
      test('全フィールドが正しく設定されること', () {
        // Arrange & Act
        final user = User(
          id: 'user-001',
          name: 'テストユーザー',
          email: 'test@example.com',
          createdAt: testDate,
        );

        // Assert
        expect(user.id, 'user-001');
        expect(user.name, 'テストユーザー');
        expect(user.email, 'test@example.com');
        expect(user.createdAt, testDate);
      });
    });

    group('copyWith', () {
      test('指定したフィールドのみ変更されること', () {
        // Arrange
        final user = TestFixtures.createUser();

        // Act
        final updated = user.copyWith(name: '更新後ユーザー');

        // Assert
        expect(updated.name, '更新後ユーザー');
        expect(updated.id, user.id);
        expect(updated.email, user.email);
        expect(updated.createdAt, user.createdAt);
      });

      test('引数なしで呼び出した場合に同じ値のオブジェクトが返ること', () {
        // Arrange
        final user = TestFixtures.createUser();

        // Act
        final copied = user.copyWith();

        // Assert
        expect(copied, equals(user));
        expect(identical(copied, user), isFalse);
      });

      test('複数フィールドを同時に変更できること', () {
        // Arrange
        final user = TestFixtures.createUser();
        final newDate = DateTime(2025, 6, 1);

        // Act
        final updated = user.copyWith(
          name: '新しい名前',
          email: 'new@example.com',
          createdAt: newDate,
        );

        // Assert
        expect(updated.name, '新しい名前');
        expect(updated.email, 'new@example.com');
        expect(updated.createdAt, newDate);
        expect(updated.id, user.id);
      });
    });

    group('fromJson', () {
      test('有効なJSONからUserが生成されること', () {
        // Arrange
        final json = TestFixtures.createUserJson();

        // Act
        final user = User.fromJson(json);

        // Assert
        expect(user.id, 'user-001');
        expect(user.name, 'テストユーザー');
        expect(user.email, 'test@example.com');
        expect(user.createdAt, DateTime(2025, 1, 1));
      });

      test('必須フィールドが欠けている場合にエラーがスローされること', () {
        // Arrange
        final invalidJson = <String, dynamic>{'id': 'user-001'};

        // Act & Assert
        expect(() => User.fromJson(invalidJson), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('全フィールドがJSON形式で出力されること', () {
        // Arrange
        final user = TestFixtures.createUser();

        // Act
        final json = user.toJson();

        // Assert
        expect(json['id'], 'user-001');
        expect(json['name'], 'テストユーザー');
        expect(json['email'], 'test@example.com');
        expect(json.containsKey('createdAt'), isTrue);
      });

      test('fromJson → toJson の往復変換でデータが保持されること', () {
        // Arrange
        final originalJson = TestFixtures.createUserJson();

        // Act
        final user = User.fromJson(originalJson);
        final restoredJson = user.toJson();
        final restoredUser = User.fromJson(restoredJson);

        // Assert
        expect(restoredUser, equals(user));
      });
    });

    group('等価性', () {
      test('同じidのUserは等しいこと', () {
        // Arrange
        final user1 = TestFixtures.createUser(id: '001', name: 'A');
        final user2 = TestFixtures.createUser(id: '001', name: 'B');

        // Assert
        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('異なるidのUserは等しくないこと', () {
        // Arrange
        final user1 = TestFixtures.createUser(id: '001');
        final user2 = TestFixtures.createUser(id: '002');

        // Assert
        expect(user1, isNot(equals(user2)));
      });
    });

    group('toString', () {
      test('読みやすい文字列表現が返ること', () {
        // Arrange
        final user = TestFixtures.createUser();

        // Act
        final result = user.toString();

        // Assert
        expect(result, contains('user-001'));
        expect(result, contains('テストユーザー'));
        expect(result, contains('test@example.com'));
      });
    });
  });
}
