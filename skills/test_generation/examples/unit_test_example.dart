/// テスト生成スキル: ユニットテストの出力例
///
/// 入力: lib/models/user.dart の User モデル
/// テスト種別: unit
///
/// ```dart
/// // lib/models/user.dart
/// class User {
///   final String id;
///   final String name;
///   final String email;
///   final DateTime createdAt;
///
///   const User({
///     required this.id,
///     required this.name,
///     required this.email,
///     required this.createdAt,
///   });
///
///   User copyWith({String? id, String? name, String? email, DateTime? createdAt}) { ... }
///   factory User.fromJson(Map<String, dynamic> json) { ... }
///   Map<String, dynamic> toJson() { ... }
/// }
/// ```
library;

import 'package:flutter_test/flutter_test.dart';
// import 'package:mobile_project_template/models/user.dart';

void main() {
  group('User', () {
    // テスト用のフィクスチャ
    final testDate = DateTime(2025, 1, 1);
    // final user = User(
    //   id: 'user-001',
    //   name: 'テストユーザー',
    //   email: 'test@example.com',
    //   createdAt: testDate,
    // );

    group('コンストラクタ', () {
      test('全フィールドが正しく設定されること', () {
        // Arrange & Act
        // final result = User(
        //   id: 'user-001',
        //   name: 'テストユーザー',
        //   email: 'test@example.com',
        //   createdAt: testDate,
        // );

        // Assert
        // expect(result.id, 'user-001');
        // expect(result.name, 'テストユーザー');
        // expect(result.email, 'test@example.com');
        // expect(result.createdAt, testDate);
      });
    });

    group('copyWith', () {
      test('指定したフィールドのみ変更されること', () {
        // Arrange
        // (user フィクスチャを使用)

        // Act
        // final updated = user.copyWith(name: '更新後ユーザー');

        // Assert
        // expect(updated.name, '更新後ユーザー');
        // expect(updated.id, user.id); // 変更していないフィールドは元の値
        // expect(updated.email, user.email);
      });

      test('引数なしで呼び出した場合に同じ値のオブジェクトが返ること', () {
        // Act
        // final copied = user.copyWith();

        // Assert
        // expect(copied, equals(user));
        // expect(identical(copied, user), isFalse); // 別インスタンス
      });
    });

    group('fromJson', () {
      test('有効なJSONからUserが生成されること', () {
        // Arrange
        // final json = {
        //   'id': 'user-001',
        //   'name': 'テストユーザー',
        //   'email': 'test@example.com',
        //   'createdAt': '2025-01-01T00:00:00.000',
        // };

        // Act
        // final result = User.fromJson(json);

        // Assert
        // expect(result.id, 'user-001');
        // expect(result.name, 'テストユーザー');
      });

      test('必須フィールドが欠けている場合にエラーがスローされること', () {
        // Arrange
        // final invalidJson = {'id': 'user-001'}; // name, email, createdAt がない

        // Act & Assert
        // expect(() => User.fromJson(invalidJson), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('全フィールドがJSON形式で出力されること', () {
        // Act
        // final json = user.toJson();

        // Assert
        // expect(json['id'], 'user-001');
        // expect(json['name'], 'テストユーザー');
        // expect(json['email'], 'test@example.com');
        // expect(json.containsKey('createdAt'), isTrue);
      });

      test('fromJson → toJson の往復変換でデータが保持されること', () {
        // Arrange
        // final json = user.toJson();

        // Act
        // final restored = User.fromJson(json);

        // Assert
        // expect(restored, equals(user));
      });
    });

    group('等価性', () {
      test('同じidのUserは等しいこと', () {
        // Arrange
        // final user1 = User(id: '001', name: 'A', email: 'a@test.com', createdAt: testDate);
        // final user2 = User(id: '001', name: 'B', email: 'b@test.com', createdAt: testDate);

        // Assert
        // expect(user1, equals(user2));
        // expect(user1.hashCode, equals(user2.hashCode));
      });

      test('異なるidのUserは等しくないこと', () {
        // Arrange
        // final user1 = User(id: '001', name: 'A', email: 'a@test.com', createdAt: testDate);
        // final user2 = User(id: '002', name: 'A', email: 'a@test.com', createdAt: testDate);

        // Assert
        // expect(user1, isNot(equals(user2)));
      });
    });
  });
}
