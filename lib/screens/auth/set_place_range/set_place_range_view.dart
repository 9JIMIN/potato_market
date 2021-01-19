import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class SetPlaceRange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('범위 정하기'),
      ),
      body: GoogleMap(
        // markers: model.newPlaceMarkers,
        mapType: MapType.normal,
        // onMapCreated: model.setNewPlaceController,
        initialCameraPosition: CameraPosition(
          target: model.myGPSCoords,
          zoom: model.initalCameraZoom,
        ),
        zoomControlsEnabled: false,
        // onCameraMoveStarted: model.hideRegisterButton,
        // onCameraIdle: model.showRegisterButton,
      ),
    );
  }
}
