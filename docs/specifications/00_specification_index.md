# 仕様書 インデックス

## 概要

本ディレクトリは、要件定義書から導出された詳細仕様を管理するテンプレート群です。
各仕様書は対応する要件ID（FR-XXX）とトレーサビリティを保ちます。

## ドキュメント構成

| # | テンプレート | 用途 | 記述単位 |
| --- | --- | --- | --- |
| 01 | [画面仕様テンプレート](01_screen_spec_template.md) | 各画面のUI・振る舞い仕様 | 1画面 = 1ドキュメント |
| 02 | [コンポーネント仕様テンプレート](02_component_spec_template.md) | 再利用Widgetの仕様 | 1コンポーネント = 1ドキュメント |
| 03 | [API仕様テンプレート](03_api_spec_template.md) | バックエンドAPIインターフェース | 1エンドポイント or 1リソース = 1セクション |
| 04 | [データモデル仕様テンプレート](04_data_model_spec_template.md) | エンティティ・値オブジェクトの定義 | 1モデル = 1セクション |

## 仕様書の命名規則

``` text
[テンプレート番号]_[カテゴリ]_[名前].md

例:
  01_screen_login.md           # ログイン画面仕様
  01_screen_home.md            # ホーム画面仕様
  02_component_button.md       # ボタンコンポーネント仕様
  03_api_auth.md               # 認証API仕様
  04_model_user.md             # Userモデル仕様
```

## トレーサビリティ

全ての仕様項目は、要件定義書の要件IDに紐づけること。

``` text
要件（FR-001） → 仕様（画面仕様 / API仕様） → テスト（test/ のテストケース）
```

| 要件ID | 仕様書 | 実装ファイル | テストファイル |
| --- | --- | --- | --- |
| FR-C01 | 01_screen_login.md | lib/screens/login_screen.dart | test/screens/login_screen_test.dart |
| FR-C01 | 02_component_async_state_builder.md | lib/widgets/async_state_builder.dart | test/widgets/async_state_builder_test.dart |
| FR-C01 | (auth_service) | lib/services/auth_service.dart, lib/services/mock_auth_service.dart | test/services/mock_auth_service_test.dart |
| FR-C01 | (auth_provider) | lib/providers/auth_provider.dart | test/providers/auth_provider_test.dart |
| FR-C01 | (home_screen) | lib/screens/home_screen.dart | test/screens/home_screen_test.dart |
| — | (user_model) | lib/models/user.dart | test/models/user_test.dart |
| — | (result_model) | lib/models/result.dart | test/models/result_test.dart |
| — | (async_state_model) | lib/models/async_state.dart | test/models/async_state_test.dart |
| — | (validators) | lib/utils/validators.dart | test/utils/validators_test.dart |
| E2E | — | lib/main.dart | integration_test/app_test.dart |

## レビュープロセス

1. 仕様書の Draft 作成（AI Skills `spec_generation` の活用推奨）
2. 開発者レビュー（技術的実現可能性の確認）
3. デザイナーレビュー（UI/UX仕様の場合）
4. ステークホルダー承認
5. ステータスを `Approved` に更新
6. テストコード作成へ進む（TDD）
