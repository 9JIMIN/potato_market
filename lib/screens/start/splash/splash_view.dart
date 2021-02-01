import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:provider/provider.dart';

import 'splash_model.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<SplashModel>(context, listen: false);
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
