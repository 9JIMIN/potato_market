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
  Map<String, bool> _productCategories;
  Map<String, bool> _workCategories;

  Profile get profile => _profile;
  Area get area => _area;
  Spot get spot => _spot;
  Map<String, bool> get productCategories => _productCategories;
  Map<String, bool> get workCategories => _workCategories;

  LocalStorageService fetchData() {
    _localBox = Hive.box('localBox');
    fetchProfile();
    fetchArea();
    fetchSpot();
    fetchProductCategories();
    fetchWorkCategories();
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
    _area = Area(
      lat: _localBox.get('areaLat'),
      lng: _localBox.get('areaLng'),
      radius: _localBox.get('areaRadius'),
      name: _localBox.get('areaName'),
    );
  }

  void fetchSpot() {
    _spot = Spot(
        lat: _localBox.get('spotLat'),
        lng: _localBox.get('spotLng'),
        name: _localBox.get('spotName'),
        address: _localBox.get('spotAddress'));
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
  void updateProfile(Profile profile) {
    _localBox.put('profileUid', profile.uid);
    _localBox.put('profileName', profile.name);
    _localBox.put('profilePhoneNumber', profile.phoneNumber);
    _localBox.put('profileImageUrl', profile.imageUrl);
    fetchProfile();
  }

  void updateArea(Area area) {
    _localBox.put('areaLat', area.lat);
    _localBox.put('areaLng', area.lng);
    _localBox.put('areaName', area.name);
    _localBox.put('areaRadius', area.radius);
    fetchArea();
  }

  void updateSpot(Spot spot) {
    _localBox.put('spotLat', spot.lat);
    _localBox.put('spotLng', spot.lng);
    _localBox.put('spotName', spot.name);
    _localBox.put('spotAddress', spot.address);
    fetchSpot();
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
