import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/helpers/ensure_visible.dart';
import '../scoped-models/main.dart';
import '../widgets/ui/side.dart';

class ListenerPage extends StatefulWidget {
  final MainModel model;

  ListenerPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ListenerPageState();
  }
}

class _ListenerPageState extends State<ListenerPage> {
  final Map<String, dynamic> _formData = {
    'name': null,
  };
  final GlobalKey<FormState> _carFormKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  StreamSubscription<QuerySnapshot> subscription;
  CollectionReference carsCollectionRef = Firestore.instance.collection('cars');

  @override
  void initState() {
    super.initState();
    widget.model.getCars();
    subscription = carsCollectionRef.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) {
        print('changed');
        widget.model.getCars();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
    print('disposed');
  }

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

    return Scaffold(
      appBar: AppBar(title: Text('Listener')),
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
              child: ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return ListView.builder(
                    itemCount: model.allCars.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(model.allCars[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            model.deleteCar(model.allCars[index].id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),
            _buildSubmitButton()
          ],
        ),
      ),
    );
  }
}
