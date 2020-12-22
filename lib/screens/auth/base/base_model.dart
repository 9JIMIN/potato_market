import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:potato_market/screens/community/widgets/community_floatbutton.dart';
import 'package:potato_market/screens/market/widgets/market_floatbutton.dart';
import 'package:potato_market/screens/post_editor/post_editor_screen.dart';

import '../market/widgets/market_appbar.dart';
import '../community/widgets/community_appbar.dart';

import '../market/market/market_screen.dart';
import '../community/community/community_body.dart';
import '../chat/chat_appbar.dart';
import '../chat/chat_body.dart';
import '../my_account/myaccount_body.dart';
import '../my_account/widgets/myaccount_appbar.dart';

import '../product_editor/product_editor_screen.dart';

class BaseModel with ChangeNotifier {
  int _selectedIndex = 0;

  Widget appbar() {
    switch (_selectedIndex) {
      case 0:
        return MarketAppbar();
      case 1:
        return CommunityAppbar();
      case 2:
        return ChatAppbar();
      default:
        return MyAccountAppbar();
    }
  }

  Widget floatingActionButton() {
    switch (_selectedIndex) {
      case 0:
        return MarketFloatButton();
      case 1:
        return CommunityFloatButton();
      default:
        return null;
    }
  }

  List<Widget> _bodies = <Widget>[
    MarketScreen(),
    CommunityBody(),
    ChatBody(),
    MyAccountBody(),
  ];

  int get selectedIndex => _selectedIndex;
  List<Widget> get bodies => _bodies;

  // FloatingActionButton tap
  void onMarketFloatPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditorScreen(),
      ),
    );
  }

  void onCommunityFloatPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostEditorScreen(),
      ),
    );
  }

  void onMyPotatoFloatPressed() async {
    await FirebaseAuth.instance.signOut();
  }

  // Bottom tap
  void onBottomTap(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
