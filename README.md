# Mobile Project Template

モバイル開発における要件定義からテストまでを効率的に進めるための、モノレポ管理型のプロジェクトテンプレートです。

## 概要

このテンプレートは、AIを活用した仕様駆動開発（SDD）とテスト駆動開発（TDD）のベストプラクティスを組み合わせた、高品質なモバイルアプリケーション開発を実現します。

## 対応OS

- **Web**
- **Android**
- **iOS**

すべてのプラットフォームに統一された要件管理と開発フローにより、クロスプラットフォーム開発の効率化を実現します。

## 主な特徴

### 1. 仕様駆動開発（SDD）+ AI活用

- AIを活用した自動仕様生成と検証
- 自然言語による要件からの仕様書自動生成
- 仕様の一貫性確保との品質向上

### 2. テスト駆動開発（TDD）

- テストファーストのアプローチ
- ユニットテスト、統合テスト、エンドツーエンドテストの完全カバー
- テストコードの品質によるアプリケーション品質の保証

### 3. モノレポ管理

- 複数プラットフォーム（Web/Android/iOS）の一元管理
- 共通ロジックの共有化
- 要件定義からテストまでの統一された管理フロー

### 4. AIエージェント・Skillsの活用

- AIエージェントが実行可能なSkillの定義（プロンプト + 設定 + 入出力例）
- テスト生成、コード分析、ドキュメント生成の自動化
- 仕様書からテストコードへの自動変換
- 継続的なコード品質改善の自動化

### 5. CI/CD パイプライン

- 自動ビルド・テスト・デプロイ
- プラットフォーム別の自動配布
- コード品質の自動チェック

## プロジェクト構造

