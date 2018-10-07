import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../scoped-models/main.dart';
import '../widgets/ui/side.dart';

class CarsPage extends StatefulWidget {
  final MainModel model;

  CarsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CarsPageState();
  }
}

class _CarsPageState extends State<CarsPage> {
  final Map<String, dynamic> _formData = {
    'name': null,
  };
  final GlobalKey<FormState> _carFormKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    void _submitForm(Function addCar) async {
      if (!_carFormKey.currentState.validate()) {
        return;
      }
      _carFormKey.currentState.save();

      bool responseStatus = await addCar(_formData['name']);

      print(responseStatus);
      // if (responseStatus) {
      //   Navigator.pushReplacementNamed(context, '/showTasks');
      // } else {
      //   showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return AlertDialog(
      //           title: Text('Something went wrong'),
      //           content: Text('Please try again!'),
      //           actions: <Widget>[
      //             FlatButton(
      //               onPressed: () => Navigator.of(context).pop(),
      //               child: Text('Okay'),
      //             )
      //           ],
      //         );
      //       });
      // }
    }

    Widget _buildNameField() {
      return EnsureVisibleWhenFocused(
        focusNode: _nameFocusNode,
        child: TextFormField(
          focusNode: _nameFocusNode,
          decoration: InputDecoration(labelText: 'Car Name'),
          validator: (String value) {
            if (value.isEmpty || value.length < 2) {
              return 'Car Name is required and must be more than 2 characters';
            }
          },
          onSaved: (String value) {
            _formData['name'] = value;
          },
        ),
      );
    }

    Widget _buildSubmitButton() {
      return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return RaisedButton(
            child: Text('Save'),
            onPressed: () => _submitForm(model.addCar),
          );
        },
      );
    }

    Widget _buildListItem(
        BuildContext context, DocumentSnapshot document, MainModel model) {
      return ListTile(
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            model.deleteCar(document.documentID);
          },
        ),
        title: Text(document['name']),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Car')),
      drawer: Side(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
        child: Column(
          children: <Widget>[
            Container(
                child: Form(
              key: _carFormKey,
              child: _buildNameField(),
            )),
            SizedBox(height: 10.0),
            Expanded(
                child: StreamBuilder(
              stream: Firestore.instance.collection('cars').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) => _buildListItem(
                      context, snapshot.data.documents[index], widget.model),
                );
              },
            )),
            SizedBox(height: 10.0),
            _buildSubmitButton()
          ],
        ),
      ),
    );
  }
}
