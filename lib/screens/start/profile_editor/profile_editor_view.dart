import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_editor_model.dart';
import '../../../services/navigation_services.dart';

class ProfileEditorView extends StatefulWidget {
  @override
  _ProfileEditorViewState createState() => _ProfileEditorViewState();
}

class _ProfileEditorViewState extends State<ProfileEditorView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileEditorModel>().onProfileInit();
  }

  @override
  void dispose() {
    context.read<ProfileEditorModel>().onProfileDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ProfileEditorModel>(context);
    return Scaffold(
      key: model.testkey,
      appBar: AppBar(
        title: Text('프로필 입력'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 50, right: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundImage: model.profileImage == null
                    ? AssetImage('assets/default_user.jpg')
                    : FileImage(model.profileImage),
                radius: 50,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15.0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      iconSize: 15,
                      color: Colors.grey,
                      onPressed: () {
                        model.onCameraButtonPressed(context);
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Form(
              key: model.formKey,
              child: TextFormField(
                focusNode: model.nameFieldFocus,
                controller: model.nameFieldController,
                keyboardType: TextInputType.name,
                onChanged: model.onNameFieldChanged,
                decoration: InputDecoration(
                  hintText: '닉네임을 입력해주세요.',
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '감자마켓은 당근마켓을 따라 만든 앱입니다. \n실제로 서비스를 하지는 않습니다.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.amber,
              disabledColor: Colors.grey,
              child: Text('계정 생성'),
              onPressed: model.isRegisterButtonActive
                  ? () {
                      model.onProfileButtonPressed(context);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
