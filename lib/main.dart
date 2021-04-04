import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:potato_market/screens/core/splash/app_splash_screen.dart';
import 'package:provider/provider.dart';

// provider
import 'screens/core/base/base_provider.dart';
import 'screens/auth/login/login_provider.dart';
import 'screens/my/my_spot_setting/my_spot_setting_provider.dart';
import 'screens/profile/profile_editor/profile_editor_provider.dart';
import 'screens/my/my_account/my_account_provider.dart';
import 'screens/market/market/market_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox('localBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MySpotSettingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyAccountProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BaseProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileEditorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketProvider(),
        ),
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppSplashScreen(),
    );
  }
}
