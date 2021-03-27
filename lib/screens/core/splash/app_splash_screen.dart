import 'package:flutter/material.dart';
import 'package:potato_market/config/constants/assets_path.dart';
import 'package:splashscreen/splashscreen.dart';

import '../../../utils/services/local/local_storage_service.dart';
import '../../my/my_area_setting/my_area_setting_range.dart';
import '../../auth/login/login_screen.dart';
import '../base/base_screen.dart';

class AppSplashScreen extends StatelessWidget {
  Future<Widget> _afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));

    final local = LocalStorageService().fetchData();
    if (local.profile.imageUrl == null) {
      return LoginScreen();
    } else if (local.area.name == null) {
      return MyAreaSettingRange();
    } else {
      return BaseScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      navigateAfterFuture: _afterSplash(context),
      image: Image.asset(
        AssetsPath.splashImage,
        fit: BoxFit.contain,
      ),
      photoSize: 200,
      useLoader: false,
    );
  }
}
