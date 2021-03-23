import 'package:flutter/material.dart';
import 'package:potato_market/screens/map/set_area/set_area_range_view.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../../services/local_services.dart';
import '../login/login_view.dart';
import '../base/base_view.dart';

class SplashView extends StatelessWidget {
  final _splashImage = 'assets/splash_image.jpg';

  Future<Widget> _afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));

    final local = LocalServices().fetchData();
    if (local.profile.imageUrl == null) {
      return LoginView();
    } else if (local.area.name == null) {
      return SetAreaRangeView();
    } else {
      return BaseView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: _afterSplash(context),
      image: Image.asset(
        _splashImage,
        fit: BoxFit.contain,
      ),
      photoSize: 200,
      useLoader: false,
    );
  }
}
