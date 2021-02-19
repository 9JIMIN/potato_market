import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:potato_market/models/area.dart';

import '../models/profile.dart';
import '../models/trade_point.dart';

class LocalModel with ChangeNotifier {
  Box _localBox;
  Map<String, dynamic> _area;
  Map<String, dynamic> _tradePoint;
  Map<String, dynamic> _profile;
  Map<String, bool> _productCategories;
  Map<String, bool> _workCategories;

  Map<String, dynamic> get area => _area;
  Map<String, dynamic> get tradePoint => _tradePoint;
  Map<String, dynamic> get profile => _profile;
  Map<String, bool> get productCategories => _productCategories;
  Map<String, bool> get workCategories => _workCategories;

  void fetchData() {
    _localBox = Hive.box('localBox');
    fetchArea();
    fetchTradePoint();
    fetchProfile();
    fetchProductCategories();
    fetchWorkCategories();
  }

  // fetch
  void fetchArea() {
    _area = {
      'areaLat': _localBox.get('areaLat'),
      'areaLng': _localBox.get('areaLng'),
      'areaRadius': _localBox.get('areaRadius'),
      'areaName': _localBox.get('areaName'),
    };
  }

  void fetchTradePoint() {
    _tradePoint = {
      'tradePointLat': _localBox.get('tradePointLat'),
      'tradePointLng': _localBox.get('tradePointLng'),
      'tradePointName': _localBox.get('tradePointName'),
      'tradePointCount': _localBox.get('tradePointCount'),
    };
  }

  void fetchProfile() {
    _profile = {
      'uid': _localBox.get('uid'),
      'profileName': _localBox.get('profileName'),
      'phoneNumber': _localBox.get('phoneNumber'),
      'profileImageUrl': _localBox.get('profileImageUrl'),
    };
  }

  void fetchProductCategories() {
    _productCategories = {
      'cloth': _localBox.get('cloth'),
      'digital': _localBox.get('digital'),
      'etc': _localBox.get('etc'),
    };
  }

  void fetchWorkCategories() {
    _workCategories = {
      'cleanning': _localBox.get('cleanning'),
      'delivery': _localBox.get('delivery'),
      'etc': _localBox.get('etc'),
    };
  }

  // update
  void updateArea(Area area) {
    _localBox.put('areaLat', area.latitude);
    _localBox.put('areaLng', area.longitude);
    _localBox.put('areaRadius', area.radius);
    _localBox.put('areaName', area.name);
    fetchArea();
    log('area update ==> ' + _area.toString());
  }

  void updateTradePoint(TradePoint tradePoint) {
    _localBox.put('tradePointLat', tradePoint.point.latitude);
    _localBox.put('tradePointLng', tradePoint.point.longitude);
    _localBox.put('tradePointName', tradePoint.name);
    _localBox.put('tradePointCount', tradePoint.tradeCount);
    fetchTradePoint();
    log('tradePoint update => ' + _tradePoint.toString());
  }

  void updateProfile(Profile profile) {
    _localBox.put('uid', profile.uid);
    _localBox.put('profileName', profile.name);
    _localBox.put('phoneNumber', profile.phoneNumber);
    _localBox.put('profileImageUrl', profile.imageUrl);
    fetchProfile();
    log('profile update ==> ' + _profile.toString());
  }

  void updateUidAndPhoneNumber(String uid, String phoneNumber) {
    _localBox.put('uid', uid);
    _localBox.put('phoneNumber', phoneNumber);
    fetchProfile();
    log('uid and phoneNumber update ==>' + _profile.toString());
  }

  void updateProductCategories(Map<String, bool> productCategories) {
    _localBox.putAll(productCategories);
    log('productCategories update ==> ' + _productCategories.toString());
  }

  void updateWorkCategories(Map<String, bool> workCategories) {
    _localBox.putAll(workCategories);
    log('workCategories update ==> ' + _workCategories.toString());
  }

  // delete
  void deleteData() {
    for (var key in _localBox.keys) {
      _localBox.delete(key);
    }
    fetchData();
  }
}
