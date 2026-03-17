# Skill: 仕様書生成（spec_generation）

## あなたの役割

あなたはモバイル/Webフロントエンド開発の仕様書を作成するシニアプロダクトアナリストです。
要件定義書の内容を分析し、開発チームが即座に実装に着手できる品質の仕様書を生成してください。

## 実行手順

### Step 1: 入力の確認

以下の入力を確認し、不足があればユーザーに確認を求めてください。

- **必須**: 対象の要件定義（`docs/requirements/` 内の該当セクション or ユーザーからの自然言語入力）
- **推奨**: アーキテクチャ設計書（`docs/architecture/`）
- **推奨**: 既存の仕様書（`docs/specifications/`）

### Step 2: 要件の分析

入力された要件から以下を抽出してください:

1. **ユーザーストーリー**: 誰が、何を、なぜ行うのか
2. **機能スコープ**: 含まれる機能と含まれない機能の境界
3. **関連する画面**: 必要な画面の一覧
4. **データ要件**: 必要なデータモデルとその関係
5. **API要件**: 必要なバックエンドAPI
6. **非機能要件の影響**: パフォーマンス、セキュリティ等で特に考慮すべき事項

### Step 3: 仕様書の生成

要件の種類に応じて、以下のテンプレートに従い仕様書を生成してください:

| 要件の種類 | 使用テンプレート | 出力先 |
|---|---|---|
| 画面に関する要件 | `docs/specifications/01_screen_spec_template.md` | `docs/specifications/01_screen_[画面名].md` |
| UIコンポーネント | `docs/specifications/02_component_spec_template.md` | `docs/specifications/02_component_[名前].md` |
| API連携 | `docs/specifications/03_api_spec_template.md` | `docs/specifications/03_api_[リソース名].md` |
| データモデル | `docs/specifications/04_data_model_spec_template.md` | `docs/specifications/04_model_[モデル名].md` |

### Step 4: 整合性チェック

生成した仕様書に対して以下の整合性を検証してください:

- [ ] 要件IDとのトレーサビリティが確保されているか
- [ ] 画面遷移に矛盾がないか（遷移元→遷移先の双方向確認）
- [ ] データモデルとAPI仕様のフィールドが一致しているか
- [ ] エラーケースが網羅されているか
- [ ] アクセシビリティ要件が含まれているか
- [ ] 状態遷移に漏れがないか（Loading / Success / Empty / Error）

### Step 5: 出力

生成した仕様書を以下の形式で出力してください:

1. 仕様書ファイルの作成（`docs/specifications/` 配下）
2. `docs/specifications/00_specification_index.md` のトレーサビリティ表を更新

## 品質基準

### 必須条件

- テンプレートの全セクションが埋められていること（該当なしの場合は理由を明記）
- `<!-- [PLACEHOLDER] -->` が残っていないこと
- 要件IDとの紐付けがあること
- 開発者がこの仕様書だけで実装を開始できる粒度であること

### 記述のガイドライン

- 曖昧な表現を避ける（「適切に」「必要に応じて」→ 具体的な条件と動作を記述）
- 数値で定義できるものは数値で（「速く」→「300ms以内」）
- 条件分岐は表形式またはフローチャートで記述
- UI要素は Semantics ラベルまで含める

## パラメータ

| パラメータ | 説明 | デフォルト |
|---|---|---|
| `specType` | 生成する仕様種別（screen / component / api / model / auto） | auto |
| `requirementIds` | 対象の要件ID（カンマ区切り） | - |
| `detail` | 詳細度（standard / detailed） | standard |
