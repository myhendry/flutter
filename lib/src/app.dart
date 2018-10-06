import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './scoped-models/main.dart';
import './screens/auth.dart';
import './screens/email.dart';
import './screens/home.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _App();
  }
}

class _App extends State<App> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    // _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: _model,
        child: MaterialApp(
          title: 'App',
          theme: ThemeData(
              primaryColor: Colors.lightBlue, buttonColor: Colors.teal),
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            switch ('/${pathElements[1]}') {
              case '/':
                return MaterialPageRoute(builder: (_) {
                  return _isAuthenticated ? HomePage() : AuthPage();
                });
              case '/auth':
                return MaterialPageRoute(builder: (_) => AuthPage());
              case '/email':
                return MaterialPageRoute(builder: (_) => EmailPage());
              case '/home':
                return MaterialPageRoute(builder: (_) => HomePage());
            }
          },
        ));
  }
}
