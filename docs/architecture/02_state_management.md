# 状態管理方針

## 1. 概要

アプリケーション内の「状態」を分類し、それぞれに適した管理方針を定義する。

---

## 2. 状態の分類

### 2.1 分類マトリクス

| 分類 | スコープ | ライフサイクル | 例 | 管理方法 |
|---|---|---|---|---|
| **UIローカル状態** | 単一Widget | Widget の生存期間 | フォーム入力値、タブ選択、アニメーション | `StatefulWidget` / `ValueNotifier` |
| **画面状態** | 単一画面 | 画面の生存期間 | リスト表示データ、ローディング状態、エラー | Provider / StateNotifier |
| **アプリグローバル状態** | アプリ全体 | アプリの生存期間 | 認証状態、テーマ、ロケール | Provider（ルートで提供） |
| **サーバー状態** | API由来 | キャッシュ有効期間 | ユーザーデータ、コンテンツ一覧 | Provider + キャッシュ戦略 |
| **永続化状態** | デバイスローカル | 永続 | ユーザー設定、オンボーディング完了フラグ | SharedPreferences / Hive |

### 2.2 判断フローチャート

```
状態が必要になった
  │
  ├─ この Widget 内だけで使う？
  │   └─ Yes → UIローカル状態（StatefulWidget）
  │
  ├─ この画面内だけで使う？
  │   └─ Yes → 画面状態（画面スコープのProvider）
  │
  ├─ 複数画面で共有する？
  │   └─ Yes → アプリグローバル状態（ルートProvider）
  │
  ├─ サーバーから取得したデータ？
  │   └─ Yes → サーバー状態（キャッシュ付きProvider）
  │
  └─ アプリ再起動後も必要？
      └─ Yes → 永続化状態（ローカルストレージ）
```

---

## 3. 状態管理パターン

### 3.1 Provider パターン（推奨デフォルト）

```dart
// 画面状態の例: リスト取得
class ItemListProvider extends ChangeNotifier {
  final ItemService _service;

  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ItemListProvider(this._service);

  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _service.getItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 3.2 状態オブジェクトのパターン

全ての非同期データは以下の状態を持つ。統一的に扱うことでUI側の分岐を標準化する。

```dart
// 非同期状態の共通パターン
enum AsyncStatus { initial, loading, success, failure }

class AsyncState<T> {
  final AsyncStatus status;
  final T? data;
  final String? error;

  const AsyncState._({
    required this.status,
    this.data,
    this.error,
  });

  factory AsyncState.initial() => const AsyncState._(status: AsyncStatus.initial);
  factory AsyncState.loading() => const AsyncState._(status: AsyncStatus.loading);
  factory AsyncState.success(T data) => AsyncState._(status: AsyncStatus.success, data: data);
  factory AsyncState.failure(String error) => AsyncState._(status: AsyncStatus.failure, error: error);

  bool get isInitial => status == AsyncStatus.initial;
  bool get isLoading => status == AsyncStatus.loading;
  bool get isSuccess => status == AsyncStatus.success;
  bool get isFailure => status == AsyncStatus.failure;
}
```

---

## 4. データフロー

### 4.1 単方向データフロー

```
User Action → Provider → Service → API/DB
                ↓
             State Update
                ↓
           Widget Rebuild (自動)
```

**原則:**
- 状態の変更は必ず Provider（状態管理クラス）を経由する
- Widget から直接 Service を呼ばない
- 状態の更新は `notifyListeners()` により Widget に自動反映される

### 4.2 イベント駆動パターン

リアルタイム更新が必要な場合は Stream を使用する。

```dart
// Stream による状態監視
class AuthProvider extends ChangeNotifier {
  User? _user;
  late final StreamSubscription _subscription;

  AuthProvider(AuthService authService) {
    _subscription = authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

---

## 5. キャッシュ戦略

### 5.1 キャッシュポリシー

| データ種別 | キャッシュ場所 | 有効期間 | 更新トリガー |
|---|---|---|---|
| ユーザープロフィール | メモリ | アプリ生存期間 | ログイン時・明示的更新 |
| 一覧データ | メモリ | 5分 | Pull-to-refresh・画面遷移 |
| マスターデータ | ローカルDB | 24時間 | アプリ起動時 |
| 画像 | ディスクキャッシュ | 7日間 | LRU（容量上限100MB） |

### 5.2 オフラインファースト対応（必要な場合）

```
データ取得リクエスト
  │
  ├─ キャッシュあり？
  │   ├─ Yes & 有効期限内 → キャッシュ返却
  │   ├─ Yes & 期限切れ → キャッシュ返却 + バックグラウンドで更新
  │   └─ No → ローディング表示 + API取得
  │
  └─ API取得結果 → キャッシュ更新 → UI更新
```

---

## 6. 状態管理のアンチパターン

| アンチパターン | 問題点 | 正しいアプローチ |
|---|---|---|
| Widget内で直接API呼び出し | テスト不可、責務混在 | Provider経由でServiceを呼ぶ |
| グローバル変数での状態管理 | ライフサイクル管理不可 | Providerのスコープ管理 |
| 状態の二重管理 | 不整合の原因 | Single Source of Truth を徹底 |
| 過剰なグローバル状態 | 不要なリビルド、複雑化 | 必要最小限のスコープで管理 |
| `setState` の深いネスト | 可読性低下、バグの温床 | ChangeNotifier に切り出し |

---

## 変更履歴

| 日付 | バージョン | 変更内容 | 変更者 |
|---|---|---|---|
| <!-- [YYYY-MM-DD] --> | 1.0 | 初版作成 | <!-- [名前] --> |
