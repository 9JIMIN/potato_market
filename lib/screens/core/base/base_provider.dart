import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../chat/chat_list/widgets/chat_list_appbar.dart';
import '../../chat/chat_list/chat_list_body.dart';
import '../../my/my_account/widgets/my_account_appbar.dart';
import '../../my/my_account/my_account_body.dart';
import '../../market/market/widgets/market_appbar.dart';
import '../../market/market/market_body.dart';
import '../../market/market/widgets/market_floatbutton.dart';

class BaseProvider with ChangeNotifier {
  int _selectedIndex = 0;

  List<Widget> _bodies = <Widget>[
    MarketBody(),
    ChatListBody(),
    MyAccountBody(),
  ];

  List<BottomNavigationBarItem> _bottomItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.list_alt),
      label: '제품',
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
        return ChatListAppbar();
      default:
        return MyAccountAppbar();
    }
  }

  Widget floatingActionButton() {
    switch (_selectedIndex) {
      case 0:
        return MarketFloatButton();
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
