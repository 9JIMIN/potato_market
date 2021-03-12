import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/init/splash/splash_view.dart';

// provider
import 'screens/init/base/base_model.dart';
import 'screens/map/set_trade_point/set_trade_point_model.dart';
import 'screens/map/set_area/set_area_model.dart';
import 'screens/profile/login/login_model.dart';
import 'screens/profile/profile_editor/profile_editor_model.dart';
import 'screens/market/market/market_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox('localBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SetAreaModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BaseModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileEditorModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SetTradePointModel(),
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
      home: SplashView(),
    );
  }
}
