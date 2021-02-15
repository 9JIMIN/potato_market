import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../start/start_view.dart';
import '../base/base_view.dart';

import '../../../providers/local_model.dart';

class SplashModel with ChangeNotifier {
  final _splashImage = 'assets/splash_image.jpg';
  String get splashImage => _splashImage;

  Future<Widget> afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    context.read<LocalModel>().fetchData();
    if (context.read<LocalModel>().area['areaName'] == null) {
      return StartView();
    } else {
      return BaseView();
    }
  }
}
