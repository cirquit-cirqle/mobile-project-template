# プロジェクト Skills ガイド

## 1. Skills とは

`skills/` ディレクトリはツール非依存のプロンプトライブラリである。
Claude Code・GitHub Copilot・ChatGPT など、どの AI ツールからでも参照できる設計になっている。

各 AI ツールが持つ「組み込みSkill」とは異なり、このプロジェクト固有の開発ワークフローを
定義したプロンプトテンプレート集である。

---

## 2. ディレクトリ構成

```
.ai/
└── skills.yaml            # 全スキルの統合インデックス（登録エントリーポイント）
skills/
├── spec_generation/
│   ├── config.yaml        # トリガー・入力・出力・検証ルールの定義
│   ├── prompt.md          # AI エージェントへの指示テンプレート
│   └── examples/          # Few-shot 用の入出力例
├── test_generation/
├── code_analysis/
├── documentation/
└── refactoring/
```

各Skillは `config.yaml`（動作設定）と `prompt.md`（実行プロンプト）の2ファイルで構成される。
`.ai/skills.yaml` が全スキルへの参照を一元管理する統合インデックスとして機能する。

---

## 3. AI ツール別の利用方法

自動登録の仕組みはなく、各 AI ツールのコンテキスト読み込み機能を通じて利用する。

### Claude Code

`CLAUDE.md` にスキル参照テーブルが記載されているため、対象タスクを依頼するだけで
Claude が自動的に対応する `prompt.md` を読み込む。

手動で指定する場合:

```
skills/spec_generation/prompt.md を読んで、ログイン機能の仕様書を生成して
```

### GitHub Copilot

`.github/copilot-instructions.md` にスキル参照テーブルが記載されているため、
Copilot Chat でタスクを依頼すると対応スキルの参照が促される。

`#file:` 構文で明示的に添付することもできる:

```
#file:skills/spec_generation/prompt.md
ログイン機能の仕様書を生成して
```

### ChatGPT / その他 LLM

`prompt.md` の内容をコピーしてシステムプロンプトまたは最初のメッセージとして貼り付ける。

### CI/CD（GitHub Actions）

`.ai/skills.yaml` を参照して、AI エージェントを呼び出すワークフローステップを定義する。

---

## 4. 開発フローとスキルの対応

```
要件定義（docs/requirements/）
  ↓
[spec_generation] → 仕様書生成（docs/specifications/）
  ↓
[test_generation] → テストコード生成（test/ / integration_test/）
  ↓
機能実装（lib/）
  ↓
[code_analysis]  → コード品質チェック（100点スコアリング）
  ↓
[refactoring]    → コード改善提案
  ↓
[documentation]  → ドキュメント生成
```

---

## 5. 各スキルのリファレンス

### spec_generation（仕様書生成）

要件定義から詳細仕様書を自動生成する。`docs/requirements/` の内容を読み込み、`docs/specifications/` に出力する。

トリガーコマンド:

```
仕様書を生成 / スペックを作成 / spec generation
```

入力パラメータ:

| パラメータ | 必須 | 説明 | デフォルト |
| --- | --- | --- | --- |
| requirements | ○ | 対象の要件（要件IDまたは自然言語） | — |
| specType | — | 生成種別（screen / component / api / model / auto） | auto |
| detail | — | 詳細度（standard / detailed） | standard |

出力先（specType に応じて `docs/specifications/` 配下に生成される）:

| specType | 出力ファイル |
| --- | --- |
| screen | `docs/specifications/01_screen_*.md` |
| component | `docs/specifications/02_component_*.md` |
| api | `docs/specifications/03_api_*.md` |
| model | `docs/specifications/04_model_*.md` |

---

### test_generation（テストコード生成）

仕様書やコードからテストコードを自動生成し、TDDフローを加速する。

トリガーコマンド:

```
テストを生成 / テストコードを作成 / test generation
```

入力パラメータ:

| パラメータ | 必須 | 説明 | デフォルト |
| --- | --- | --- | --- |
| target | ○ | 仕様書パス・ソースコードパス・または機能説明 | — |
| testType | — | テスト種別（unit / widget / integration / auto） | auto |
| coverage | — | カバレッジ目標（%） | 80 |
| mockFramework | — | モックフレームワーク（mockito / mocktail） | mockito |

出力先:

- `test/**/*_test.dart`
- `integration_test/**/*_test.dart`（integration / auto の場合）

---

### code_analysis（コード品質解析）

コード品質を自動分析し、重大度別に改善提案を出力する。

トリガーコマンド:

```
コードを解析 / コード品質チェック / code analysis
```

入力パラメータ:

| パラメータ | 必須 | 説明 | デフォルト |
| --- | --- | --- | --- |
| target | ○ | 解析対象パス（ファイルまたはディレクトリ） | `lib/` |
| scope | — | 解析範囲（file / directory / project） | project |
| severity | — | 出力する最低重大度（critical / high / medium / low） | low |

出力形式: サマリーテーブル・スコア・重大度別検出事項・改善提案をMarkdownで出力する。

---

### documentation（ドキュメント生成）

コードから各種ドキュメントを自動生成する。

トリガーコマンド:

```
ドキュメントを生成 / ドキュメント作成 / documentation
```

入力パラメータ:

| パラメータ | 必須 | 説明 | デフォルト |
| --- | --- | --- | --- |
| docType | ○ | 種別（api_doc / architecture_doc / setup_guide / changelog / inline_comments） | — |
| target | ○ | 対象パス | `lib/` |
| audience | — | 想定読者（developer / stakeholder / new_member） | developer |
| language | — | 記述言語（ja / en） | ja |

---

### refactoring（リファクタリング提案）

コードスメルを検出し、優先度付きの改善提案を提供する。

トリガーコマンド:

```
リファクタリング / コード改善 / refactoring
```

入力パラメータ:

| パラメータ | 必須 | 説明 | デフォルト |
| --- | --- | --- | --- |
| target | ○ | リファクタリング対象パス | — |
| focus | — | コードスメルカテゴリ（all / bloaters / change_preventers / dispensables / flutter） | all |
| autoApply | — | 安全な変更を自動適用するか | false |

> 注意: `autoApply: false`（デフォルト）の場合、コード変更は行わず提案のみ出力される。
> テストが存在しない場合は先に `test_generation` の実行を推奨する。
