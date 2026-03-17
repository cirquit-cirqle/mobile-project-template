# コーディング規約

Google の [Effective Dart](https://dart.dev/effective-dart) および Meta のモバイル開発原則を参考に定義した規約。
AIがコードを生成する際、およびレビュー時のチェック基準として使用する。

---

## 目次

1. [命名規則](#1-命名規則)
2. [ファイル・ディレクトリ構成](#2-ファイルディレクトリ構成)
3. [インポート](#3-インポート)
4. [型・変数](#4-型変数)
5. [関数・メソッド設計](#5-関数メソッド設計)
6. [Widget設計](#6-widget設計)
7. [コメントルール](#7-コメントルール)
8. [エラーハンドリング](#8-エラーハンドリング)
9. [テスタビリティ](#9-テスタビリティ)
10. [パフォーマンス](#10-パフォーマンス)
11. [AIコード生成チェックリスト](#11-aiコード生成チェックリスト)

---

## 1. 命名規則

> **原則（Google Effective Dart）:** 読んだ瞬間に意図が伝わる名前をつける。省略・汎用語（`data`, `info`, `manager`, `util`）は避ける。

### 1.1 ケース規則

| 対象 | ケース | 例 |
| --- | --- | --- |
| クラス・型・enum | `UpperCamelCase` | `UserRepository`, `AuthState` |
| 変数・関数・パラメータ | `lowerCamelCase` | `fetchUser`, `isLoading` |
| 定数（`const`） | `lowerCamelCase` | `maxRetryCount`, `defaultTimeout` |
| ファイル名・パッケージ名 | `snake_case` | `user_repository.dart`, `auth_state.dart` |
| プライベートメンバー | `_lowerCamelCase` | `_userId`, `_fetchToken` |

```dart
// 良い例
const int maxRetryCount = 3;
class UserProfileRepository { ... }
Future<User?> fetchUserById(String userId) { ... }

// 悪い例
const int MAX_RETRY = 3;      // Dart では SCREAMING_CAPS は使わない
class UserMgr { ... }          // 省略語
Future getData() { ... }       // 汎用すぎる名前
```

### 1.2 命名の意図明確化

**bool 型:** 状態・判定を表す接頭辞を使う

```dart
// 良い例
bool isLoading;
bool hasError;
bool canSubmit;
bool shouldRefetch;

// 悪い例
bool loading;
bool error;
bool submit;
```

**非同期関数:** 動詞 + 名詞で副作用が伝わるようにする

```dart
// 良い例: 何を取得・変更するか明確
Future<List<Post>> fetchPosts();
Future<void> deleteUser(String userId);
Future<AuthToken> refreshToken();

// 悪い例: 動詞が曖昧
Future<List<Post>> getPosts();   // fetch/load/get は混在させない（1つに統一）
Future<void> processUser();      // process は何をするか不明
```

> **プロジェクト統一:** `fetch`（リモートAPI取得）/ `load`（ローカル/キャッシュ取得）/ `save`（永続化）に動詞を統一する。

---

## 2. ファイル・ディレクトリ構成

### 2.1 1ファイル1責務

1つのファイルには原則として1つの公開クラスのみを定義する。

```text
// 良い例
user_repository.dart       → class UserRepository
user_repository_impl.dart  → class UserRepositoryImpl

// 悪い例
user.dart → class User, class UserRepository, class UserFactory
```

### 2.2 ファイル命名

- Widgetファイル: `<widget_name>_screen.dart` / `<widget_name>_widget.dart`
- Provider/Notifier: `<domain>_provider.dart` / `<domain>_notifier.dart`
- モデル: `<entity>.dart`（例: `user.dart`）
- リポジトリ: `<entity>_repository.dart`

---

## 3. インポート

> **原則（Google スタイル）:** インポートは `dart:` → `package:` → 相対パス の順に並べ、グループ間は空行で区切る。

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. 外部パッケージ（アルファベット順）
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 3. プロジェクト内（アルファベット順）
import 'package:my_app/domain/user.dart';
import 'package:my_app/infrastructure/user_repository_impl.dart';
```

- `show` / `hide` で必要なものだけをインポートする（名前衝突の予防）
- 未使用インポートは即座に削除する

---

## 4. 型・変数

### 4.1 型推論と明示的型宣言

```dart
// ローカル変数: 型推論を活用（var/final を使う）
final user = await fetchUser(id);         // 型が推論できる場合
final List<User> users = [];              // 空コレクションは明示する

// 公開API・フィールド: 明示的に型を書く
class UserRepository {
  final AuthDataSource _dataSource;       // フィールドは明示
  Future<User?> fetchUser(String id) {}  // 戻り値は明示
}
```

### 4.2 `final` / `const` の優先

```dart
// 変更しない変数には final を使う
final userId = 'abc123';

// コンパイル時定数には const を使う
const maxItems = 100;
const defaultTimeout = Duration(seconds: 30);

// Widget の引数は const コンストラクタで定義する（パフォーマンス最適化）
const Text('Hello');
const SizedBox(height: 8);
```

### 4.3 Null Safety

```dart
// null 許容型は本当に null になりうる場合のみ使う
String? maybeUserId;       // null になりうる
String definiteUserId;     // null にならないことが保証される

// late は初期化が保証されている場合にのみ使う（乱用禁止）
late final String _cachedToken;  // initState や build 前に必ず初期化される場合

// null チェックより安全な演算子を優先する
final name = user?.name ?? 'Guest';   // 良い
if (user != null) { user!.name; }    // 悪い（不要な ! アサーション）
```

### 4.4 マジックナンバー禁止

```dart
// 悪い例
if (retryCount > 3) { ... }
await Future.delayed(Duration(milliseconds: 500));

// 良い例: 意図を名前で伝える
const maxRetryCount = 3;
const splashMinDuration = Duration(milliseconds: 500);

if (retryCount > maxRetryCount) { ... }
await Future.delayed(splashMinDuration);
```

---

## 5. 関数・メソッド設計

> **原則（Google / Meta）:** 関数は1つのことだけをする（単一責任）。副作用は明示する。

### 5.1 関数の長さ

- 1関数は **原則30行以内**（ロジックの行数。空行・コメントは除く）
- 超える場合はプライベート関数に分割する

```dart
// 悪い例: 1関数に複数の責務
Future<void> signIn(String email, String password) async {
  // バリデーション（責務1）
  if (!email.contains('@')) throw ValidationException();
  if (password.length < 8) throw ValidationException();
  // API呼び出し（責務2）
  final token = await _authApi.signIn(email, password);
  // トークン保存（責務3）
  await _storage.save('token', token);
  // ユーザー情報取得（責務4）
  final user = await _userApi.fetchMe(token);
  // 状態更新（責務5）
  state = AuthState.authenticated(user);
}

// 良い例: 責務を分割
Future<void> signIn(String email, String password) async {
  _validateCredentials(email, password);
  final token = await _authApi.signIn(email, password);
  await _persistToken(token);
  final user = await _fetchAuthenticatedUser(token);
  state = AuthState.authenticated(user);
}
```

### 5.2 引数設計

```dart
// 引数が3個を超える場合は名前付き引数を使う
// 悪い例
Future<void> createPost(String title, String body, String authorId, bool isDraft);

// 良い例
Future<void> createPost({
  required String title,
  required String body,
  required String authorId,
  bool isDraft = false,
});
```

### 5.3 副作用の明示

```dart
// 戻り値がないメソッドでも、何を変更するかが名前でわかるようにする
Future<void> saveUserProfile(UserProfile profile) async { ... }  // 保存
void clearCache() { ... }                                         // 削除
void notifyListeners() { ... }                                    // 通知
```

---

## 6. Widget設計

> **原則（Meta Component Design）:** Widgetは小さく・単一責務で設計する。ロジックとUIを分離する。

### 6.1 Widget分割の基準

- 1つのWidgetの `build` メソッドが **50行を超えたら分割を検討**する
- 同じUIパターンが2箇所以上現れたら共通Widgetに切り出す
- ロジック（状態管理・副作用）はWidgetに書かず、Notifier/Provider に置く

```dart
// 悪い例: build メソッドが肥大化
class UserProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Column(children: [
      // ヘッダー（30行）
      // プロフィール情報（40行）
      // 投稿一覧（50行）
    ]);
  }
}

// 良い例: 責務ごとにWidgetを分割
class UserProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Column(children: [
      _ProfileHeader(user: user),
      _ProfileInfo(user: user),
      _UserPostList(userId: user.id),
    ]);
  }
}
```

### 6.2 const Widget の活用

```dart
// 静的なWidgetには const をつける（再ビルドの抑制）
class _EmptyState extends StatelessWidget {
  const _EmptyState();   // コンストラクタに const

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('データがありません'),
    );
  }
}
```

### 6.3 StatelessWidget / ConsumerWidget の優先

```dart
// 状態を持たない場合は StatelessWidget を使う
// Riverpod の状態を読む場合は ConsumerWidget を使う
// StatefulWidget は以下の場合のみ使う:
//   - AnimationController, TextEditingController など Widget のライフサイクルが必要な場合
//   - initState/dispose で副作用のセットアップが必要な場合
```

### 6.4 ロジックをWidgetから分離

```dart
// 悪い例: Widget内にビジネスロジック
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final email = _emailController.text;
        // バリデーションロジックをWidgetに書かない
        if (!email.contains('@')) { ... }
        await ref.read(authProvider.notifier).signIn(email, password);
      },
      child: const Text('ログイン'),
    );
  }
}

// 良い例: ロジックはNotifierに移譲
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => ref.read(loginNotifierProvider.notifier).submit(),
      child: const Text('ログイン'),
    );
  }
}
```

---

## 7. コメントルール

### 7.1 基本方針

コメントは「**なぜ**」を説明する。「何をしているか」はコメントしない。
コードを読めば明らかな内容はコメントしない。
コメントを書く前に、命名やリファクタリングで解決できないか検討する。

**悪い例（何をしているかの説明）:**

```dart
// ユーザーリストをフィルタリングする
final activeUsers = users.where((u) => u.isActive).toList();
```

**良い例（なぜそうしているかの説明）:**

```dart
// 無効化済みユーザーはダッシュボードに表示しない仕様のためフィルタリング
final activeUsers = users.where((u) => u.isActive).toList();
```

---

### 7.2 ドキュメントコメント（`///`）

