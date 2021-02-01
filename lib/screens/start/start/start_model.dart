import 'package:flutter/material.dart';

import '../set_area/set_area_range_view.dart';

class StartModel with ChangeNotifier {
  final _startImage = 'assets/start_image.jpg';
  String get startImage => _startImage;

  void toPlace(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SetAreaRangeView()),
    );
  }
}
