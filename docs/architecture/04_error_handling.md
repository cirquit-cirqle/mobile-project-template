# エラーハンドリング方針

## 1. 概要

アプリケーション全体で一貫したエラーハンドリングを実現するための分類、処理戦略、ユーザーへの通知方針を定義する。

---

## 2. エラー分類

### 2.1 エラーカテゴリ

| カテゴリ | 説明 | 例 | リカバリ可能性 |
|---|---|---|---|
| **ネットワークエラー** | 通信に起因するエラー | タイムアウト、接続不可、DNS解決失敗 | リトライ可能 |
| **APIエラー** | サーバーからの明示的なエラー応答 | 400/401/403/404/500系 | ケースによる |
| **バリデーションエラー** | ユーザー入力の検証失敗 | 必須未入力、フォーマット不正 | ユーザーが修正可能 |
| **認証エラー** | 認証・認可の失敗 | トークン期限切れ、権限不足 | 再認証で回復 |
| **クライアントエラー** | アプリ内部の予期しないエラー | Null参照、型不一致、状態不整合 | 回復困難 |
| **プラットフォームエラー** | OS/デバイス固有のエラー | パーミッション拒否、ストレージ不足 | ユーザー操作で回復 |

### 2.2 HTTPステータスコード別対応

| ステータスコード | 分類 | アプリ側対応 |
|---|---|---|
| 400 Bad Request | バリデーション | エラーメッセージ表示、入力修正を促す |
| 401 Unauthorized | 認証 | トークンリフレッシュ試行 → 失敗時ログイン画面へ |
| 403 Forbidden | 認可 | 権限不足のメッセージ表示 |
| 404 Not Found | API | 「データが見つかりません」表示 |
| 409 Conflict | API | 競合解決の案内表示 |
| 422 Unprocessable | バリデーション | サーバーバリデーションエラー表示 |
| 429 Too Many Requests | API | リトライ（Retry-After ヘッダに従う） |
| 500 Internal Server Error | API | 汎用エラー表示 + リトライ提示 |
| 502/503/504 | API | メンテナンス画面 or リトライ |

---

## 3. エラー処理戦略

### 3.1 レイヤー別の責務

| レイヤー | 責務 | やること | やらないこと |
|---|---|---|---|
| **Infrastructure** | HTTPエラーをアプリ固有のエラー型に変換 | 例外のラップ、ログ出力 | UI表示、リトライ判断 |
| **Service (Domain)** | ビジネスルール上のエラー判定 | エラー型の返却 | UI表示、ダイアログ表示 |
| **Provider** | エラー状態の保持、リトライ制御 | 状態更新、リトライ呼び出し | 直接的なUI操作 |
| **Screen/Widget** | ユーザーへのエラー表示 | エラーUI描画、操作導線提示 | エラーの握りつぶし |

### 3.2 エラー型定義

```dart
// lib/models/app_error.dart
sealed class AppError {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });
}

class NetworkError extends AppError {
  const NetworkError({required super.message, super.code, super.originalError});
}

class ApiError extends AppError {
  final int statusCode;
  const ApiError({
    required super.message,
    required this.statusCode,
    super.code,
    super.originalError,
  });
}

class ValidationError extends AppError {
  final Map<String, List<String>> fieldErrors;
  const ValidationError({
    required super.message,
    this.fieldErrors = const {},
    super.code,
  });
}

class AuthError extends AppError {
  const AuthError({required super.message, super.code, super.originalError});
}
```

### 3.3 Result パターン

例外ではなく戻り値でエラーを表現し、エラーハンドリング漏れを防ぐ。

```dart
// lib/models/result.dart
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}
```

---

## 4. リトライ戦略

### 4.1 自動リトライ

