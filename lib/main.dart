import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// screens
import './screens/auth/login/auth_screen.dart';
import './screens/market/base/base_screen.dart';
import 'screens/market/market/market_model.dart';

// models
import 'package:potato_market/providers/my_model.dart';
import 'package:potato_market/screens/my_account/myaccount_model.dart';
import 'package:potato_market/screens/product_detail/product_detail_model.dart';
import 'package:potato_market/screens/community/community/community_model.dart';
import './screens/auth/auth_model.dart';
import './screens/product_editor/product_editor_model.dart';
import 'screens/base/base_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyAccountModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => BaseModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => MyModel(),
        ),
        ChangeNotifierProvider<MarketModel>(
          create: (_) => MarketModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductDetailModel(),
        ),
        ChangeNotifierProvider<ProductEditorModel>(
          create: (_) => ProductEditorModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => CommunityModel(),
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
            return BaseScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
