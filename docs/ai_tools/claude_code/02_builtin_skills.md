# Claude Code 組み込みSkill ガイド

Claude Code には、よく使う開発タスクに特化した組み込みSkillが用意されている。
`/skill-name` のスラッシュコマンドで呼び出す。

> プロジェクト固有のSkill（`skills/` ディレクトリ）については
> [docs/ai_tools/01_skills_guide.md](../01_skills_guide.md) を参照すること。

---

## 1. 呼び出し方

チャット入力欄に `/` + スキル名を入力する。

```
/simplify
/update-config
```

引数が必要なSkillには続けてオプションを渡せる。

```
/loop 5m /foo
```

---

## 2. 利用可能なSkill一覧

### simplify

変更したコードを対象に、再利用性・品質・効率の観点でレビューを行い、問題があれば修正する。

使いどころ:

- 実装完了後にコードの過剰な複雑さを取り除きたいとき
- リファクタリングの最終チェックとして使いたいとき

```
/simplify
```

---

### update-config

`settings.json` / `settings.local.json` の設定変更を行う。
自動化された振る舞い（「〇〇のとき毎回△△する」など）はClaude Codeのフック機能が必要なため、このSkillで設定する。

使いどころ:

- ツールの実行権限を追加・変更したいとき
- 「コミット前に必ずフォーマッタを実行する」などの自動フックを設定したいとき
- 環境変数を設定したいとき

```
/update-config  npmコマンドを許可したい
/update-config  コミット時にflutter formatを自動実行したい
```

---

### keybindings-help

`~/.claude/keybindings.json` のキーバインドをカスタマイズする。

使いどころ:

- よく使う操作にショートカットキーを割り当てたいとき
- デフォルトキーバインドを変更したいとき

```
/keybindings-help  ctrl+s でコミットしたい
```

---

### loop

指定した間隔でプロンプトまたはSlashコマンドを繰り返し実行する。

使いどころ:

- デプロイ状況を定期的に確認したいとき
- 継続的なタスク監視を行いたいとき

```
/loop 5m /check-deploy    # 5分ごとにデプロイ確認
/loop 10m /foo            # 10分ごとに /foo を実行
```

---

### claude-api

Anthropic SDK（`@anthropic-ai/sdk` / `anthropic`）を使ったアプリ構築をサポートする。

使いどころ:

- Claude APIを呼び出すコードを書きたいとき
- Claude Agent SDKを使ったAIエージェントを実装したいとき

```
/claude-api  チャットボットのバックエンドを実装したい
```

---

## 3. Skillとメモリの使い分け

| 用途 | 手段 |
| --- | --- |
| 一度きりの指示（「このファイルを修正して」） | 通常のチャット |
| 繰り返し適用するルール（コーディング規約など） | `CLAUDE.md` |
| 自動化・フック・権限設定 | `/update-config` Skill |
| 特定タスクの専門的な実行 | 各 Skill |

「毎回〇〇して」という自動化はメモリや通常の指示では機能しない。
Claude Code のフックとして設定する必要があるため `/update-config` を使用すること。

---

## 4. プロジェクト固有のカスタムSlashコマンド

Claude Code 専用のスラッシュコマンドを追加したい場合、`.claude/commands/` に
Markdownファイルを置くと `/ファイル名` で呼び出せるようになる。

```
.claude/
└── commands/
    └── review-flutter.md    # /review-flutter で呼び出せる
```

ファイルの中身がそのままプロンプトとして展開される。

```markdown
以下の観点でコードをレビューしてください：

1. Widget の build が50行以内か
2. ビジネスロジックが Widget に含まれていないか
3. const Widget が適切に使われているか
4. Riverpod の Provider 設計が適切か
```

> `skills/` ディレクトリとの違い: `.claude/commands/` は Claude Code 専用のスラッシュコマンドで、
> `/コマンド名` で即座に呼び出せる。`skills/` はツール横断のプロンプトライブラリで、
> 各AIツールのコンテキスト読み込み機能を通じて利用する。
