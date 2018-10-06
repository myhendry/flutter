import 'package:flutter/material.dart';

import './logout_list_tile.dart';

class Side extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Choose'),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance),
            title: Text('Show Tasks'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/showTasks');
            },
          ),
          LogoutListTile()
        ],
      ),
    );
  }
}