``` text
mobile-project-template/
├── docs/                              # ドキュメント
│   ├── requirements/                  # 要件定義書
│   │   ├── 00_requirements_index.md   #   要件管理インデックス（ステータス・優先度・ID規則）
│   │   ├── 01_functional_requirements.md #   機能要件（ユーザーストーリー・画面一覧・機能詳細）
│   │   ├── 02_non_functional_requirements.md # 非機能要件（性能・セキュリティ・a11y・i18n 全78項目）
│   │   └── 03_constraint_requirements.md #   制約条件（技術・ビジネス・法的・運用）
│   ├── specifications/                # 仕様書
│   │   ├── 00_specification_index.md  #   仕様管理インデックス（トレーサビリティ）
│   │   ├── 01_screen_spec_template.md #   画面仕様テンプレート
│   │   ├── 02_component_spec_template.md # コンポーネント仕様テンプレート
│   │   ├── 03_api_spec_template.md    #   API仕様テンプレート
│   │   └── 04_data_model_spec_template.md # データモデル仕様テンプレート
│   └── architecture/                  # アーキテクチャ設計
│       ├── 00_architecture_overview.md #  全体像・設計原則・技術スタック
│       ├── 01_layer_design.md         #   4層レイヤー設計（Presentation/Domain/Data/Infrastructure）
│       ├── 02_state_management.md     #   状態管理方針（5分類・判断フロー・キャッシュ戦略）
│       ├── 03_navigation_routing.md   #   画面遷移・ルーティング・ディープリンク設計
│       ├── 04_error_handling.md       #   エラー分類・処理戦略・リトライ・ログ基準
│       └── 05_adr_template.md         #   ADR（アーキテクチャ決定記録）テンプレート
├── lib/                               # Flutter アプリケーションコード
│   ├── main.dart                      # エントリーポイント
│   ├── screens/                       # 画面実装
│   │   └── home_screen.dart           #   ホーム画面
│   ├── widgets/                       # 再利用可能なウィジェット
│   ├── models/                        # データモデル（Domain層）
│   │   ├── user.dart                  #   Userエンティティ（Immutable・copyWith・JSON変換・等価性）
│   │   ├── result.dart                #   Result型 + AppErrorヒエラルキー（sealed class）
│   │   └── async_state.dart           #   非同期状態管理（initial/loading/success/failure）
│   ├── services/                      # ビジネスロジック（Domain層）
│   │   └── auth_service.dart          #   認証サービスインターフェース
│   ├── utils/                         # ユーティリティ
│   │   └── validators.dart            #   バリデーション関数群（email・password・required等）
│   └── providers/                     # 状態管理（Provider等）
├── test/                              # ユニットテスト・ウィジェットテスト
│   ├── helpers/                       #   テスト共通ヘルパー
│   │   └── test_helpers.dart          #     フィクスチャ・Widgetラッパー
│   ├── models/                        #   モデルのユニットテスト
│   │   ├── user_test.dart             #     User: 9テストケース
│   │   ├── result_test.dart           #     Result/AppError: 10テストケース
│   │   └── async_state_test.dart      #     AsyncState: 10テストケース
│   ├── utils/                         #   ユーティリティのユニットテスト
│   │   └── validators_test.dart       #     Validators: 16テストケース（正常/異常/境界値）
│   └── screens/                       #   画面のウィジェットテスト
│       └── home_screen_test.dart      #     HomeScreen: 2テストケース
├── integration_test/                  # 統合テスト・E2Eテスト
│   └── app_test.dart                  #   アプリ起動→ホーム画面表示
├── skills/                            # AIエージェント向けSkills定義
│   ├── spec_generation/               # 仕様書生成スキル
│   │   ├── prompt.md                  #   AIへの指示テンプレート（5ステップ手順）
│   │   ├── config.yaml                #   パラメータ・入出力・バリデーション定義
│   │   └── examples/                  #   入出力例（ログイン機能の要件→仕様書変換例）
│   ├── test_generation/               # テスト生成スキル
│   │   ├── prompt.md                  #   テスト設計観点・コーディング規約・モック方針
│   │   ├── config.yaml                #   テスト種別・カバレッジ目標のパラメータ
│   │   └── examples/                  #   ユニットテスト・ウィジェットテストの出力例
│   ├── code_analysis/                 # コード解析スキル
│   │   ├── prompt.md                  #   5カテゴリ解析基準・100点スコアリング
│   │   └── config.yaml                #   解析範囲・カテゴリ・重大度フィルタ
│   ├── documentation/                 # ドキュメント生成スキル
│   │   ├── prompt.md                  #   5種のドキュメント生成手順
│   │   └── config.yaml                #   ドキュメント種別・想定読者のパラメータ
│   └── refactoring/                   # リファクタリングスキル
│       ├── prompt.md                  #   コードスメル検出・デザインパターン提案
│       └── config.yaml                #   対象範囲・自動適用の安全ルール
├── ios/                               # iOS プラットフォーム設定
├── android/                           # Android プラットフォーム設定
├── web/                               # Web プラットフォーム設定
├── .ai/                               # AI設定ファイル
│   └── skills.yaml                    # Skills統合インデックス（全5スキルの定義・実行順序）
├── .github/
│   └── workflows/
│       └── ci.yml                     # CI/CD（テスト・解析・Web/Android/iOSビルド）
├── pubspec.yaml                       # 依存パッケージ管理
├── analysis_options.yaml              # 静的解析ルール
└── .gitignore                         # Git除外設定
```

## アーキテクチャ

本テンプレートは、クリーンアーキテクチャの思想をベースにした4層構造を採用しています。

``` text
┌─────────────────────────────────────────────┐
│              Presentation Layer              │
│  screens/ ・ widgets/ ・ providers/          │
├─────────────────────────────────────────────┤
│              Domain Layer                    │
│  models/ ・ services/（インターフェース）     │
├─────────────────────────────────────────────┤
│              Data Layer                      │
│  services/（実装クラス）・DTO               │
├─────────────────────────────────────────────┤
│              Infrastructure Layer            │
│  HTTP Client ・ Local Storage ・ Platform    │
└─────────────────────────────────────────────┘

依存方向: Presentation → Domain ← Data → Infrastructure
```

### 設計原則

| 原則 | 説明 |
| --- | --- |
| **関心の分離** | UI・ビジネスロジック・データアクセスを明確に分離 |
| **依存性逆転** | 上位レイヤーは下位レイヤーの抽象（インターフェース）に依存 |
| **テスタビリティ** | 全てのビジネスロジックがユニットテスト可能 |
| **Immutable な状態管理** | 状態はイミュータブルなオブジェクトとして管理 |

### 組み込みパターン

テンプレートには以下の実装パターンがサンプルコードとして含まれています:

