# レイヤー設計

## 1. 概要

本プロジェクトはクリーンアーキテクチャの思想をベースに、Flutter開発に適した4層構造を採用する。

---

## 2. レイヤー定義

### 2.1 Presentation Layer（プレゼンテーション層）

**責務:** ユーザーへの情報表示とユーザー操作の受付

| 要素 | ディレクトリ | 責務 |
|---|---|---|
| Screen | `lib/screens/` | 画面単位のWidget。1画面 = 1ファイルを基本とする |
| Widget | `lib/widgets/` | 再利用可能なUIコンポーネント |
| Provider | `lib/providers/` | UIの状態管理。Domain層との橋渡し |

**ルール:**

- Widget 内にビジネスロジックを書かない
- Provider/State を経由して Domain 層を呼び出す
- Widget のネストは最大5階層を目安とし、超える場合は分割する
- 画面固有のWidgetは `screens/[screen_name]/` 配下に格納してもよい

**典型的なファイル構成:**

```
lib/screens/
├── home/
│   ├── home_screen.dart         # 画面のルートWidget
│   └── widgets/                 # 画面固有のWidget（任意）
│       ├── home_header.dart
│       └── home_content.dart
├── login/
│   └── login_screen.dart
└── settings/
    └── settings_screen.dart
```

### 2.2 Domain Layer（ドメイン層）

**責務:** ビジネスルールとデータ構造の定義

| 要素 | ディレクトリ | 責務 |
|---|---|---|
| Model | `lib/models/` | エンティティ、値オブジェクト、DTO |
| Service | `lib/services/` | ビジネスロジック、ユースケース |

**ルール:**

- Flutter / プラットフォームに依存しない純粋なDartコード
- 外部通信やデータ永続化は抽象（インターフェース）として定義し、Data層で実装する
- Model は Immutable とし、`copyWith` パターンを使用する
- サービスクラスはインターフェースを定義し、テスト時にモック可能にする

**Model の設計パターン:**

```dart
// lib/models/user.dart
class User {
  final String id;
  final String name;
  final String email;

  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  User copyWith({String? id, String? name, String? email}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }
}
```

**Service の設計パターン:**

```dart
// lib/services/auth_service.dart
abstract class AuthService {
  Future<User> login(String email, String password);
  Future<void> logout();
  Stream<User?> get authStateChanges;
}
```

### 2.3 Data Layer（データ層）

**責務:** 外部データソースとのやり取り、Domain層インターフェースの実装

| 要素 | 配置 | 責務 |
|---|---|---|
| Repository | `lib/services/` 内の実装クラス | Domain層インターフェースの具象実装 |
| DataSource | `lib/services/` 内 | API通信、ローカルDB操作 |

**ルール:**

- Domain 層で定義したインターフェースを実装する
- API レスポンスの JSON パース、DTO ↔ Model 変換はこの層で行う
- キャッシュ戦略はこの層で制御する
- エラーをDomain層が理解できる型に変換して返す

**実装パターン:**

```dart
// lib/services/auth_service_impl.dart
class AuthServiceImpl implements AuthService {
  final HttpClient _client;
  final SecureStorage _storage;

  AuthServiceImpl(this._client, this._storage);

  @override
  Future<User> login(String email, String password) async {
    final response = await _client.post('/auth/login', body: {
      'email': email,
      'password': password,
    });
    return User.fromJson(response.data);
  }
}
```

### 2.4 Infrastructure Layer（インフラ層）

**責務:** フレームワーク・ライブラリ・プラットフォームAPIとの接点

| 要素 | 配置 | 責務 |
|---|---|---|
| HTTP Client | `lib/utils/` or 別パッケージ | HTTP通信の共通設定（ヘッダ、インターセプター） |
| Local Storage | `lib/utils/` | ローカルストレージのラッパー |
| Platform | `lib/utils/` | プラットフォーム固有処理のラッパー |

**ルール:**

- ライブラリ固有の型は、このレイヤーの外に漏らさない
- ライブラリの差し替えが可能なようにラッパーを設ける

---

## 3. レイヤー間の依存関係

### 3.1 依存ルール

```
  許可される依存方向:
  Presentation → Domain    ✅
  Data         → Domain    ✅
  Presentation → Data      ❌（Providerを経由する）
  Domain       → Data      ❌（インターフェースで逆転）
  Domain       → Presentation ❌
```

### 3.2 依存性注入（DI）

エントリーポイント（`main.dart`）で全ての依存関係を解決し、各レイヤーに注入する。

```dart
void main() {
  // Infrastructure
  final httpClient = HttpClient(baseUrl: 'https://api.example.com');
  final secureStorage = SecureStorage();

  // Data → Domain（インターフェースの実装を注入）
  final authService = AuthServiceImpl(httpClient, secureStorage);

  // Presentation（Providerで提供）
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## 4. パッケージ構成の拡張指針

プロジェクト規模が大きくなった場合、以下の構成への拡張を検討する。

```
lib/
├── features/              # 機能単位のモジュール分割
│   ├── auth/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── providers/
│   │   ├── models/
│   │   └── services/
│   ├── home/
│   └── settings/
├── core/                  # 機能横断の共通コード
│   ├── models/
│   ├── services/
│   ├── widgets/
│   └── utils/
└── main.dart
```

**拡張の判断基準:**

- 画面数が10を超えた場合
- 開発者が3人以上で並行開発する場合
- 機能間の依存が複雑になり、影響範囲の把握が困難になった場合

---

## 変更履歴

| 日付 | バージョン | 変更内容 | 変更者 |
|---|---|---|---|
| <!-- [YYYY-MM-DD] --> | 1.0 | 初版作成 | <!-- [名前] --> |
