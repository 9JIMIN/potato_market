import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// screens
import './screens/auth/auth_screen.dart';
import './screens/main_screen.dart';
import 'screens/market/market_model.dart';

// models
import './screens/auth/auth_model.dart';
import './screens/product_editor/product_editor_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthModel(),
        ),
        ChangeNotifierProvider<ProductEditorModel>(
          create: (_) => ProductEditorModel(),
        ),
        ChangeNotifierProvider<MarketModel>(
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return MainScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