| パターン | ファイル | 用途 |
| --- | --- | --- |
| Immutableエンティティ | `lib/models/user.dart` | `const` コンストラクタ、`copyWith`、JSON変換、等価性 |
| Result型 | `lib/models/result.dart` | 例外ではなく戻り値でエラーを表現（`sealed class`） |
| AppErrorヒエラルキー | `lib/models/result.dart` | Network / API / Validation / Auth の型安全なエラー分類 |
| AsyncState | `lib/models/async_state.dart` | 非同期処理の状態統一（initial / loading / success / failure） |
| サービスインターフェース | `lib/services/auth_service.dart` | Domain層の抽象定義（依存性逆転、テスタビリティ確保） |
| バリデーション | `lib/utils/validators.dart` | クライアント側の共通バリデーション関数群 |

詳細は [docs/architecture/](docs/architecture/) を参照してください。

## 要件定義テンプレート

`docs/requirements/` に、モバイル/Webフロントエンド開発で必ず考慮すべき要件を網羅したテンプレートを用意しています。

| ドキュメント | 主な内容 |
| --- | --- |
| [機能要件](docs/requirements/01_functional_requirements.md) | ユーザーストーリー、画面一覧、機能詳細、共通機能（認証・オフライン・通知・ディープリンク） |
| [非機能要件](docs/requirements/02_non_functional_requirements.md) | パフォーマンス、セキュリティ、可用性、アクセシビリティ、レスポンシブ、国際化、互換性、保守性、法令対応（全78項目） |
| [制約条件](docs/requirements/03_constraint_requirements.md) | 技術制約、ビジネス制約、法的制約、ストア審査、運用制約、既存システム連携 |

テンプレート内の `<!-- [PLACEHOLDER] -->` 部分をプロジェクト固有の内容に置換して使用してください。
管理ルール（ステータス・優先度・ID体系・変更管理プロセス）は [インデックス](docs/requirements/00_requirements_index.md) を参照。

## 仕様書テンプレート

`docs/specifications/` に、要件から導出された詳細仕様を記述するための4種のテンプレートを用意しています。

| テンプレート | 記述単位 | 主なセクション |
| --- | --- | --- |
| [画面仕様](docs/specifications/01_screen_spec_template.md) | 1画面 = 1ドキュメント | レイアウト、UI要素、状態遷移、インタラクション、レスポンシブ、a11y、エラー表示、分析イベント |
| [コンポーネント仕様](docs/specifications/02_component_spec_template.md) | 1コンポーネント = 1ドキュメント | Props、バリエーション、状態、振る舞い、デザイントークン、テスト観点 |
| [API仕様](docs/specifications/03_api_spec_template.md) | 1リソース = 1ドキュメント | 共通ヘッダー・エラーコード、CRUD全エンドポイント、レート制限、Dart実装ガイド |
| [データモデル仕様](docs/specifications/04_data_model_spec_template.md) | 1モデル = 1セクション | フィールド定義、リレーション、ER図、Enum、命名規則、コード生成ガイド |

全仕様書は要件IDとのトレーサビリティを保ちます。詳細は [仕様管理インデックス](docs/specifications/00_specification_index.md) を参照。

## テスト戦略

TDD（テスト駆動開発）に基づき、テストコード先行で開発を進めます。

### テスト構成

| テスト種別 | ディレクトリ | 対象 | カバレッジ目標 |
| --- | --- | --- | --- |
| ユニットテスト | `test/models/` | Model（User, Result, AsyncState） | 100% |
| ユニットテスト | `test/utils/` | Validators等のユーティリティ | 100% |
| ウィジェットテスト | `test/screens/` | 画面Widget | 主要パス80% |
| 統合テスト | `integration_test/` | 画面遷移・ユーザーフロー | 主要フロー全カバー |

### テストコードの規約

- **Arrange-Act-Assert** パターンに統一
- テスト名は日本語で「〜すること」形式（例: `'メールアドレスが空の場合にエラーを返すこと'`）
- **正常系・異常系・境界値** を網羅
- 共通テストデータは `test/helpers/test_helpers.dart` の `TestFixtures` で管理

### テストの実行

```bash
# 全ユニットテスト・ウィジェットテストの実行
flutter test

# カバレッジ付きで実行
flutter test --coverage

# 特定ファイルのみ実行
flutter test test/models/user_test.dart

# 統合テスト（デバイス/エミュレータが必要）
flutter test integration_test/
```

