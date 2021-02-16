import 'package:flutter/material.dart';
import 'package:potato_market/providers/local_model.dart';
import 'package:potato_market/screens/start/login/login_view.dart';
import 'package:provider/provider.dart';

import 'base_model.dart';

class BaseView extends StatefulWidget {
  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  @override
  void initState() {
    super.initState();
    var isLogin = context.read<LocalModel>().profile['profileImageUrl'] != null;
    // context.read<LocalModel>().deleteData();
    if (!isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('로그인 하시겠습니까?'),
            content: Text('로그인 없이도 이용은 가능합니다.'),
            actions: [
              FlatButton(
                child: Text('나가기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                child: Text('로그인 하기'),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      });
    }
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
        items: model.bottomItems,
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
