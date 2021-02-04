import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/local.dart';
import 'screens/market/market/market_model.dart';
import 'screens/start/base/base_model.dart';
import 'screens/start/splash/splash_view.dart';

// provider
import 'providers/local_provider.dart';
import 'screens/start/splash/splash_model.dart';
import 'screens/start/set_area/set_area_model.dart';
import 'screens/start/start/start_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox('area');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocalProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SplashModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => StartModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => SetAreaModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BaseModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MarketModel(),
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
