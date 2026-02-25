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
- AIエージェントが実行可能なSkillの定義
- テスト生成、コード分析、ドキュメント生成の自動化
- 仕様書からテストコードへの自動変換
- 継続的なコード品質改善の自動化

### 5. CI/CD パイプライン
- 自動ビルド・テスト・デプロイ
- プラットフォーム別の自動配布
- コード品質の自動チェック

## プロジェクト構造

```
mobile-project-template/
├── docs/                      # ドキュメント
│   ├── requirements/          # 要件定義書
│   ├── specifications/        # 仕様書
│   └── architecture/          # アーキテクチャ設計
├── lib/                       # Flutter アプリケーションコード
│   ├── main.dart              # エントリーポイント
│   ├── screens/               # 画面実装
│   ├── widgets/               # 再利用可能なウィジェット
│   ├── models/                # データモデル
│   ├── services/              # ビジネスロジック
│   ├── utils/                 # ユーティリティ
│   └── providers/             # 状態管理（Provider等）
├── test/                      # ユニットテスト
├── integration_test/          # 統合テスト・E2Eテスト
├── skills/                    # AIエージェント向けSkills定義
│   ├── test_generation/       # テスト生成スキル
│   ├── code_analysis/         # コード分析スキル
│   ├── spec_generation/       # 仕様書生成スキル
│   ├── documentation/         # ドキュメント生成スキル
│   └── refactoring/           # リファクタリングスキル
├── ios/                       # iOS プラットフォーム設定
├── android/                   # Android プラットフォーム設定
├── web/                       # Web プラットフォーム設定
├── .ai/                       # AI設定ファイル
│   └── skills.yaml            # Skills定義
├── pubspec.yaml               # 依存パッケージ管理
├── pubspec.lock               # 依存パッケージロック
└── .github/
    └── workflows/             # CI/CD設定
```

## 開発フロー

### ステップ 1: 要件定義
- ステークホルダーからの要件収集
- 要件の明確化と優先順位付け
- AIを活用した要件の自動検証

### ステップ 2: 仕様書生成（SDD）+ AI Skills活用
- AIエージェントが要件から仕様書を自動生成
- `spec_generation` Skillを利用した仕様書生成
- 全プラットフォーム共通の仕様として統一
- チーム全体での仕様書レビュー

### ステップ 3: テスト設計・実装（TDD）+ AI Skills活用
- `test_generation` Skillを利用したテストコード自動生成
- 仕様に基づいたテストケース設計
- テストコード先行開発
- テスト実装段階でのバグ検出

### ステップ 4: 機能実装
- テストを満たすための実装
- `code_analysis` Skillによるコード品質チェック（静的解析）
- 同期開発による複数プラットフォーム対応

### ステップ 5: コード最適化・ドキュメント生成
- `refactoring` Skillによるコード提案と最適化
- `documentation` Skillによるドキュメント自動生成
- インラインコメントの自動生成

### ステップ 6: 統合テスト・検証
- プラットフォーム別の統合テスト
- エンドツーエンドテスト実行
- ユーザーアクセプタンステスト（UAT）

### ステップ 7: CI/CD パイプライン
- 自動ビルド・テスト実行
- 静的コード解析（Skills経由）
- 自動デプロイメント

## 技術スタック

### フロントエンド
- **言語**: Dart
- **フレームワーク**: Flutter
- **状態管理**: Provider / Riverpod / Bloc（選択可）
- **UIライブラリ**: Material Design / Cupertino

### テスト
- **ユニットテスト**: test パッケージ
- **ウィジェットテスト**: flutter_test パッケージ
- **統合・E2Eテスト**: integration_test パッケージ

### プラットフォーム対応
- **Web**: Flutter web
- **Android**: Flutter + Android SDK
- **iOS**: Flutter + Xcode

### AIエージェント・Skills
- **Skills定義**: `.ai/skills.yaml`
- **テスト生成**: Dartテストコード自動生成
- **コード分析**: 静的解析・品質メトリクス分析
- **仕様書生成**: 要件から仕様書への自動変換
- **ドキュメント生成**: コードドキュメント自動生成
- **リファクタリング**:コード改善提案

### CI/CD
- **GitHub Actions** による自動テスト・ビルド・デプロイ
- **自動テスト実行**: GitHub Actions ワークフロー
- **コード解析**: analysis_options.yaml + Skills
- **AI連携**: GitHub Copilot / Claude等のAIエージェント統合
- **環境構築**: Docker（オプション）

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

