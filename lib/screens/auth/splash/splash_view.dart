import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthProvider>(context, listen: false);
    return SplashScreen(
      navigateAfterFuture: model.afterSplash(context),
      image: Image.asset(
        model.splashImage,
        fit: BoxFit.fill,
      ),
      useLoader: false,
    );
  }
}
