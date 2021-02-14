import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:potato_market/models/area.dart';

import '../models/profile.dart';

class LocalModel with ChangeNotifier {
  Box _localBox;
  Map<String, dynamic> _area;
  Map<String, dynamic> _profile;
  Map<String, bool> _productCategories;
  Map<String, bool> _workCategories;

  Map<String, dynamic> get area => _area;
  Map<String, dynamic> get profile => _profile;
  Map<String, bool> get productCategories => _productCategories;
  Map<String, bool> get workCategories => _workCategories;

  void fetchData() {
    _localBox = Hive.box('localBox');
    fetchArea();
    fetchProfile();
    fetchProductCategories();
    fetchWorkCategories();
  }

  // fetch
  void fetchArea() {
    _area = {
      'lat': _localBox.get('lat'),
      'lng': _localBox.get('lng'),
      'radius': _localBox.get('radius'),
      'areaName': _localBox.get('name'),
    };
  }

  void fetchProfile() {
    _profile = {
      'uid': _localBox.get('uid'),
      'profileName': _localBox.get('name'),
      'phoneNumber': _localBox.get('phoneNumber'),
      'profileImageUrl': _localBox.get('imageUrl'),
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
      'cleanning': _localBox.get('clean'),
      'delivery': _localBox.get('delivery'),
      'etc': _localBox.get('etc'),
    };
  }

  // update
  void updateArea(Area area) {
    _localBox.put('lat', area.latitude);
    _localBox.put('lng', area.longitude);
    _localBox.put('radius', area.radius);
    _localBox.put('areaName', area.name);
    fetchArea();
    print('area update ==> ' + _area.toString());
  }

  void updateProfile(Profile profile) {
    _localBox.put('uid', profile.uid);
    _localBox.put('profileName', profile.name);
    _localBox.put('phoneNumber', profile.phoneNumber);
    _localBox.put('profileImageUrl', profile.imageUrl);
    fetchProfile();
    print('profile update ==> ' + _profile.toString());
  }

  void updateProductCategories(Map<String, bool> productCategories) {
    _localBox.putAll(productCategories);
    print('productCategories update ==> ' + _productCategories.toString());
  }

  void updateWorkCategories(Map<String, bool> workCategories) {
    _localBox.putAll(workCategories);
    print('workCategories update ==> ' + _workCategories.toString());
  }

  // delete
  void deleteData() {
    for (var key in _localBox.keys) {
      _localBox.delete(key);
    }
    fetchData();
  }
}
