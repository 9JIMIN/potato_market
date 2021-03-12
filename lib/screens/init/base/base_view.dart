import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/local_services.dart';
import './widgets/login_dialog.dart';
import 'base_model.dart';

class BaseView extends StatefulWidget {
  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  @override
  void initState() {
    super.initState();
    var isLogin = LocalServices().profile.imageUrl != null;
    if (!isLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
          context: context,
          builder: (_) => LoginDialog(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BaseModel>(context);
    final isLogin = LocalServices().profile.uid != null;
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
      floatingActionButton: isLogin ? model.floatingActionButton() : null,
    );
  }
}
