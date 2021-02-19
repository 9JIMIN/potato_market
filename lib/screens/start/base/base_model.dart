import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../market/market/widgets/market_appbar.dart';
import '../../market/market/market_view.dart';
import '../../market/market/widgets/market_floatbutton.dart';

import '../../community/community/widgets/community_appbar.dart';
import '../../community/community/community_body.dart';
import '../../community/community/widgets/community_floatbutton.dart';

import '../../chat/chat/chat_appbar.dart';
import '../../chat/chat/chat_body.dart';

import '../../account/my_account/myaccount_body.dart';
import '../../account/my_account/widgets/myaccount_appbar.dart';

class BaseModel with ChangeNotifier {
  int _selectedIndex = 0;

  List<Widget> _bodies = <Widget>[
    MarketView(),
    CommunityBody(),
    ChatBody(),
    MyAccountBody(),
  ];

  List<BottomNavigationBarItem> _bottomItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt),
      label: '제품',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt),
      label: '커뮤니티',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: '채팅',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      label: '프로필',
    ),
  ];

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

  // Bottom tap
  void onBottomTap(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;
  List<Widget> get bodies => _bodies;
  List<BottomNavigationBarItem> get bottomItems => _bottomItems;
}
