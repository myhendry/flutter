import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/task.dart';

class TaskDetailPage extends StatefulWidget {
  final Task task;

  TaskDetailPage({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TaskDetailPageState();
  }
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Detail')),
        body: Container(child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Column(
              children: <Widget>[
                widget.task == null ? '' : Text(widget.task.id),
                widget.task == null ? '' : Text(widget.task.title),
                widget.task == null ? '' : Text(widget.task.amount.toString()),
              ],
            );
          },
        )));
  }
}
