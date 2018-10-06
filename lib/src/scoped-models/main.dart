import 'package:scoped_model/scoped_model.dart';

import './connected_tasks.dart';

class MainModel extends Model
    with ConnectedTasksModel, UserModel, UtilityModel, TasksModel {}