# 開発環境の確認
flutter doctor

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

### Available Skills（利用可能なスキル）

#### 1. test_generation（テスト生成スキル）
```
仕様書やコードから自動的にテストコードを生成し、TDD フローを加速します。
- ユニットテストの自動生成
- ウィジェットテストの自動生成
- テストケースの網羅性確保
```

#### 2. code_analysis（コード解析スキル）
```
コード品質を自動的に分析し、改善提案を提供します。
- 静的コード解析（lint チェック）
- 複雑度メトリクス計算
- セキュリティ脆弱性検出
- 命名規則チェック
```

#### 3. spec_generation（仕様書生成スキル）
```
要件定義から自動的に仕様書を生成します。
- 自然言語から仕様書への変換
- ユースケース図の自動生成
- API 仕様書の自動生成
- UI/UX 要件の自動抽出
```

#### 4. documentation（ドキュメント生成スキル）
```
コードから自動的にドキュメントを生成します。
- README の自動生成
- API ドキュメント生成
- アーキテクチャドキュメント生成
- セットアップガイド生成
```

#### 5. refactoring（リファクタリングスキル）
```
コード設計の改善提案を提供します。
- デザインパターン提案
- コード最適化提案
- アーキテクチャ改善提案
- テストコード改善
```

### Skills 連携フロー

```
要件定義
  ↓
[spec_generation] → 仕様書生成
  ↓
[test_generation] → テストコード生成
  ↓
機能実装
  ↓
[code_analysis] → コード品質チェック
  ↓
[documentation] → ドキュメント生成
  ↓
[refactoring] → コード改善提案
  ↓
CI/CD パイプライン
  ↓
デプロイ
```

### Skills の使用例

#### スキルの実行方法
```dart
// Dart コードから Skills を利用する場合の構造例
// （具体的な実装は skills/ ディレクトリを参照）

final testCode = await aiAgent.executeSkill(
  skill: 'test_generation',
  input: specificationDocument,
  options: {
    'testType': 'unit',
    'coverage': '80%',
  },
);
```

### AI エージェント連携

#### 推奨される AI エージェント・プラットフォーム
- **Claude** (Anthropic)
- **GitHub Copilot**
- **ChatGPT** (OpenAI)
- **その他の LLM ベースのエージェント**

#### 連携ポイント
- IDE（VS Code）での Copilot 拡張機能
- CLI ツールとしての AI エージェント実行
- GitHub Actions あるいは CI/CD パイプラインでの自動実行
- チャットインターフェースでの対話的利用

## CI/CD パイプライン

本プロジェクトは GitHub Actions を使用した自動化フローを実装しています：

- **Push時**: 自動テスト実行 & コード品質チェック（Skills 活用）
- **PR時**: 自動テスト + コードレビュー自動化（AI分析）
- **Merge時**: ステージング環境へのデプロイ
- **リリース時**: 本番環境への自動デプロイ

## AI Skills ベストプラクティス

1. **早期の Skills 活用**: 要件定義段階から spec_generation を活用
2. **品質メトリクスの活用**: code_analysis の結果に基づいた改善
3. **ドキュメント最優先**: documentation を通じた組織知の蓄積
4. **継続的なリファクタリング**: refactoring スキルによる段階的改善
5. **人間のレビューの組み込み**: AI 生成コードの最終確認は人間が実施

## 貢献ガイドライン

1. 要件に基づいてテストコードを先に作成（TDD）
2. AI スキル（`test_generation`、`code_analysis`）を活用して効率化
3. `spec_generation` スキルで仕様書と実装の一貫性を保証
4. すべてのテストが合格することを確認
5. コード品質チェック（`code_analysis`）に合格
6. `refactoring` スキルで改善提案を確認
7. `documentation` スキルで自動ドキュメント生成
8. Pull Request を作成

## 関連リソース

### 公式ドキュメント
- [Flutter 公式ドキュメント](https://flutter.dev/docs)
- [Dart 言語ガイド](https://dart.dev/guides)
- [GitHub Actions ドキュメント](https://docs.github.com/en/actions)

### 開発ガイド
- [Flutter アーキテクチャベストプラクティス](docs/architecture/)
- [テスト戦略ガイド](docs/)
- [AI Skills 詳細ガイド](skills/README.md)

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。詳細は[LICENSE](LICENSE)ファイルを参照してください。

## サポート

問題が発生した場合は、[Issue Tracker URL] で報告してください。

## 連絡先

[チーム/プロジェクト担当者の連絡先]
