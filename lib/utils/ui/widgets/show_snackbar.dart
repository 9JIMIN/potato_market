import 'package:flutter/material.dart';

class ShowSnackbar {
  static void snack(
    BuildContext context,
    String content,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
        content: Text(content),
      ),
    );
  }
}
