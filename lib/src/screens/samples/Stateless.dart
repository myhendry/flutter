import 'package:flutter/material.dart';

import '../../widgets/ui/side.dart';

class StatelessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stateless')),
      drawer: Side(),
      body: Container(
        child: Text('Body'),
      ),
    );
  }
}
