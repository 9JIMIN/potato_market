import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  static Future<void> showLocationAlertDialog(BuildContext context) =>
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('위치 권한이 없으면 감자마켓 서비스를 이용하실 수 없습니다.'),
          actions: [
            FlatButton(
              child: Text('확인'),
              onPressed: Navigator.of(context).pop,
            )
          ],
        ),
      );

  static Future<void> showAppSettingDialog(BuildContext context) => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('위치 권한이 꺼져있습니다. \n[권한] 설정에서 위치 권한을 허용햐야 합니다.'),
          actions: [
            FlatButton(
              child: Text('취소'),
              onPressed: Navigator.of(context).pop,
            ),
            FlatButton(
              child: Text('설정으로 가기'),
              onPressed: () async {
                await Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
}
