// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/auth_provider.dart';

// class NewPlaceTarget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('새로운 거래장소 추가하기'),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           GoogleMap(
//             markers: model.newPlaceMarkers,
//             mapType: MapType.normal,
//             onMapCreated: model.setNewPlaceController,
//             initialCameraPosition: CameraPosition(
//               target: model.myGPSCoords,
//               zoom: model.initalCameraZoom,
//             ),
//             zoomControlsEnabled: false,
//             onCameraMoveStarted: model.hideRegisterButton,
//             onCameraIdle: model.showRegisterButton,
//           ),
//           Positioned(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Visibility(
//                   maintainState: true,
//                   maintainAnimation: true,
//                   maintainSize: true,
//                   visible: model.isRegisterButtonVisible,
//                   child: RaisedButton(
//                     child: Text('이 위치 등록하기'),
//                     onPressed: () {
//                       model.registerNewPlace(context);
//                     },
//                   ),
//                 ),
//                 Icon(
//                   Icons.pin_drop,
//                   size: 50,
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
