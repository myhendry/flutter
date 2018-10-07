import 'package:flutter/material.dart';

import '../widgets/ui/side.dart';

class ListenerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListenerPageState();
  }
}

class _ListenerPageState extends State<ListenerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listener')),
      drawer: Side(),
      body: Container(
        child: Text('Body'),
      ),
    );
  }
}
