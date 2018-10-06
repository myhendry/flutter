import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  void _googleLogin(Function authenticate) async {
    bool status = await authenticate();
    if (status) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 250.0,
                child: ScopedModelDescendant(
                  builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return RaisedButton(
                      child: Text('Google Login'),
                      color: Colors.green,
                      onPressed: () => _googleLogin(model.googleAuth),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  child: Text('Facebook Login'),
                  color: Colors.blueAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/list');
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  child: Text('Email'),
                  color: Colors.yellow,
                  onPressed: () {
                    // Navigator.pushNamed(context, '/email');
                    Navigator.pushReplacementNamed(context, '/email');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
