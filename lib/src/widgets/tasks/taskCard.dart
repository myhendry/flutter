import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../screens/taskDetail.dart';
import '../../screens/updateTask.dart';
import '../../models/task.dart';
import '../../scoped-models/main.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final int taskIndex;

  TaskCard(this.task, this.taskIndex);

  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://get.pxhere.com/photo/meditating-sunset-meditation-yoga-nature-peace-health-exercise-meditation-nature-woman-relax-yoga-meditation-silhouette-pose-sun-body-relaxation-sea-sunrise-wellness-female-lifestyle-yoga-woman-yoga-silhouette-sky-zen-calm-beach-yoga-poses-ocean-girl-spirituality-spiritual-beach-sunset-person-mind-harmony-young-woman-on-beach-sunset-beach-happiness-outdoor-afterglow-horizon-morning-sunlight-daytime-field-evening-red-sky-at-morning-ecoregion-dawn-orange-cloud-dusk-computer-wallpaper-1436281.jpg'),
            ),
            title: Text(task.title),
            subtitle: Text(task.amount.toString()),
          ),
          Row(
            children: <Widget>[
              Image.network(
                'https://get.pxhere.com/photo/meditating-sunset-meditation-yoga-nature-peace-health-exercise-meditation-nature-woman-relax-yoga-meditation-silhouette-pose-sun-body-relaxation-sea-sunrise-wellness-female-lifestyle-yoga-woman-yoga-silhouette-sky-zen-calm-beach-yoga-poses-ocean-girl-spirituality-spiritual-beach-sunset-person-mind-harmony-young-woman-on-beach-sunset-beach-happiness-outdoor-afterglow-horizon-morning-sunlight-daytime-field-evening-red-sky-at-morning-ecoregion-dawn-orange-cloud-dusk-computer-wallpaper-1436281.jpg',
                width: 150.0,
                height: 50.0,
              ),
              Image.asset(
                'assets/meditate1.jpeg',
                width: 150.0,
                height: 50.0,
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.details),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    // Navigator.pushNamed(context, '/taskDetail/${task.id}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskDetailPage(task: task)));
                  }),
              SizedBox(
                width: 20.0,
              ),
              IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateTaskPage(task: task)));
                  }),
              SizedBox(
                width: 20.0,
              ),
              ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return IconButton(
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        model.deleteTask(task.id);
                        model.fetchTasks();
                        //  Navigator.pushNamed(context, '/updateTask/${task.id}');
                      });
                },
              ),
              SizedBox(
                width: 20.0,
              ),
              ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return IconButton(
                      icon: Icon(Icons.favorite_border),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        //? Implement Favorite Toggle
                      });
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
