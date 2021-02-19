import 'package:flutter/material.dart';

import '../screens/start/set_area/set_area_name_view.dart';
import '../screens/start/set_area/set_area_range_view.dart';
import '../screens/start/base/base_view.dart';
import '../screens/start/profile_editor/profile_editor_view.dart';
import '../screens/start/login/login_view.dart';
import '../screens/market/product_editor/product_editor_view.dart';
import '../screens/community/post_editor/post_editor_screen.dart';

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
}
