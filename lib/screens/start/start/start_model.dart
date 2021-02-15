import 'package:flutter/material.dart';

import '../../../services/navigation_services.dart';

class StartModel with ChangeNotifier {
  final _startImage = 'assets/start_image.jpg';
  String get startImage => _startImage;

  void onStartPressed(BuildContext context) {
    NavigationServices.toSetAreaRange(context);
  }
}