公開API（`public`なクラス・メソッド・プロパティ）には `///` 形式のドキュメントコメントを記述する。このコメントは `dart doc` コマンドで HTML ドキュメントとして出力できる。

**対象:**

- `public` なクラス
- `public` なメソッド・関数
- `public` なプロパティ（自明でないもの）

#### 構造ルール

| 要素 | ルール |
| --- | --- |
| **1行目（サマリー）** | 1文で何をするものかを簡潔に記述（`dart doc` の索引・ホバー表示に使われる） |
| **空行** | サマリーと詳細の間には必ず空行（`///`）を入れる |
| **`[識別子]`** | クラス名・メソッド名・パラメータ名を `[識別子]` で囲むと、生成ドキュメント内でハイパーリンクになる |
| **戻り値** | 戻り値の説明は本文中に prose として記述する（`@returns` タグは Dart に存在しない） |
| **例外** | スローする例外は `[ExceptionClass]` でクラスを参照しながら本文に記述する |
| **Markdown** | 本文内で Markdown（箇条書き・コードブロック等）が使用できる |

#### クラスのドキュメントコメント

```dart
/// ユーザー認証を管理するリポジトリ。
///
/// [AuthDataSource] を通じて認証APIと通信し、
/// トークンの取得・更新・失効を担当する。
///
/// 使用例:
/// ```dart
/// final repo = AuthRepository(dataSource);
/// final token = await repo.signIn(email: 'user@example.com', password: '...');
/// ```
class AuthRepository { ... }
```

#### メソッドのドキュメントコメント

```dart
/// ユーザー情報を取得して返す。
///
/// [userId] に対応するユーザーが存在しない場合は `null` を返す。
/// ネットワークエラー時は [NetworkException] をスローする。
Future<User?> fetchUser(String userId) async { ... }
```

#### プロパティのドキュメントコメント

```dart
/// 現在認証中のユーザー。未認証の場合は `null`。
User? get currentUser => _currentUser;
```

**不要な場合（記述しない）:**

- `private` メンバー（`_` プレフィックス）
- 名前だけで意図が明確なもの（例: `dispose()`, `build()`）

**ドキュメント生成コマンド:**

```bash
dart doc .
# または
flutter pub global run dartdoc
```

#### 図の埋め込み

`dart doc` は **Mermaid / UML コードブロックをネイティブでレンダリングしない**。図を含めたい場合は以下のいずれかを使用する。

##### 方法1: 画像参照（推奨）

外部ツールで図を事前生成し、`![alt](path)` で参照する。画像参照は `dart doc` の Markdown として正式にサポートされている。

```dart
/// 認証フローを示すシーケンス図:
///
/// ![認証シーケンス図](../docs/diagrams/auth_sequence.png)
class AuthRepository { ... }
```

図の生成には以下のツールが使用できる:

| ツール | 用途 | 出力形式 |
| --- | --- | --- |
| [DCDG](https://github.com/glesica/dcdg.dart) | Dartコードからクラス図を自動生成 | Mermaid / PlantUML |
| [Mermaid CLI](https://github.com/mermaid-js/mermaid-cli) | `.mmd` ファイルから画像を生成 | PNG / SVG |
| PlantUML | UML図を記述・画像化 | PNG / SVG |

##### 方法2: `{@inject-html}` ディレクティブ（非推奨）

`--inject-html` フラグを有効にすると、ドキュメントコメント内に生の HTML を埋め込める。Mermaid.js を注入して図をレンダリングすることは技術的に可能だが、**公式にはサポートされていない非公式な手法**であるため、原則として使用しない。

```dart
/// {@inject-html}
/// <div class="mermaid">sequenceDiagram ...</div>
/// {@end-inject-html}
```

---

### 7.3 インラインコメント（`//`）

