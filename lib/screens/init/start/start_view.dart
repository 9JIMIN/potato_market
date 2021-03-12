import 'package:flutter/material.dart';

import '../../../services/navigation_services.dart';

class StartView extends StatelessWidget {
  final imagePath = 'assets/start_image.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to 감자마켓'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('시작!'),
          onPressed: () {
            NavigationServices.toSetAreaRange(context);
          },
        ),
      ),
    );
  }
}
