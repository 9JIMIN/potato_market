import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class PlaceView extends StatefulWidget {
  @override
  State<PlaceView> createState() => PlaceViewState();
}

class PlaceViewState extends State<PlaceView> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('거래장소 정하기'),
        actions: [
          IconButton(
            icon: Icon(Icons.maps_ugc),
            onPressed: () {
              model.toNewPlaceTarget(context);
            },
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            markers: model.placeMarkers,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: model.myGPSCoords,
              zoom: model.initalCameraZoom,
            ),
            onMapCreated: model.setMapController,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onTap: (_) {
              model.hidePlaceWidget();
            },
          ),
          if (model.isPlaceWidgetVisible)
            Positioned(
              child: ListTile(
                tileColor: Colors.amber,
                title: Text(model.selectedPlace.name),
                subtitle: Text(model.selectedPlace.address +
                    ' | 사용자 수: ' +
                    model.selectedPlace.userCount.toString()),
                trailing: RaisedButton(
                  onPressed: () {
                    model.toSetPlaceRange(context);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
