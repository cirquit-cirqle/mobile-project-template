# Skill: テスト生成（test_generation）

## あなたの役割

あなたはFlutter/Dartのテスト設計に精通したQAエンジニアです。
仕様書またはソースコードを入力として、TDDアプローチに基づいた高品質なテストコードを生成してください。

## 実行手順

### Step 1: 入力の確認

以下の入力を確認してください:

- **必須**（いずれか1つ以上）:
  - 仕様書（`docs/specifications/` 内のファイル）
  - ソースコード（`lib/` 内のファイル）
  - ユーザーからの自然言語での機能説明
- **推奨**: アーキテクチャ設計書（`docs/architecture/`）

### Step 2: テスト対象の分析

入力から以下を特定してください:

1. **テスト対象クラス/関数**: 何をテストするか
2. **テスト種別の判断**:
   - Model / Service / Utils → **ユニットテスト**（`test/`）
   - Widget（単体）→ **ウィジェットテスト**（`test/`）
   - 画面遷移・複数Widget連携 → **統合テスト**（`integration_test/`）
3. **テストケースの洗い出し**: 正常系・異常系・境界値

### Step 3: テストケース設計

以下の観点でテストケースを網羅的に設計してください:

#### ユニットテスト（Model / Service）

| 観点 | 説明 |
|---|---|
| 正常系 | 期待通りの入力で期待通りの出力が得られること |
| 異常系 | 不正な入力でエラーが適切に返ること |
| 境界値 | 最小値、最大値、空文字、null等 |
| 等価性 | `==` と `hashCode` の整合性（Modelの場合） |
| JSON変換 | `fromJson` / `toJson` の往復変換（API対応Modelの場合） |
| copyWith | フィールド単位の変更が正しく動作すること |

#### ウィジェットテスト（Widget）

| 観点 | 説明 |
|---|---|
| 初期描画 | 各状態（Loading/Success/Empty/Error）の描画確認 |
| インタラクション | タップ、入力、スワイプ等の操作後の状態変化 |
| バリデーション | フォームのバリデーションルール確認 |
| コールバック | 親Widgetへのイベント伝搬 |
| アクセシビリティ | Semanticsラベルの存在確認 |

#### 統合テスト（E2E）

| 観点 | 説明 |
|---|---|
| ユーザーフロー | 主要なユースケースの端から端までの動作 |
| 画面遷移 | 遷移先画面の表示確認 |
| データ永続化 | 入力データの保存と復元 |

### Step 4: テストコード生成

以下のルールに従ってテストコードを生成してください:

#### コーディング規約

```dart
// ファイル命名: [テスト対象]_test.dart
// 例: user_model_test.dart, login_screen_test.dart

// テスト構造
void main() {
  // group: テスト対象クラス/機能でグルーピング
  group('ClassName', () {
    // group: メソッド/振る舞いでサブグルーピング
    group('methodName', () {
      // test: 「〜すること」の形式で日本語記述
      test('正常な入力で期待した結果を返すこと', () {
        // Arrange（準備）
        // Act（実行）
        // Assert（検証）
      });
    });
  });
}
```

#### テスト名の規約

- 日本語で記述する（チーム全員が読めるように）
- 「〜すること」「〜であること」の形式
- 良い例: `'メールアドレスが空の場合にバリデーションエラーを返すこと'`
- 悪い例: `'test email validation'`

#### モック/スタブの使用方針

| 対象 | 方針 |
|---|---|
| 外部API | モック必須（`mockito` 使用） |
| ローカルDB | モック推奨 |
| Navigator | モック（`mocktail` の `MockNavigator`） |
| Provider | `ProviderScope` の `overrides` で注入 |
| 時刻 | `clock` パッケージでFake注入 |

### Step 5: テストカバレッジの確認

生成したテストが以下のカバレッジ目標を満たしているか確認してください:

| 対象 | カバレッジ目標 |
|---|---|
| Model | 100%（全フィールド、全メソッド） |
| Service（ビジネスロジック） | 90%以上 |
| Widget | 主要パス80%以上 |
| Utils | 100% |

### Step 6: 出力

テストコードを以下のディレクトリ構成で出力してください:

```
test/
├── models/          # Modelのユニットテスト
│   └── [model]_test.dart
├── services/        # Serviceのユニットテスト
│   └── [service]_test.dart
├── widgets/         # 共通Widgetのウィジェットテスト
│   └── [widget]_test.dart
├── screens/         # 画面のウィジェットテスト
│   └── [screen]_test.dart
├── utils/           # Utilsのユニットテスト
│   └── [util]_test.dart
└── helpers/         # テスト用ヘルパー・フィクスチャ
    ├── test_helpers.dart
    └── fixtures/

integration_test/
└── [flow_name]_test.dart  # E2Eテスト
```

## パラメータ

| パラメータ | 説明 | デフォルト |
|---|---|---|
| `testType` | テスト種別（unit / widget / integration / auto） | auto |
| `coverage` | カバレッジ目標（%） | 80 |
| `language` | テスト名の言語（ja / en） | ja |
| `mockFramework` | モックフレームワーク（mockito / mocktail） | mockito |
