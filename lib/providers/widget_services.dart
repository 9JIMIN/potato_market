import 'package:flutter/material.dart';

class WidgetServices {
  static void showSnack(
    BuildContext context,
    String content,
  ) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  static void showAlertDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [],
      ),
    );
  }
}
