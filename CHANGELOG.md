# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [0.1.0] - 2026-03-17

### Added

- **Phase 1: ドキュメント基盤**
  - 要件定義テンプレート (functional / non-functional / constraint)
  - アーキテクチャ設計書 (レイヤー設計 / 状態管理 / 画面遷移 / エラーハンドリング / ADR)
  - 仕様書テンプレート (画面 / コンポーネント / API / データモデル)

- **Phase 2: AI Skills 定義**
  - spec_generation — 要件から仕様書を自動生成
  - test_generation — 仕様書からテストコードを自動生成
  - code_analysis — 100点満点のコード品質スコアリング
  - documentation — ドキュメント自動生成
  - refactoring — コードスメル検出と改善提案

- **Phase 3: テストコード (TDD)**
  - モデルテスト: User, Result, AsyncState
  - ユーティリティテスト: Validators
  - サービステスト: MockAuthService
  - プロバイダーテスト: AuthProvider
  - ウィジェットテスト: LoginScreen, HomeScreen, AsyncStateBuilder
  - E2Eテスト: 認証フロー (login → home → logout)

- **Phase 4: 機能実装**
  - ログイン画面 (SCR-001, FR-C01)
  - ホーム画面 (ログアウト対応)
  - AuthService インターフェース + MockAuthService
  - AuthProvider (ChangeNotifier) による認証状態管理
  - Result / AsyncState パターン
  - AsyncStateBuilder 汎用ウィジェット
  - Validators ユーティリティ

- **Phase 5: 品質・自動化**
  - code_analysis 実施 (スコア: 77 → 改善後推定 85+)
  - StreamController ライフサイクル管理の改善 (MockAuthService)
  - AuthProvider による MockAuthService の dispose 保証
  - logout エラーハンドリング追加 (HomeScreen + AuthProvider)
  - トレーサビリティマトリクス更新
  - GitHub Actions CI/CD パイプライン (test → build-web → build-android → build-ios)
