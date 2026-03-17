# CLAUDE.md

Claude Code がこのプロジェクトで実装作業を行う際に従うべきルールを定義する。

**詳細なコーディング規約:** [docs/architecture/06_coding_conventions.md](docs/architecture/06_coding_conventions.md)

コードを生成・修正する際は、規約ファイルの **「11. AIコード生成チェックリスト」** を必ず確認すること。

---

## 命名規則

- クラス・型・enum: `UpperCamelCase`
- 変数・関数・パラメータ: `lowerCamelCase`
- ファイル名: `snake_case`
- bool型: `is` / `has` / `can` / `should` の接頭辞を使う
- 汎用語（`data`, `info`, `manager`, `util`, `process`）は避ける
- 動詞の統一: `fetch`（APIから取得）/ `load`（ローカル取得）/ `save`（永続化）

---

## コメントルール

- コメントは「**なぜ**」を説明する。「何をしているか」はコメントしない
- コードを読めば明らかな内容はコメントしない
- コメントを書く前に、命名やリファクタリングで解決できないか検討する

### ドキュメントコメント（`///`）

- `public` なクラス・メソッド・プロパティには `///` を記述する
- `private` メンバー（`_` プレフィックス）には原則記述しない

```dart
/// ユーザー情報を取得して返す。
///
/// [userId] に対応するユーザーが存在しない場合は `null` を返す。
Future<User?> fetchUser(String userId) async { ... }
```

### インラインコメント（`//`）

以下の場合のみ記述する:

- 外部仕様・API制約・バグ回避のための特殊処理
- アルゴリズムや計算式の意図が不明瞭な場合

```dart
// APIが最大100件しか返さない制約があるため上限を設定
const maxFetchCount = 100;
```

### TODO / FIXME

```dart
// TODO(担当者名): 内容
// FIXME: 既知の問題の説明
```

### 言語

コメントは**日本語**で記述する。

---

## 設計原則

- 1関数は **30行以内**。超える場合はプライベート関数に分割する
- 引数が3個を超える場合は **名前付き引数** を使う
- Widget の `build` は **50行以内**。超えたら子Widgetに分割する
- UIロジックは Widget に書かず **Notifier/Provider** に置く
- 依存はインターフェース経由で注入する（テスタビリティ確保）
- マジックナンバーは **定数に置き換える**
- 変更しない変数には `final`、コンパイル時定数には `const` を使う

---

## AIスキル

以下のタスクを依頼する際は、対応するSkillの `prompt.md` を先に読み込んでから実行すること。

| タスク | Skill | プロンプト |
| --- | --- | --- |
| 仕様書を生成する | spec_generation | [skills/spec_generation/prompt.md](skills/spec_generation/prompt.md) |
| テストコードを生成する | test_generation | [skills/test_generation/prompt.md](skills/test_generation/prompt.md) |
| コード品質を解析する | code_analysis | [skills/code_analysis/prompt.md](skills/code_analysis/prompt.md) |
| ドキュメントを生成する | documentation | [skills/documentation/prompt.md](skills/documentation/prompt.md) |
| リファクタリング提案を行う | refactoring | [skills/refactoring/prompt.md](skills/refactoring/prompt.md) |

スキルの詳細（入力パラメータ・出力先・検証ルール）は各スキルの `config.yaml` を参照すること。

---

## プロジェクト概要

- **フレームワーク:** Flutter（Web / Android / iOS）
- **アーキテクチャ:** クリーンアーキテクチャ（4層構造）
- **状態管理:** Riverpod
- **詳細:** `docs/architecture/` を参照
