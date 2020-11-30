import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:potato_market/screens/auth/auth_model.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: Card(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<LoginForm> {
  FocusNode _nameFocus;
  FocusNode _emailFocus;
  FocusNode _passwordFocus;

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    final model = Provider.of<AuthModel>(context);

    Widget nameField() => TextFormField(
          key: ValueKey(1),
          focusNode: _nameFocus,
          decoration: InputDecoration(labelText: '이름'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          validator: model.onNameValidate,
          onSaved: model.onNameSaved,
        );

    Widget emailField() => TextFormField(
          key: ValueKey(2),
          focusNode: _emailFocus,
          decoration: InputDecoration(labelText: '이메일'),
          textInputAction: TextInputAction.next,
          onEditingComplete: () => node.nextFocus(),
          validator: model.onEmailValidate,
          onSaved: model.onEmailSaved,
        );

    Widget passwordField() => TextFormField(
          key: ValueKey(3),
          focusNode: _passwordFocus,
          decoration: InputDecoration(labelText: '비번'),
          textInputAction: TextInputAction.done,
          onEditingComplete: () {
            node.unfocus();
            model.onSubmit();
          },
          validator: model.onPasswordValidate,
          onSaved: model.onPasswordSaved,
        );

    Widget submitButton() => RaisedButton(
          child: Text(model.isLogin ? '로그인' : '가입'),
          onPressed: () async {
            await model.onSubmit();
          },
        );

    Widget changeButton() => RaisedButton(
          child: Text(model.isLogin ? '새로 만들기' : '이미 계정이 있음'),
          onPressed: model.onChange,
        );

    return Form(
      key: model.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!model.isLogin) nameField(),
          emailField(),
          passwordField(),
          if (model.isLoading) CircularProgressIndicator(),
          if (!model.isLoading) submitButton(),
          if (!model.isLoading) changeButton(),
        ],
      ),
    );
  }
}
