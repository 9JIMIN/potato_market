import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:potato_market/models/area.dart';

import '../models/local.dart';

class LocalProvider with ChangeNotifier {
  Box _areaBox;
  Box get areaBox => _areaBox;

  LocalProvider() {
    fetchArea();
  }

  void fetchArea() {
    _areaBox = Hive.box('area');
  }

  void updateArea(Area area) {
    areaBox.put('lat', area.latitude);
    areaBox.put('lng', area.longitude);
    areaBox.put('radius', area.radius);
    areaBox.put('name', area.name);
    log(_areaBox.get('name'));
  }
}
