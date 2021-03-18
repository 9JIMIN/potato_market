import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../../services/local_services.dart';
import '../login/login_view.dart';
import '../base/base_view.dart';

class SplashView extends StatelessWidget {
  final _imagePath = 'assets/splash_image.jpg';

  Future<Widget> _afterSplash(BuildContext context) async {
    // splash 대기시간
    await Future.delayed(Duration(seconds: 1));
    // 로컬 데이터 가져오기, 확인
    LocalServices().fetchData();
    if (LocalServices().profile.uid == null) {
      return LoginView();
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