| 条件 | リトライ回数 | 間隔 | 備考 |
|---|---|---|---|
| ネットワークタイムアウト | 最大3回 | Exponential Backoff (1s, 2s, 4s) | バックグラウンドで自動 |
| 5xx サーバーエラー | 最大2回 | Exponential Backoff | バックグラウンドで自動 |
| 429 Rate Limit | 1回 | Retry-After ヘッダの値 | ヘッダなしの場合は60秒 |
| 401 Unauthorized | 1回 | 即時 | トークンリフレッシュ後にリトライ |

### 4.2 手動リトライ

自動リトライが全て失敗した場合、ユーザーにリトライボタンを表示する。

```dart
// エラー画面の共通Widget
class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('再試行'),
        ),
      ],
    );
  }
}
```

---

## 5. ユーザーへのエラー通知方針

### 5.1 通知パターンの使い分け

| パターン | 使用場面 | 表示位置 | 自動消去 |
|---|---|---|---|
| **インラインエラー** | フォームバリデーション | 入力フィールド直下 | No（修正まで） |
| **SnackBar** | 一時的な操作エラー | 画面下部 | Yes（4秒） |
| **エラー画面（全面）** | データ取得失敗（画面表示不可） | 画面全体 | No（リトライ/戻る） |
| **ダイアログ** | 重要な確認が必要なエラー | 画面中央 | No（ユーザー操作で閉じる） |
| **バナー** | 持続的な状態異常 | 画面上部 | No（状態回復まで） |

### 5.2 エラーメッセージのガイドライン

| 原則 | 良い例 | 悪い例 |
|---|---|---|
| 原因を伝える | 「インターネットに接続されていません」 | 「エラーが発生しました」 |
| 対処法を示す | 「通信環境を確認して再度お試しください」 | 「Error: NETWORK_TIMEOUT」 |
| 技術用語を避ける | 「データの読み込みに失敗しました」 | 「HTTP 500 Internal Server Error」 |
| 責任転嫁しない | 「現在サービスに接続できません」 | 「あなたの操作に問題があります」 |

---

## 6. グローバルエラーハンドリング

### 6.1 未捕捉エラーのキャッチ

```dart
void main() {
  // Flutter フレームワーク内のエラー
  FlutterError.onError = (details) {
    // Crashlytics等に送信
    CrashReporting.recordFlutterError(details);
  };

  // Dart の非同期エラー等
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashReporting.recordError(error, stack);
    return true;
  };

  runApp(const MyApp());
}
```

### 6.2 エラーバウンダリ

致命的エラー発生時のフォールバックUI。

```dart
class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({required this.child});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (details) {
      return const Center(
        child: Text('予期しないエラーが発生しました'),
      );
    };
    return child;
  }
}
```

---

## 7. ログ・モニタリング

### 7.1 エラーログの出力基準

| レベル | 基準 | 例 |
|---|---|---|
| **Error** | ユーザー影響あり、即時対応が必要 | API 500エラー、クラッシュ |
| **Warning** | 潜在的な問題、監視が必要 | リトライ発生、非推奨API使用 |
| **Info** | 正常系の重要イベント | ログイン成功、画面遷移 |
| **Debug** | 開発時のみ必要な詳細情報 | APIリクエスト/レスポンス内容 |

### 7.2 エラーログに含める情報

| 項目 | 必須 | 備考 |
|---|---|---|
| タイムスタンプ | Yes | UTC |
| エラー種別 | Yes | AppError のサブクラス名 |
| エラーメッセージ | Yes | |
| スタックトレース | Yes（Error/Warningのみ） | |
| APIエンドポイント | Yes（API関連の場合） | |
| HTTPステータスコード | Yes（API関連の場合） | |
| ユーザーID | 状況による | 個人を特定しないハッシュ値推奨 |
| デバイス情報 | Yes（クラッシュ時） | OS, バージョン, 機種名 |

---

## 変更履歴

| 日付 | バージョン | 変更内容 | 変更者 |
|---|---|---|---|
| <!-- [YYYY-MM-DD] --> | 1.0 | 初版作成 | <!-- [名前] --> |
