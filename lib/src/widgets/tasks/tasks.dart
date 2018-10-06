import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../models/task.dart';
import '../tasks/taskCard.dart';

class Tasks extends StatelessWidget {
  Widget _buildTasksList(List<Task> tasks, MainModel model) {
    Widget taskCards;
    if (tasks.length > 0) {
      taskCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(tasks[index].id),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                // Todo
                model.deleteTask(tasks[index].id);
                model.fetchTasks();
              }
            },
            background: Container(
              color: Colors.red,
            ),
            child: TaskCard(tasks[index], index),
          );
        },
        itemCount: tasks.length,
      );
    } else {
      taskCards = Container();
    }
    return taskCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildTasksList(model.allTasks, model);
      },
    );
  }
}
