import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BaseProvider>(context);
    return Scaffold(
        appBar: model.appbar(),
        body: IndexedStack(
          children: model.bodies,
          index: model.selectedIndex,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: model.bottomItems,
          onTap: model.onBottomTap,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black,
          currentIndex: model.selectedIndex,
        ),
        floatingActionButton: model.floatingActionButton());
  }
}
