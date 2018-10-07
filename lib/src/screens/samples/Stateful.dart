import 'package:flutter/material.dart';

import '../../widgets/ui/side.dart';

class StatefulPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatefulPageState();
  }
}

class _StatefulPageState extends State<StatefulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stateful')),
      drawer: Side(),
      body: Container(
        child: Text('Body'),
      ),
    );
  }
}
