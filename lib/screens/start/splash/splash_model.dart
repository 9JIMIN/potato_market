import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../start/start_view.dart';
import '../base/base_view.dart';

import '../../../providers/local_provider.dart';

class SplashModel with ChangeNotifier {
  final _splashImage = 'assets/splash_image.jpg';
  String get splashImage => _splashImage;

  Future<Widget> afterSplash(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    if (context.read<LocalProvider>().areaBox.isEmpty) {
      return StartView();
    } else {
      return StartView();
      // return BaseView();
    }
  }
}
