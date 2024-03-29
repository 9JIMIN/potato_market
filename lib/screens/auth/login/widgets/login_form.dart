import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../login_provider.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  void initState() {
    super.initState();
    context.read<LoginProvider>().onLoginInit();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<LoginProvider>(context, listen: false);
    final isSendButtonActive = context.select(
      (LoginProvider model) => model.isSendButtonActive,
    );
    final isStartButtonActive = context.select(
      (LoginProvider model) => model.isStartButtonActive,
    );
    final isLoading = context.select(
      (LoginProvider model) => model.isLoading,
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

    Widget sendButton() => ElevatedButton(
          child: Text(model.isSendButtonPressed ? '인증번호 다시받기' : '인증번호 받기'),
          onPressed: isSendButtonActive ? model.onSendButtonPressed : null,
        );

    Widget certField() => TextFormField(
          focusNode: model.certFieldFocus,
          controller: model.certFieldController,
          onChanged: model.onCertFieldChanged,
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

    Widget termsButton() => TextButton(
          child: Text('이용약관 및 개인정보취급방침'),
          onPressed: () {},
        );

    Widget startButton() => ElevatedButton(
          child: Text(isLoading ? '로딩중...' : '동의하고 시작하기'),
          onPressed: isStartButtonActive ? model.onStartButtonPressed : null,
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