以下の場合のみ記述する:

- 外部仕様・API制約・バグ回避のための特殊処理
- アルゴリズムや計算式の意図が不明瞭な場合

```dart
// APIがページネーションなしで最大100件しか返さない制約があるため上限を設定
const maxFetchCount = 100;

// Flutterの既知のバグ回避: TextFieldのfocusをdisposeより先に外す必要がある
_focusNode.unfocus();
super.dispose();
```

**記述しない場面:**

- コードを読めば明らかな内容
- 変数名・メソッド名で意図が伝わる場合

```dart
// 悪い例: 明らかなのでコメント不要
final count = items.length; // リストの長さを取得
```

---

### 7.4 TODOコメント / FIXMEコメント

```dart
// TODO(担当者名): 内容
// TODO: 内容 [対応期限・条件]
// FIXME: 既知の問題の説明

// 例:
// TODO(yamada): キャッシュ戦略を実装する（パフォーマンス改善タスク #123）
// FIXME: エラー時にローディング状態が解除されないケースがある。原因調査中
```

---

### 7.5 セクション区切りコメント

長いファイルでセクションを分ける場合のみ使用する。

```dart
// ---------------------------------------------------------------------------
// Private helpers
// ---------------------------------------------------------------------------
```

---

### 7.6 言語

