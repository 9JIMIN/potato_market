import 'package:hive/hive.dart';
import 'package:potato_market/models/area.dart';

import '../../../models/profile.dart';
import '../../../models/spot.dart';

class LocalStorageService {
  static final LocalStorageService _singleton = LocalStorageService._();
  LocalStorageService._();
  factory LocalStorageService() => _singleton;

  Box _localBox;

  Profile _profile;
  Area _area;
  Spot _spot;
  Map<String, bool> _itemCategories;

  Profile get profile => _profile;
  Area get area => _area;
  Spot get spot => _spot;
  Map<String, bool> get itemCategories => _itemCategories;

  LocalStorageService fetchData() {
    _localBox = Hive.box('localBox');
    fetchProfile();
    fetchArea();
    fetchSpot();
    fetchItemCategories();
    return this;
  }

  // fetch
  void fetchProfile() {
    _profile = Profile(
      uid: _localBox.get('profileUid'),
      name: _localBox.get('profileName'),
      phoneNumber: _localBox.get('profilePhoneNumber'),
      imageUrl: _localBox.get('profileImageUrl'),
    );
  }

  void fetchArea() {
    final Map<String, double> point = _localBox.get('areaPoint');
    _area = Area(
      id: _localBox.get('areaId'),
      point: {'lat': point['lat'], 'lng': point['lng']},
      name: _localBox.get('areaName'),
      radius: _localBox.get('areaRadius'),
      active: _localBox.get('areaActive'),
    );
  }

  void fetchSpot() {
    final Map<String, double> point = _localBox.get('spotPoint');
    _spot = Spot(
      id: _localBox.get('spotId'),
      point: {'lat': point['lat'], 'lng': point['lng']},
      name: _localBox.get('spotName'),
      address: _localBox.get('spotAddress'),
      usedAt: _localBox.get('spotUsedAt'),
    );
  }

  void fetchItemCategories() {
    _itemCategories = {
      'cloth': _localBox.get('cloth'),
      'digital': _localBox.get('digital'),
      'etc': _localBox.get('etc'),
    };
  }

  // update
  void updateProfile(Profile profile) {
    _localBox.put('profileUid', profile.uid);
    _localBox.put('profileName', profile.name);
    _localBox.put('profilePhoneNumber', profile.phoneNumber);
    _localBox.put('profileImageUrl', profile.imageUrl);
    fetchProfile();
  }

  void updateArea(Area area) {
    _localBox.put('areaId', area.id);
    _localBox.put('areaPoint', area.point);
    _localBox.put('areaName', area.name);
    _localBox.put('areaRadius', area.radius);
    _localBox.put('areaActive', area.active);
    fetchArea();
  }

  void updateSpot(Spot spot) {
    _localBox.put('spotId', spot.id);
    _localBox.put('spotLat', spot.point);
    _localBox.put('spotName', spot.name);
    _localBox.put('spotAddress', spot.address);
    _localBox.put('spotUsedAt', spot.usedAt);
    fetchSpot();
  }

  void updateProductCategories(Map<String, bool> itemCategories) {
    _localBox.putAll(itemCategories);
    fetchItemCategories();
  }

  // delete
  void deleteData() async {
    for (var key in _localBox.keys) {
      await _localBox.delete(key);
    }
    fetchData();
  }
}
