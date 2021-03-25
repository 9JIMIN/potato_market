import 'package:flutter/material.dart';

import '../screens/init/base/base_view.dart';
import '../screens/map/set_area/set_area_name_view.dart';
import '../screens/map/set_area/set_area_range_view.dart';
import '../screens/map/set_trade_point/set_point_name_view.dart';
import '../screens/map/set_trade_point/set_trade_point_view.dart';
import '../screens/account/profile_editor/profile_editor_view.dart';
import '../screens/init/login/login_view.dart';
import '../screens/market/product_editor/product_editor_view.dart';
import '../screens/community/post_editor/post_editor_screen.dart';

import '../models/spot.dart';

class NavigationServices {
  static void toSetAreaRange(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SetAreaRangeView()),
      (route) => false,
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

  static void toProfileEditor(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ProfileEditorView()),
      (route) => false,
    );
  }

  static void toLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginView()),
      (route) => false,
    );
  }

  static void toProductEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProductEditorView()),
    );
  }

  static void toPostEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PostEditorScreen()),
    );
  }

  static Future<Spot> toSetSpot(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SetSpotView()),
    );
    if (result != null) {
      return result;
    }
    return null;
  }

  static void toSetPointName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => SetPointNameView()),
    );
  }
}