コメントは**日本語**で記述する（プロジェクトの主言語に合わせる）。

ただし、以下は英語でも可:

- OSS化・外部公開を想定したライブラリコード
- 外部ライブラリのAPIに合わせる必要がある場面

---

## 8. エラーハンドリング

> **原則:** エラーは握りつぶさない。エラーの種類に応じて適切な層でハンドリングする。

### 8.1 例外の分類

```dart
// ドメイン例外: ビジネスルール違反（アプリ独自）
class UserNotFoundException extends DomainException { ... }
class ValidationException extends DomainException { ... }

// インフラ例外: 外部システムとの通信エラー
class NetworkException extends InfraException { ... }
class StorageException extends InfraException { ... }
```

### 8.2 Result型の使用

成功・失敗の両方が通常のフローになる場合は、例外ではなく `Result` 型を使う。

```dart
// 例外: 呼び出し側が必ず失敗を考慮しなければならない場合
sealed class Result<T> {
  const Result();
}
class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}
class Failure<T> extends Result<T> {
  const Failure(this.exception);
  final Exception exception;
}

// 使用例
Future<Result<User>> fetchUser(String id) async {
  try {
    final user = await _api.getUser(id);
    return Success(user);
  } on NetworkException catch (e) {
    return Failure(e);
  }
}
```

### 8.3 例外を握りつぶさない

```dart
// 悪い例: 例外を無視
try {
  await deleteCache();
} catch (_) {}

// 良い例: ログを残すか、上位に伝播させる
try {
  await deleteCache();
} catch (e, st) {
  logger.error('キャッシュ削除に失敗', error: e, stackTrace: st);
  // 非クリティカルな処理であれば続行してよいが、ログは必ず残す
}
```

