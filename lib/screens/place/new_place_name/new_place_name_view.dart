// import 'package:flutter/material.dart';
// import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:provider/provider.dart';

// import '../../../providers/auth_provider.dart';

// class NewPlaceName extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<AuthProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('새 위치 이름 등록'),
//       ),
//       body: ModalProgressHUD(
//         inAsyncCall: model.isNewPlaceNameLoading,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Text('새로운 위치를 설명해주세요'),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       decoration: InputDecoration(
//                         alignLabelWithHint: true,
//                       ),
//                       onSaved: (String newPlaceName) {
//                         model.onSave(newPlaceName, context);
//                       },
//                     ),
//                     RaisedButton(
//                       onPressed: () {
//                         _formKey.currentState.save();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
