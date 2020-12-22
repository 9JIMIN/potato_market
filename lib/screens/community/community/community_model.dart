import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:potato_market/screens/post_editor/post_editor_screen.dart';

class CommunityModel with ChangeNotifier {
  void onFloatButtonPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostEditorScreen(),
      ),
    );
  }
}
