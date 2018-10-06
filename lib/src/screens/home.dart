import 'package:flutter/material.dart';

import '../widgets/ui/side.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: Side(),
      body: Container(
        child: Text('Home'),
      ),
    );
  }
}
