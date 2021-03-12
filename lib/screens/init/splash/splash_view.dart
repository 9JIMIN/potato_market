import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../../services/local_services.dart';
import '../start/start_view.dart';
import '../base/base_view.dart';

class SplashView extends StatelessWidget {
  final _imagePath = 'assets/splash_image.jpg';
  Future<Widget> _afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    LocalServices().fetchData();
    if (LocalServices().area.name == null) {
      return StartView();
    } else {
      return BaseView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: _afterSplash(context),
      image: Image.asset(
        _imagePath,
        fit: BoxFit.contain,
      ),
      photoSize: 200,
      useLoader: false,
    );
  }
}
