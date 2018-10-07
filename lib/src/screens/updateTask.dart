import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../models/task.dart';
import '../scoped-models/main.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task;

  UpdateTaskPage({Key key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UpdateTaskPageState();
  }
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'image': 'assets/meditate1.jpeg',
    'amount': null,
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    void _submitForm(Function updateTask) async {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();

      bool responseStatus = await updateTask(
          _formData['title'], _formData['amount'], widget.task.id);

      print(responseStatus);
      if (responseStatus) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong'),
                content: Text('Please try again!'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Okay'),
                  )
                ],
              );
            });
      }
    }

    Widget _buildTitleTextField(Task task) {
      return EnsureVisibleWhenFocused(
        focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Task Title'),
          initialValue: task == null ? '' : task.title,
          validator: (String value) {
            if (value.isEmpty || value.length < 5) {
              return 'Title is required and must be more than 5 characters';
            }
          },
          onSaved: (String value) {
            _formData['title'] = value;
          },
        ),
      );
    }

    Widget _buildAmountTextField(Task task) {
      return EnsureVisibleWhenFocused(
        focusNode: _amountFocusNode,
        child: TextFormField(
          focusNode: _amountFocusNode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'Task Amount'),
          initialValue: task == null ? '' : task.amount.toString(),
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
              return 'Price is required and should be a number.';
            }
          },
          onSaved: (String value) {
            _formData['amount'] = int.parse(value);
          },
        ),
      );
    }

    Widget _buildSubmitButton() {
      return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RaisedButton(
            child: Text('Save'),
            onPressed: () => _submitForm(model.updateTask),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Container(
        child: Form(
            key: _formKey,
            child: ScopedModelDescendant(
              builder: (BuildContext context, Widget child, MainModel model) {
                return ListView(
                  padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                  children: <Widget>[
                    _buildTitleTextField(widget.task),
                    SizedBox(height: 20.0),
                    _buildAmountTextField(widget.task),
                    SizedBox(height: 20.0),
                    _buildSubmitButton()
                  ],
                );
              },
            )),
      ),
    );
  }
}
