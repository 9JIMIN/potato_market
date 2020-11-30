import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'market/widgets/market_appbar.dart';
import './community/community_appbar.dart';

import 'market/market_screen.dart';
import './community/community_body.dart';
import './chat/chat_appbar.dart';
import './chat/chat_body.dart';
import './my_account/myprofile_body.dart';
import './my_account/myprofile_appbar.dart';

import 'product_editor/product_editor_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 제품 화면
  void _toEditor() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProductEditorScreen()));
  }

  // 프로필 화면
  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _onBottomTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _appbar = <Widget>[
    MarketAppbar(),
    CommunityAppbar(),
    ChatAppbar(),
    MyProfileAppbar(),
  ];
  List<Widget> _body = <Widget>[
    MarketScreen(),
    CommunityBody(),
    ChatBody(),
    MyProfileBody(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar[_selectedIndex],
      body: IndexedStack(
        children: _body,
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        ],
        onTap: _onBottomTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
      ),
      floatingActionButton: [0, 3].contains(_selectedIndex)
          ? FloatingActionButton(
              child: Icon(_selectedIndex == 0 ? Icons.add : Icons.exit_to_app),
              onPressed: _selectedIndex == 0 ? _toEditor : _logout,
            )
          : null,
    );
  }
}
