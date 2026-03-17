# API仕様: <!-- [API名 / リソース名] -->

## 1. 基本情報

| 項目 | 内容 |
|---|---|
| API仕様ID | API-XXX |
| リソース名 | <!-- [リソース名] --> |
| ベースURL | <!-- [https://api.example.com/v1] --> |
| 認証方式 | Bearer Token (OAuth 2.0) |
| コンテンツタイプ | application/json |
| 対応要件 | FR-XXX |
| ステータス | Draft |

---

## 2. 共通仕様

### 2.1 リクエストヘッダー

| ヘッダー | 必須 | 値 | 備考 |
|---|---|---|---|
| Authorization | Yes（認証必要エンドポイント） | `Bearer {access_token}` | |
| Content-Type | Yes（POST/PUT/PATCH） | `application/json` | |
| Accept | Yes | `application/json` | |
| Accept-Language | No | `ja` / `en` | レスポンスの言語指定 |
| X-Request-ID | No | UUID v4 | リクエスト追跡用 |
| X-App-Version | No | `1.0.0` | アプリバージョン |
| X-Platform | No | `ios` / `android` / `web` | プラットフォーム識別 |

### 2.2 共通レスポンス構造

**成功時:**

```json
{
  "data": { ... },
  "meta": {
    "timestamp": "2025-01-01T00:00:00Z",
    "requestId": "uuid-v4"
  }
}
```

**一覧取得時（ページネーション）:**

```json
{
  "data": [ ... ],
  "pagination": {
    "page": 1,
    "perPage": 20,
    "totalPages": 5,
    "totalCount": 100
  },
  "meta": {
    "timestamp": "2025-01-01T00:00:00Z"
  }
}
```

**エラー時:**

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "入力内容に誤りがあります",
    "details": [
      {
        "field": "email",
        "message": "有効なメールアドレスを入力してください"
      }
    ]
  },
  "meta": {
    "timestamp": "2025-01-01T00:00:00Z",
    "requestId": "uuid-v4"
  }
}
```

### 2.3 共通エラーコード

| HTTPステータス | エラーコード | 説明 | アプリ側対応 |
|---|---|---|---|
| 400 | VALIDATION_ERROR | バリデーションエラー | フィールドエラー表示 |
| 401 | UNAUTHORIZED | 認証エラー | トークンリフレッシュ or ログイン画面 |
| 403 | FORBIDDEN | 権限不足 | 権限エラー表示 |
| 404 | NOT_FOUND | リソースが存在しない | 「見つかりません」表示 |
| 409 | CONFLICT | 競合 | 競合解決の案内 |
| 422 | UNPROCESSABLE | 処理不可 | エラーメッセージ表示 |
| 429 | RATE_LIMITED | レート制限超過 | Retry-After に従いリトライ |
| 500 | INTERNAL_ERROR | サーバー内部エラー | 汎用エラー表示 + リトライ |

---

## 3. エンドポイント一覧

| メソッド | パス | 説明 | 認証 |
|---|---|---|---|
| GET | `/<!-- [resource] -->` | 一覧取得 | 要 |
| GET | `/<!-- [resource] -->/:id` | 詳細取得 | 要 |
| POST | `/<!-- [resource] -->` | 新規作成 | 要 |
| PUT | `/<!-- [resource] -->/:id` | 全体更新 | 要 |
| PATCH | `/<!-- [resource] -->/:id` | 部分更新 | 要 |
| DELETE | `/<!-- [resource] -->/:id` | 削除 | 要 |

---

## 4. エンドポイント詳細

### 4.1 一覧取得

**リクエスト:**

```
GET /<!-- [resource] -->?page=1&perPage=20&sort=createdAt&order=desc
```

| パラメータ | 位置 | 型 | 必須 | デフォルト | 説明 |
|---|---|---|---|---|---|
| page | query | integer | No | 1 | ページ番号 |
| perPage | query | integer | No | 20 | 1ページあたりの件数（max: 100） |
| sort | query | string | No | createdAt | ソートフィールド |
| order | query | string | No | desc | ソート順（asc / desc） |
| search | query | string | No | - | キーワード検索 |

**レスポンス (200 OK):**

```json
{
  "data": [
    {
      "id": "uuid",
      "name": "string",
      "createdAt": "2025-01-01T00:00:00Z",
      "updatedAt": "2025-01-01T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "perPage": 20,
    "totalPages": 5,
    "totalCount": 100
  }
}
```

### 4.2 詳細取得

**リクエスト:**

```
GET /<!-- [resource] -->/:id
```

| パラメータ | 位置 | 型 | 必須 | 説明 |
|---|---|---|---|---|
| id | path | string (UUID) | Yes | リソースID |

**レスポンス (200 OK):**

```json
{
  "data": {
    "id": "uuid",
    "name": "string",
    "description": "string",
    "createdAt": "2025-01-01T00:00:00Z",
    "updatedAt": "2025-01-01T00:00:00Z"
  }
}
```

**エラーレスポンス (404 Not Found):**

```json
{
  "error": {
    "code": "NOT_FOUND",
    "message": "指定されたリソースが見つかりません"
  }
}
```

### 4.3 新規作成

**リクエスト:**

```
POST /<!-- [resource] -->
```

**リクエストボディ:**

| フィールド | 型 | 必須 | バリデーション | 説明 |
|---|---|---|---|---|
| name | string | Yes | 1〜100文字 | <!-- [説明] --> |
| description | string | No | 最大1000文字 | <!-- [説明] --> |

```json
{
  "name": "string",
  "description": "string"
}
```

**レスポンス (201 Created):**

```json
{
  "data": {
    "id": "uuid",
    "name": "string",
    "description": "string",
    "createdAt": "2025-01-01T00:00:00Z",
    "updatedAt": "2025-01-01T00:00:00Z"
  }
}
```

### 4.4 更新

**リクエスト:**

```
PATCH /<!-- [resource] -->/:id
```

**リクエストボディ（変更フィールドのみ送信）:**

```json
{
  "name": "updated string"
}
```

**レスポンス (200 OK):** 詳細取得と同じ構造

### 4.5 削除

**リクエスト:**

```
DELETE /<!-- [resource] -->/:id
```

**レスポンス (204 No Content):** ボディなし

---

## 5. レート制限

| エンドポイント | 制限 | ウィンドウ | 超過時 |
|---|---|---|---|
| 認証系 | 10回 | 1分 | 429 + Retry-After |
| 一覧取得 | 60回 | 1分 | 429 + Retry-After |
| 作成・更新 | 30回 | 1分 | 429 + Retry-After |

---

## 6. アプリ側実装ガイドライン

### 6.1 Dartモデルとの対応

```dart
// lib/models/[resource].dart
class Resource {
  final String id;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Resource({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Resource.fromJson(Map<String, dynamic> json) {
    return Resource(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
```

### 6.2 タイムアウト設定

| 操作 | タイムアウト |
|---|---|
| 一覧取得 | 30秒 |
| 詳細取得 | 15秒 |
| 作成・更新 | 30秒 |
| ファイルアップロード | 120秒 |

---

## 変更履歴

| 日付 | バージョン | 変更内容 | 変更者 |
|---|---|---|---|
| <!-- [YYYY-MM-DD] --> | 1.0 | 初版作成 | <!-- [名前] --> |
