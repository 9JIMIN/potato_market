import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../models/local.dart';

class LocalProvider with ChangeNotifier {
  Local _local;
  Local get local => _local;

  LocalProvider() {
    log('LocalProvider - init');
    fetchLocal();
  }

  void fetchLocal() async {
    log('LocalProvider - fetchLocal()');
    var box = Hive.box<Local>('local');
    _local = Local.fromBox(box);
    notifyListeners();
  }

  Future<void> updateLocal() async {
    log('LocalProvider - updateLocal()');
    // 데이터베이스에서 내 계정을 찾아서 그 정보들로 업데이트 한다.
  }

  Future<void> deleteLocal() async {
    log('LocalProvider - deleteLocal()');
    // 로그아웃 할때는 로컬 데이터를 전부 지운다.
  }
}
