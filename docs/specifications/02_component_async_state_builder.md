# コンポーネント仕様: AsyncStateBuilder

## 1. 基本情報

| 項目 | 内容 |
| --- | --- |
| コンポーネントID | CMP-001 |
| コンポーネント名 | AsyncStateBuilder |
| ファイルパス | `lib/widgets/async_state_builder.dart` |
| 使用画面 | 全画面（非同期データ表示の共通コンポーネント） |
| ステータス | Approved |

## 2. 概要

`AsyncState<T>` の4状態（initial / loading / success / failure）に応じたWidgetの出し分けを標準化する共通コンポーネント。
各画面で状態分岐のコードを繰り返し書くことを防ぎ、UI表示パターンを統一する。

## 3. プロパティ

| プロパティ名 | 型 | 必須 | デフォルト値 | 説明 |
| --- | --- | --- | --- | --- |
| state | `AsyncState<T>` | Yes | - | 表示する非同期状態 |
| onSuccess | `Widget Function(T data)` | Yes | - | 成功時のWidget構築関数 |
| onLoading | `Widget Function()?` | No | CircularProgressIndicator | ローディング時のWidget |
| onFailure | `Widget Function(String error, VoidCallback retry)?` | No | デフォルトエラー表示 | エラー時のWidget |
| onInitial | `Widget Function()?` | No | SizedBox.shrink() | 初期状態のWidget |
| onRetry | `VoidCallback?` | No | null | リトライコールバック |

## 4. デフォルト表示

| 状態 | デフォルトWidget |
| --- | --- |
| initial | 空（`SizedBox.shrink()`） |
| loading | 中央配置の `CircularProgressIndicator` |
| success | `onSuccess(data)` の戻り値 |
| failure | エラーメッセージ + リトライボタン（`onRetry` が指定されている場合） |
