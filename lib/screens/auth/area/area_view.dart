import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class AreaView extends StatefulWidget {
  @override
  State<AreaView> createState() => AreaViewState();
}

class AreaViewState extends State<AreaView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Area'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: model.googleMap(),
          ),
          Flexible(
            flex: 2,
            child: Text('1'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.gps_fixed),
        onPressed: model.centerMap,
      ),
    );
  }
}
