import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ShowDialog {
  static void alert(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  static void locationAlert(BuildContext context) {
    final content = '위치 권한이 없으면 감자마켓 서비스를 이용하실 수 없습니다.';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  static void appSetting(BuildContext context) {
    final content = '위치 권한이 꺼져있습니다. \n[권한] 설정에서 위치 권한을 허용해야 합니다.';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
            child: Text('취소'),
            onPressed: Navigator.of(context).pop,
          ),
          TextButton(
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
}
