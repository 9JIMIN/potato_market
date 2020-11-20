import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './products/products_appbar.dart';
import './community/community_appbar.dart';
import './chatting/chatting_appbar.dart';
import './myprofile/myprofile_appbar.dart';

import './products/products_body.dart';
import './community/community_body.dart';
import './chatting/chatting_body.dart';
import './myprofile/myprofile_body.dart';

import './editor/editor_scaffold.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // 제품 화면
  void _toEditor() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditorScaffold()));
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
    ProductsAppbar(),
    CommunityAppbar(),
    ChattingAppbar(),
    MyProfileAppbar(),
  ];
  List<Widget> _body = <Widget>[
    ProductsBody(),
    CommunityBody(),
    ChattingBody(),
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
