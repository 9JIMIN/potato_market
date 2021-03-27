import 'package:flutter/material.dart';

import '../../../models/spot.dart';
import '../../../screens/core/base/base_screen.dart';
import '../../../screens/my/my_area_setting/my_area_setting_name.dart';
import '../../../screens/my/my_area_setting/my_area_setting_range.dart';
import '../../../screens/my/my_spot_setting/my_spot_setting_name.dart';
import '../../../screens/my/my_spot_setting/my_spot_setting_point.dart';
import '../../../screens/profile/profile_editor/profile_editor_screen.dart';
import '../../../screens/auth/login/login_screen.dart';
import '../../../screens/market/item_editor/item_editor_screen.dart';

class NavigationService {
  static void toSetAreaRange(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyAreaSettingRange()),
      (route) => false,
    );
  }

  static void toSetAreaName(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => MyAreaSettingName()),
    );
  }

  static void toBase(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BaseScreen()),
      (_) => false,
    );
  }

  static void toProfileEditor(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => ItemEditorScreen()),
      (route) => false,
    );
  }

  static void toLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  static void toProductEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ItemEditorScreen()),
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
