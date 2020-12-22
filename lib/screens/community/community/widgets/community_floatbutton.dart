import 'package:flutter/material.dart';
import 'package:potato_market/screens/community/community/community_model.dart';
import 'package:provider/provider.dart';

class CommunityFloatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      context.read<CommunityModel>().onFloatButtonPressed(context);
    });
  }
}
