import 'package:flutter/material.dart';

import '../screens/start/set_area/set_area_name_view.dart';
import '../screens/start/set_area/set_area_range_view.dart';
import '../screens/start/base/base_view.dart';

class NavigationServices {
  static void toSetAreaRange(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SetAreaRangeView()),
    );
  }

  static void toSetAreaName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SetAreaNameView()),
    );
  }

  static void toBase(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BaseView()),
      (_) => false,
    );
  }
}
