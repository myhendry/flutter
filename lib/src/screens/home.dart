import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../widgets/ui/side.dart';
import '../widgets/tasks/tasks.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchTasks();
  }

  Widget _buildList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(
          child: Text('No Task Found'),
        );
        if (model.allTasks.length > 0 && !model.isLoading) {
          content = Tasks();
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(onRefresh: model.fetchTasks, child: content);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Side(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/addTask');
        },
      ),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _buildList(),
    );
  }
}
