import 'package:flutter/material.dart';
import 'package:potato_market/models/area.dart';
import 'package:potato_market/models/profile.dart';
import 'package:potato_market/models/spot.dart';
import 'package:potato_market/utils/services/local/local_storage_service.dart';

class MyAccountBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Area area = LocalStorageService().area;
    final Spot spot = LocalStorageService().spot;
    final Profile profile = LocalStorageService().profile;
    final Map category = LocalStorageService().itemCategories;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (area.id != null)
          Column(
            children: [
              Text('area id: ${area.id}'),
              Text('area name: ${area.name}'),
              Text('area point: lat(${area.lat}), lng(${area.lng})'),
              Text('area radius: ${area.radius.toString()}'),
              Text('area active: ${area.active.toString()}'),
            ],
          ),
        if (spot.id != null)
          Column(
            children: [
              Text('spot id: ${spot.id}'),
              Text('spot name: ${spot.name}'),
              Text('spot address: ${spot.address}'),
              Text('spot point: lat(${spot.lat}), lng(${spot.lng})'),
              Text('spot usedAt: ${spot.usedAt}'),
            ],
          ),
        if (profile.uid != null)
          Column(
            children: [
              Text('profile uid: ${profile.uid}'),
              Text('profile name: ${profile.name}'),
              Text('profile imageUrl: ${profile.imageUrl}'),
              Text('profile phoneNumber: ${profile.phoneNumber}'),
            ],
          ),
        Column(
          children: [
            Text(category.values.toList().toString()),
          ],
        ),
        ElevatedButton(
          onPressed: LocalStorageService().deleteData,
          child: Text('로컬 데이터 삭제'),
        ),
      ],
    );
  }
}