## 開発フロー

### ステップ 1: 要件定義

- `docs/requirements/` のテンプレートに要件を記入
- ステークホルダーからの要件収集と優先度付け（P0〜P3）
- 機能要件・非機能要件・制約条件の3カテゴリで整理

### ステップ 2: 仕様書生成（SDD）+ AI Skills活用

- `docs/specifications/` のテンプレートに詳細仕様を記述
- `spec_generation` Skillを利用した仕様書の自動生成
- 要件IDとのトレーサビリティを確保
- チーム全体での仕様書レビュー

### ステップ 3: テスト設計・実装（TDD）+ AI Skills活用

- `test_generation` Skillを利用したテストコード自動生成
- 仕様に基づいたテストケース設計（正常系・異常系・境界値）
- テストコード先行開発（Arrange-Act-Assert パターン）
- テスト実装段階でのバグ検出

### ステップ 4: 機能実装

- テストを満たすための実装
- `docs/architecture/01_layer_design.md` のレイヤー設計に従ったコード配置
- `code_analysis` Skillによるコード品質チェック（100点スコアリング）

### ステップ 5: コード最適化・ドキュメント生成

- `refactoring` Skillによるコードスメル検出と改善提案
- `documentation` Skillによるドキュメント自動生成
- インラインコメント（DartDoc）の自動生成

### ステップ 6: 統合テスト・検証

- `integration_test/` によるプラットフォーム別の統合テスト
- エンドツーエンドテスト実行
- ユーザーアクセプタンステスト（UAT）

### ステップ 7: CI/CD パイプライン

- GitHub Actions による自動テスト・ビルド実行（`.github/workflows/ci.yml`）
- 静的コード解析（`analysis_options.yaml` + Skills）
- Web / Android / iOS のプラットフォーム別ビルド

## 技術スタック

### フロントエンド

- **言語**: Dart 3.x
- **フレームワーク**: Flutter 3.x
- **状態管理**: Provider / Riverpod / Bloc（選択可）
- **UIライブラリ**: Material Design / Cupertino

### テスト

- **ユニットテスト**: `test` パッケージ
- **ウィジェットテスト**: `flutter_test` パッケージ
- **統合・E2Eテスト**: `integration_test` パッケージ

### プラットフォーム対応

- **Web**: Flutter web
- **Android**: Flutter + Android SDK
- **iOS**: Flutter + Xcode

### AIエージェント・Skills

各スキルは `prompt.md`（AIへの指示）+ `config.yaml`（パラメータ定義）+ `examples/`（入出力例）の3要素で構成されています。

| スキル | ディレクトリ | 主な機能 |
| --- | --- | --- |
| **spec_generation** | `skills/spec_generation/` | 要件→仕様書変換、テンプレート準拠の構造化出力、整合性チェック |
| **test_generation** | `skills/test_generation/` | ユニット/ウィジェット/統合テスト自動生成、モック生成、カバレッジ確保 |
| **code_analysis** | `skills/code_analysis/` | Lint・アーキテクチャ・複雑度・セキュリティ・パフォーマンスの5カテゴリ解析、100点スコアリング |
| **documentation** | `skills/documentation/` | APIドキュメント・アーキテクチャドキュメント・セットアップガイド・CHANGELOG生成 |
| **refactoring** | `skills/refactoring/` | コードスメル検出、デザインパターン提案、優先度付き改善提案 |

統合定義ファイル: `.ai/skills.yaml`

### CI/CD

- **GitHub Actions** による自動テスト・ビルド・デプロイ（`.github/workflows/ci.yml`）
- **自動テスト実行**: ユニットテスト + カバレッジレポート
- **静的コード解析**: `flutter analyze`（`analysis_options.yaml` ルール適用）
- **プラットフォーム別ビルド**: Web / Android APK / iOS（署名なし）
- **AI連携**: GitHub Copilot / Claude 等のAIエージェント統合

## セットアップ

### 前提条件

- Flutter 3.0+
- Dart 3.0+
- Git
- Xcode 14+（iOS開発の場合）
- Android Studio 2023.1+（Android開発の場合）
- Chrome（Web開発の場合）

### インストール

