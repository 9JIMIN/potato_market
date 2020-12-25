import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../post_editor/post_editor_screen.dart';

class CommunityModel with ChangeNotifier {
  void onFloatButtonPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostEditorScreen(),
      ),
    );
  }
}
