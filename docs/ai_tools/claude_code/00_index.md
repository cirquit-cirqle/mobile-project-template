# Claude Code ガイド

このディレクトリは、Claude Code 固有の設定・機能の活用ガイドをまとめたものである。

> プロジェクトの AI Skills（`skills/` ディレクトリ）は Claude Code 専用ではないため
> [docs/ai_tools/](../00_index.md) を参照すること。

## ドキュメント一覧

| # | ドキュメント | 内容 |
| --- | --- | --- |
| 01 | [CLAUDE.md ガイド](01_claude_md_guide.md) | CLAUDE.md の構造・書き方・配置場所・活用法 |
| 02 | [組み込みSkill ガイド](02_builtin_skills.md) | Claude Code 組み込みSkillの一覧・呼び出し方・カスタムSlashコマンドの作成 |

## クイックリファレンス

| やりたいこと | 方法 |
| --- | --- |
| Claude にプロジェクトのルールを覚えさせたい | `CLAUDE.md` に記述する |
| コード品質を自動チェックしたい | `/simplify` |
| Claude Code の設定・権限・フックを変更したい | `/update-config` |
| 繰り返しタスクを自動実行したい | `/loop` |
| キーバインドをカスタマイズしたい | `/keybindings-help` |
| Claude API を使ったアプリを作りたい | `/claude-api` |
| 仕様書・テスト・ドキュメントを生成したい | [AI Skills ガイド](../01_skills_guide.md) |