```bash
# リポジトリのクローン
git clone <repository-url>
cd mobile-project-template

# Flutter の依存パッケージをダウンロード
flutter pub get

# プラットフォーム設定の生成（初回のみ）
flutter create .

# 開発環境の確認
flutter doctor

# テストの実行
flutter test

# 開発サーバーの起動（デバイスを選択）
flutter run

# Web版の起動
flutter run -d chrome

# Android版のビルド
flutter build apk

# iOS版のビルド
flutter build ios
```

## AI エージェント・Skills の活用

本プロジェクトは、AI エージェント（Claude等）と連携し、高速で高品質な開発を実現します。

### Skills 連携フロー

``` text
要件定義（docs/requirements/）
  ↓
[spec_generation] → 仕様書生成（docs/specifications/）
  ↓
[test_generation] → テストコード生成（test/ ・ integration_test/）
  ↓
機能実装（lib/）
  ↓
[code_analysis] → コード品質チェック（100点スコアリング）
  ↓
[refactoring] → コード改善提案
  ↓
[documentation] → ドキュメント生成
  ↓
CI/CD パイプライン（.github/workflows/ci.yml）
  ↓
デプロイ
```

### スキルの構成

各スキルは以下の3ファイルで定義されています:

``` text
skills/[skill_name]/
├── prompt.md      # AIエージェントへの指示テンプレート
├── config.yaml    # パラメータ・入出力・実行条件の定義
└── examples/      # 入出力の具体例（Few-shot用）
```

### AI エージェント連携

#### 推奨される AI エージェント・プラットフォーム

- **Claude** (Anthropic)
- **GitHub Copilot**
- **ChatGPT** (OpenAI)
- **その他の LLM ベースのエージェント**

#### 連携ポイント

- IDE（VS Code）での Copilot 拡張機能
- CLI ツールとしての AI エージェント実行（Claude Code等）
- GitHub Actions での CI/CD パイプラインでの自動実行
- チャットインターフェースでの対話的利用

## CI/CD パイプライン

本プロジェクトは GitHub Actions（`.github/workflows/ci.yml`）を使用した自動化フローを実装しています:

| トリガー | 実行内容 |
| --- | --- |
| **Push（main）** | 依存取得 → 静的解析 → ユニットテスト → カバレッジレポート |
| **PR（main）** | 上記 + コードレビュー自動化（AI分析） |
| **テスト成功後** | Web / Android / iOS のプラットフォーム別ビルド |
| **リリース時** | 本番環境への自動デプロイ |

## AI Skills ベストプラクティス

1. **早期の Skills 活用**: 要件定義段階から `spec_generation` を活用
2. **品質メトリクスの活用**: `code_analysis` の100点スコアリングに基づいた改善
3. **ドキュメント最優先**: `documentation` を通じた組織知の蓄積
4. **継続的なリファクタリング**: `refactoring` スキルによる段階的改善
5. **人間のレビューの組み込み**: AI 生成コードの最終確認は人間が実施

## 貢献ガイドライン

1. `docs/requirements/` に要件を記入
2. `spec_generation` スキルで仕様書を生成
3. `test_generation` スキルでテストコードを先に作成（TDD）
4. テストを満たす実装コードを作成
5. `code_analysis` スキルでコード品質チェック（目標: 80点以上）
6. `refactoring` スキルで改善提案を確認
7. `documentation` スキルで自動ドキュメント生成
8. すべてのテストが合格することを確認（`flutter test`）
9. Pull Request を作成

## 関連リソース

### 公式ドキュメント

- [Flutter 公式ドキュメント](https://flutter.dev/docs)
- [Dart 言語ガイド](https://dart.dev/guides)
- [GitHub Actions ドキュメント](https://docs.github.com/en/actions)

### プロジェクト内ドキュメント

- [アーキテクチャ設計](docs/architecture/) - 4層レイヤー設計、状態管理、画面遷移、エラーハンドリング
- [要件定義テンプレート](docs/requirements/) - 機能要件・非機能要件・制約条件
- [仕様書テンプレート](docs/specifications/) - 画面・コンポーネント・API・データモデル
- [AI Skills定義](skills/) - 各スキルのプロンプト・設定・入出力例

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE.md)ファイルを参照してください。

## サポート

問題が発生した場合は、[Issue Tracker URL] で報告してください。

## 連絡先

[チーム/プロジェクト担当者の連絡先]
