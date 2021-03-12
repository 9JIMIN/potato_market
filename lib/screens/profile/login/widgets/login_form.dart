import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../login_model.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
    context.read<LoginModel>().onLoginInit();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginModel>(context, listen: false);
    final isSendButtonActive = context.select(
      (LoginModel model) => model.isSendButtonActive,
    );
    final isStartButtonActive = context.select(
      (LoginModel model) => model.isStartButtonActive,
    );

    Widget phoneField() => TextFormField(
          focusNode: model.phoneFieldFocus,
          controller: model.phoneFieldController,
          onChanged: model.onPhoneFieldChanged,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '휴대폰 번호를 입력해주세요',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );

    Widget sendButton() => RaisedButton(
          child: Text(model.isSendButtonPressed ? '인증번호 다시받기' : '인증번호 받기'),
          onPressed: isSendButtonActive ? model.onSendButtonPressed : null,
          color: Colors.amber,
          disabledColor: Colors.grey,
        );

    Widget certField() => TextFormField(
          focusNode: model.certFieldFocus,
          controller: model.certFieldController,
          onChanged: model.onCertFieldChanged,
          validator: model.certFieldValidator,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          maxLength: 6,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: '인증번호 6자리',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        );

    Widget termsButton() => FlatButton(
          child: Text('이용약관 및 개인정보취급방침'),
          onPressed: () {},
        );

    Widget startButton() => RaisedButton(
          child: Text('동의하고 시작하기'),
          onPressed: isStartButtonActive ? model.onStartButtonPressed : null,
          color: Colors.amber,
          disabledColor: Colors.grey,
        );

    return Form(
      key: model.key,
      child: Column(
        children: [
          phoneField(),
          sendButton(),
          if (model.isSendButtonPressed) certField(),
          if (model.isSendButtonPressed) termsButton(),
          if (model.isSendButtonPressed) startButton(),
        ],
      ),
    );
  }
}