---

## 9. テスタビリティ

> **原則（Meta / Google）:** テスト容易な設計が良い設計。依存はインターフェース経由で注入する。

### 9.1 依存性注入（DI）

```dart
// 悪い例: 具体クラスに直接依存（テスト不可）
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState()) {
    _repository = UserRepositoryImpl();  // 具体クラスをここで生成
  }
  late final UserRepositoryImpl _repository;
}

// 良い例: インターフェース経由で注入（テスト可能）
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier(this._repository) : super(const UserState());
  final UserRepository _repository;  // 抽象クラス/インターフェース
}

// Provider でモックに差し替え可能にする
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.watch(userRepositoryProvider));
});
```

### 9.2 テストの粒度

| レイヤー | テストの種類 | モックの対象 |
| --- | --- | --- |
| Domain | ユニットテスト | 外部依存なし |
| Application (Notifier) | ユニットテスト | Repository をモック |
| Infrastructure (Repository) | インテグレーションテスト | 実際のAPI/DBを使用 |
| Presentation (Widget) | Widgetテスト | Notifier をモック |

---

## 10. パフォーマンス

### 10.1 不要な再ビルドの抑制

```dart
// Provider は必要な部分だけを購読する
// 悪い例: 全体を購読（無関係な変更でも再ビルドされる）
final user = ref.watch(userProvider);
Text(user.name)

// 良い例: 必要なプロパティのみを購読
final userName = ref.watch(userProvider.select((u) => u.name));
Text(userName)
```

### 10.2 ListView の最適化

```dart
// 長いリストには ListView.builder を使う（遅延生成）
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)

// 固定の少数アイテムには ListView（children）を使ってよい
ListView(
  children: [
    const HeaderWidget(),
    const ContentWidget(),
  ],
)
```

### 10.3 画像・非同期処理

```dart
// 画像は CachedNetworkImage を使ってキャッシュする
CachedNetworkImage(imageUrl: user.avatarUrl)

// 重い処理は Isolate または compute に移す
final result = await compute(parseJson, jsonString);
```

---

## 11. AIコード生成チェックリスト

AIがコードを生成・レビューする際は以下を必ず確認する。

### 命名

- [ ] クラス・型は `UpperCamelCase` か
- [ ] ファイル名は `snake_case` か
- [ ] bool 変数に `is` / `has` / `can` / `should` がついているか
- [ ] 汎用的すぎる名前（`data`, `info`, `manager`, `util`, `process`）を避けているか
- [ ] 動詞の統一（`fetch` / `load` / `save`）ができているか

### 型・変数

- [ ] 変更しない変数に `final` を使っているか
- [ ] コンパイル時定数に `const` を使っているか
- [ ] マジックナンバーを定数に置き換えているか
- [ ] 不要な `null` 許容型（`?`）を使っていないか

### 関数・Widget設計

- [ ] 1関数が30行以内に収まっているか
- [ ] 1関数が1つの責務のみを持っているか
- [ ] 引数が3個を超える場合に名前付き引数を使っているか
- [ ] Widgetの `build` が50行以内か
- [ ] UIとロジックが分離されているか（ロジックはNotifier/Providerに）

### コメント

- [ ] ドキュメントコメント（`///`）がpublicな定義についているか
- [ ] インラインコメントが「なぜ」を説明しているか（「何を」ではない）
- [ ] コメントが日本語で書かれているか
- [ ] 自明なコメントを書いていないか

### エラーハンドリング

- [ ] `catch (_) {}` で例外を握りつぶしていないか
- [ ] 成功・失敗どちらも通常フローの場合に `Result` 型を使っているか

### テスタビリティ

- [ ] 具体クラスではなくインターフェースに依存しているか
- [ ] 依存オブジェクトをコンストラクタ注入しているか

### パフォーマンス

- [ ] 静的なWidgetに `const` がついているか
- [ ] 長いリストに `ListView.builder` を使っているか
- [ ] 必要なプロパティのみを `select` で購読しているか

---

## 参考資料

- [Effective Dart: Style](https://dart.dev/effective-dart/style)
- [Effective Dart: Usage](https://dart.dev/effective-dart/usage)
- [Effective Dart: Design](https://dart.dev/effective-dart/design)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Google Engineering Practices](https://google.github.io/eng-practices/)
