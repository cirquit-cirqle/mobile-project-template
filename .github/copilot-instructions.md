# GitHub Copilot 指示ファイル

このプロジェクトで Copilot を利用する際の指示を定義する。
コーディング規約・設計原則は `CLAUDE.md` および `docs/architecture/06_coding_conventions.md` に準拠すること。

---

## AIスキルの活用

以下のタスクを依頼された場合は、対応するスキルのプロンプトファイルを `#file:` で参照してから実行すること。

| タスク | 参照ファイル |
| --- | --- |
| 仕様書を生成する | `#file:skills/spec_generation/prompt.md` |
| テストコードを生成する | `#file:skills/test_generation/prompt.md` |
| コード品質を解析する | `#file:skills/code_analysis/prompt.md` |
| ドキュメントを生成する | `#file:skills/documentation/prompt.md` |
| リファクタリング提案を行う | `#file:skills/refactoring/prompt.md` |

スキルの入力パラメータ・出力先・検証ルールは各スキルの `config.yaml` を参照すること。
全スキルの統合インデックス: `#file:.ai/skills.yaml`

---

## プロジェクト概要

- **フレームワーク:** Flutter 3.x（Web / Android / iOS）
- **アーキテクチャ:** クリーンアーキテクチャ（4層: Presentation / Domain / Data / Infrastructure）
- **状態管理:** Riverpod
- **言語:** Dart 3.x

---

## 命名規則

- クラス・型・enum: `UpperCamelCase`
- 変数・関数・パラメータ: `lowerCamelCase`
- ファイル名: `snake_case`
- bool型: `is` / `has` / `can` / `should` の接頭辞を使う
- 汎用語（`data`, `info`, `manager`, `util`, `process`）は避ける
- 動詞の統一: `fetch`（APIから取得）/ `load`（ローカル取得）/ `save`（永続化）

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

## コメントルール

- コメントは「**なぜ**」を説明する。「何をしているか」はコメントしない
- `public` なクラス・メソッド・プロパティには `///`（DartDoc）を記述する
- `private` メンバー（`_` プレフィックス）には原則記述しない
- コメントは**日本語**で記述する

---

## テスト規約

- **Arrange-Act-Assert** パターンに統一する
- テスト名は日本語で「〜すること」形式にする（例: `'メールアドレスが空の場合にエラーを返すこと'`）
- 正常系・異常系・境界値を網羅する
- 外部依存はモック化する（mockito 使用）
