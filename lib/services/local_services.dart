import 'package:hive/hive.dart';
import 'package:potato_market/models/area.dart';

import '../models/profile.dart';
import '../models/trade_point.dart';

class LocalServices {
  static final LocalServices _singleton = LocalServices._();
  LocalServices._();
  factory LocalServices() => _singleton;

  Box _localBox;
  Area _area;
  TradePoint _tradePoint;
  Profile _profile;
  Map<String, bool> _productCategories;
  Map<String, bool> _workCategories;

  Area get area => _area;
  TradePoint get tradePoint => _tradePoint;
  Profile get profile => _profile;
  Map<String, bool> get productCategories => _productCategories;
  Map<String, bool> get workCategories => _workCategories;

  LocalServices fetchData() {
    _localBox = Hive.box('localBox');
    fetchArea();
    fetchTradePoint();
    fetchProfile();
    fetchProductCategories();
    fetchWorkCategories();
    return this;
  }

  // fetch
  void fetchArea() {
    _area = Area(
      lat: _localBox.get('areaLat'),
      lng: _localBox.get('areaLng'),
      radius: _localBox.get('areaRadius'),
      name: _localBox.get('areaName'),
    );
  }

  void fetchTradePoint() {
    _tradePoint = TradePoint(
      lat: _localBox.get('tradePointLat'),
      lng: _localBox.get('tradePointLng'),
      name: _localBox.get('tradePointName'),
    );
  }

  void fetchProfile() {
    _profile = Profile(
      uid: _localBox.get('profileUid'),
      name: _localBox.get('profileName'),
      phoneNumber: _localBox.get('profilePhoneNumber'),
      imageUrl: _localBox.get('profileImageUrl'),
    );
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
    _localBox.put('areaLat', area.lat);
    _localBox.put('areaLng', area.lng);
    _localBox.put('areaRadius', area.radius);
    _localBox.put('areaName', area.name);
    fetchArea();
  }

  void updateTradePoint(TradePoint tradePoint) {
    _localBox.put('tradePointLat', tradePoint.lat);
    _localBox.put('tradePointLng', tradePoint.lng);
    _localBox.put('tradePointName', tradePoint.name);
    fetchTradePoint();
  }

  void updateProfile(Profile profile) {
    _localBox.put('profileUid', profile.uid);
    _localBox.put('profileName', profile.name);
    _localBox.put('profilePhoneNumber', profile.phoneNumber);
    _localBox.put('profileImageUrl', profile.imageUrl);
    fetchProfile();
  }

  void updateProductCategories(Map<String, bool> productCategories) {
    _localBox.putAll(productCategories);
    fetchProductCategories();
  }

  void updateWorkCategories(Map<String, bool> workCategories) {
    _localBox.putAll(workCategories);
    fetchWorkCategories();
  }

  // delete
  void deleteData() async {
    for (var key in _localBox.keys) {
      await _localBox.delete(key);
    }
    fetchData();
  }
}
