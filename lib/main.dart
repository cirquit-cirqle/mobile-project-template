import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';
import 'services/mock_auth_service.dart';

void main() {
  // Infrastructure / Data 層のインスタンス生成
  // 実プロジェクトでは環境に応じた実装に差し替える
  final authService = MockAuthService();

  runApp(MyApp(authService: authService));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    // DI: ルートで Provider を提供し、全Widgetからアクセス可能にする
    // レイヤー設計: docs/architecture/01_layer_design.md 参照
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(authService),
      // AuthProvider.dispose() で StreamSubscription を解除
      // MockAuthService.dispose() も連動させるため AuthProvider 内で管理
      child: MaterialApp(
        title: 'Mobile Project Template',
        theme: ThemeData(
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) {
            // 認証状態に応じた画面切り替え
            // 画面遷移設計: docs/architecture/03_navigation_routing.md 参照
            if (auth.isLoggedIn) {
              return const HomeScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
