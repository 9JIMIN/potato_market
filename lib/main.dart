import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:potato_market/screens/market/market_provider.dart';
import 'package:provider/provider.dart';

import 'screens/login/login_screen.dart';
import './screens/main_screen.dart';
import './screens/editor/editor_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<EditorProvider>(
          create: (_) => EditorProvider(),
        ),
        ChangeNotifierProvider<MarketProvider>(
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
