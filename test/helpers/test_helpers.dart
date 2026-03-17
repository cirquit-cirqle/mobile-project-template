import 'package:flutter/material.dart';
import 'package:mobile_project_template/models/user.dart';

/// テスト用のフィクスチャ（共通テストデータ）
///
/// テスト間で共有するサンプルデータを定義する。
/// テスト生成スキル: skills/test_generation/prompt.md 参照
class TestFixtures {
  TestFixtures._();

  static final DateTime testDate = DateTime(2025, 1, 1);

  static User createUser({
    String id = 'user-001',
    String name = 'テストユーザー',
    String email = 'test@example.com',
    DateTime? createdAt,
  }) {
    return User(
      id: id,
      name: name,
      email: email,
      createdAt: createdAt ?? testDate,
    );
  }

  static Map<String, dynamic> createUserJson({
    String id = 'user-001',
    String name = 'テストユーザー',
    String email = 'test@example.com',
    String? createdAt,
  }) {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': createdAt ?? '2025-01-01T00:00:00.000',
    };
  }
}

/// テスト用のWidgetラッパー
///
/// ウィジェットテストで対象Widgetを MaterialApp で囲む共通ヘルパー。
Widget createTestableWidget(Widget child) {
  return MaterialApp(
    home: child,
  );
}
