import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/auth.dart';

class EmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EmailPageState();
  }
}

class _EmailPageState extends State<EmailPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Email', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Invalid Password';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    if (_authMode == AuthMode.Login) {
      return Container();
    } else {
      return TextFormField(
        decoration: InputDecoration(
            labelText: 'Confirm Password',
            filled: true,
            fillColor: Colors.white),
        obscureText: true,
        validator: (String value) {
          if (_passwordTextController.text != value) {
            return 'Passwords do not match';
          }
        },
      );
    }
  }

  Widget _buildToggleButton() {
    return FlatButton(
      child:
          Text('Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
      onPressed: () {
        setState(() {
          _authMode =
              _authMode == AuthMode.Login ? AuthMode.Signup : AuthMode.Login;
        });
      },
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> status = await authenticate(
        _formData['email'], _formData['password'], _authMode);
    print(status);
    if (status['success'] == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('An Error Occurred!'),
              content: Text(status['message']),
              actions: <Widget>[
                FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Container(
          child: Center(
              child: SingleChildScrollView(
        child: Container(
            width: targetWidth,
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 70.0,
                    ),
                    Text('Email'),
                    SizedBox(height: 20.0),
                    _buildEmailTextField(),
                    SizedBox(height: 20.0),
                    _buildPasswordTextField(),
                    SizedBox(height: 20.0),
                    _buildPasswordConfirmTextField(),
                    SizedBox(height: 20.0),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                color: Colors.white,
                                child: Text(_authMode == AuthMode.Login
                                    ? 'Login'
                                    : 'Signup'),
                                onPressed: () => _submitForm(model.emailAuth));
                      },
                    ),
                    SizedBox(height: 20.0),
                    _buildToggleButton(),
                    SizedBox(height: 20.0),
                    FlatButton(
                      child: Text('Go back'),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/auth');
                        // Navigator.pop(context);
                      },
                    )
                  ],
                ))),
      ))),
    );
  }
}
