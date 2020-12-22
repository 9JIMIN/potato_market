import 'package:flutter/material.dart';
import 'package:potato_market/providers/my_model.dart';
import 'package:potato_market/screens/base/base_model.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MyModel>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BaseModel>(context);
    return Scaffold(
      appBar: model.appbar(),
      body: IndexedStack(
        children: model.bodies,
        index: model.selectedIndex,
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
        onTap: model.onBottomTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        currentIndex: model.selectedIndex,
      ),
      floatingActionButton: model.floatingActionButton(),
    );
  }
}
