import 'dart:convert';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';
import '../models/auth.dart';
import '../models/car.dart';
import '../models/task.dart';
import '../configuration/config.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class ConnectedTasksModel extends Model {
  List<Task> _tasks = [];
  Task _task;
  List<Car> _cars = [];
  // Car _car;
  User _authenticatedUser;
  bool _isLoading = false;
}

class TasksModel extends ConnectedTasksModel {
  List<Task> get allTasks {
    return List.from(_tasks);
  }

  Task get selectedTask {
    return _task;
  }

  Future<bool> deleteTask(String selectedTaskId) async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('tasks').document(selectedTaskId);
      await documentReference.delete();

      // await http.delete(
      //     'https://manager1-ae03e.firebaseio.com/tasks/$selectedTaskId.json?auth=${_authenticatedUser.token}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchTask(String selectedTaskId) async {
    _isLoading = true;
    notifyListeners();
    try {
      http.Response response = await http.get(
          'https://manager1-ae03e.firebaseio.com/tasks/$selectedTaskId.json?auth=${_authenticatedUser.token}');
      final Map<String, dynamic> data = json.decode(response.body);
      final Task task = Task(
          id: selectedTaskId,
          title: data['title'],
          image: data['image'],
          amount: data['amount']);
      _isLoading = false;
      _task = task;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Null> fetchTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      // FirebaseUser user = await _auth.currentUser();

      // GET USING FIRESTORE
      final QuerySnapshot query =
          await Firestore.instance.collection('tasks').getDocuments();
      List<DocumentSnapshot> docs = query.documents;
      final List<Task> tasksList = [];
      if (docs.isNotEmpty) {
        docs.forEach((doc) {
          final Task task = Task(
              id: doc.documentID,
              title: doc.data['title'],
              amount: doc.data['amount'],
              image: doc.data['image']);
          tasksList.add(task);
        });
        _tasks = tasksList;
      }

      // final DocumentReference docRef =
      //     Firestore.instance.document('tasks/${user.uid}');
      // QuerySnapshot query = await docRef.get();

      // query.documents

      // final List<Task> tasksList = [];
      // if (query.exists) {
      //   Map<String, dynamic> docs = query.data;
      //   docs.forEach((key, val) {
      //     final Task task = Task(
      //       id: query.documentID,
      //       title: docs['title'],
      //       amount: docs['amount'],
      //       image: docs['image'],
      //     );
      //     tasksList.add(task);
      //   });
      //   _tasks = tasksList;
      //   print(_tasks);
      // }

// #region Alternative
      // GET USING FIREBASE
      // final DatabaseReference db =
      //     FirebaseDatabase.instance.reference().child('tasks/${user.uid}');

      // DataSnapshot snapshot = await db.once();
      // Map<dynamic, dynamic> val = snapshot.value;
      // final List<Task> tasksList = [];
      // val.forEach((key, val) {
      //   final Task task = Task(
      //     id: key.toString(),
      //     title: val['title'],
      //     amount: val['amount'],
      //     image: val['image'],
      //   );
      //   tasksList.add(task);
      // });
      // _tasks = tasksList;

      // GET USING REST
      // final http.Response response = await http.get(
      //     'https://manager1-ae03e.firebaseio.com/tasks.json/?auth=${_authenticatedUser.token}');
      // final Map<String, dynamic> tasksData = json.decode(response.body);

      // if (tasksData == null) {
      //   _isLoading = false;
      //   notifyListeners();
      //   return;
      // }

      // // Convert tasksData from Map to List
      // final List<Task> tasksList = [];

      // tasksData.forEach((String taskId, dynamic t) {
      //   final Task task = Task(
      //       id: taskId,
      //       title: t['title'],
      //       amount: t['amount'],
      //       image: t['image']);
      //   tasksList.add(task);
      // });
      // _tasks = tasksList;
// #endregion

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return;
    }
  }

  Future<bool> addTask(String title, int amount) async {
    _isLoading = true;
    notifyListeners();

    // FirebaseUser user = await _auth.currentUser();

    final Map<String, dynamic> taskData = {
      'title': title,
      'amount': amount,
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
      'userId': _authenticatedUser.id
    };
    try {
      // ADD USING FIRESTORE
      // final DocumentReference docRef =
      //     Firestore.instance.document('tasks/${user.uid}');
      CollectionReference collectionReference =
          Firestore.instance.collection('tasks');
      await collectionReference.add(taskData);

// #region Alternatives
      // ADD USING REAL TIME FIREBASE
      // final DatabaseReference db =
      //     FirebaseDatabase.instance.reference().child('tasks/${user.uid}');
      //   await db.push().set(taskData);

      // ADD USING REST API
      // final http.Response response = await http.post(
      //     'https://manager1-ae03e.firebaseio.com/tasks.json?auth=${_authenticatedUser.token}',
      //     body: json.encode(taskData));

      // if (response.statusCode != 200 && response.statusCode != 201) {
      //   _isLoading = false;
      //   notifyListeners();
      //   return false;
      // }
// #endregion

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask(String title, int amount, String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      final Map<String, dynamic> updateData = {
        'title': title,
        'amount': amount,
        'image':
            'https://upload.wikimedia.org/wikipedia/commons/6/68/Chocolatebrownie.JPG',
        'userId': _authenticatedUser.id
      };
      // UPDATE USING FIRESTORE
      DocumentReference documentReference =
          Firestore.instance.collection('tasks').document(id);
      documentReference.updateData(updateData);

      // await http.put(
      //     'https://manager1-ae03e.firebaseio.com/tasks/$id.json?auth=${_authenticatedUser.token}',
      //     body: json.encode(updateData));

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class CarModel extends ConnectedTasksModel {
  List<Car> get allCars {
    return List.from(_cars);
  }

  Future<Null> getCars() async {
    _isLoading = true;
    notifyListeners();
    try {
      final QuerySnapshot query =
          await Firestore.instance.collection('cars').getDocuments();
      List<DocumentSnapshot> docs = query.documents;
      final List<Car> carList = [];
      if (docs.isNotEmpty) {
        docs.forEach((doc) {
          final Car car = Car(
            id: doc.documentID,
            name: doc.data['name'],
            owner: _authenticatedUser.id,
          );
          carList.add(car);
        });
        _cars = carList;
      }
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCar(String name) async {
    _isLoading = true;
    notifyListeners();

    // FirebaseUser user = await _auth.currentUser();

    final Map<String, dynamic> newCar = {
      'name': name,
      'owner': _authenticatedUser.id
    };
    try {
      CollectionReference collectionReference =
          Firestore.instance.collection('cars');
      await collectionReference.add(newCar);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCar(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('cars').document(id);
      await documentReference.delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class UserModel extends ConnectedTasksModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

//! DONE
  Future<Map<String, dynamic>> emailAuth(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    try {
      FirebaseUser user;

      if (mode == AuthMode.Login) {
        user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        print(user);
      } else {
        user = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(user);
      }

      _authenticatedUser =
          User(id: user.uid, email: user.email, token: 'dummy');
      print(_authenticatedUser);

      print(
          'User is ${_authenticatedUser.email} + ${_authenticatedUser.token}');

      _userSubject.add(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', user.email);
      prefs.setString('userId', user.uid);

      return {'success': true, 'message': ''};
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Authentication Failed'};
    }
  }

//! DONE
  Future<bool> googleAuth() async {
    try {
      _isLoading = true;
      notifyListeners();
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

      FirebaseUser user = await _auth.signInWithGoogle(
          idToken: gSA.idToken, accessToken: gSA.accessToken);

      _authenticatedUser =
          User(id: user.uid, email: user.email, token: gSA.idToken);

      // Toggle isAuthenticated State using RxDart
      _userSubject.add(true);

      // Update Local AsyncStorage
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', user.email);
      prefs.setString('userId', user.uid);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
// Toggle Loading Flag
    _isLoading = true;
    notifyListeners();

// Set up Auth User Details
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

//? Converting to Direct Firebase Auth
    // if (mode == AuthMode.Login) {
    //   FirebaseUser user = await _auth.signInWithEmailAndPassword(
    //       email: email, password: password);
    //   print(user);
    // }

// Depend on AuthMode, either Login or Signup
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=$key',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$key',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

// Get Response Data
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);

// If Response Successful
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';

// Update Global State AuthenticatedUser
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

// Set AuthTimeout
      setAuthTimeout(int.parse(responseData['expiresIn']));

// Toggle isAuthenticated State using RxDart
      _userSubject.add(true);

// Update Local AsyncStorage
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (
// Else Login/Signup Unsuccessful
        responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }

// Toggle Loading State
    _isLoading = false;
    notifyListeners();

// Return Map
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
// If Authenticated
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);

// If Expired, logout user
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }

// Else authenticated, authenticate user again by setting Global State AuthenticatedUser, update userSubject in RxDart
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
// Set Global State AuthenticatedUser to null
    _authenticatedUser = null;

// Clear AuthTimer
    _authTimer.cancel();

// Set isAuthenticated in RxDart
    _userSubject.add(false);

// Remove AsyncStorage
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');

    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

class UtilityModel extends ConnectedTasksModel {
  bool get isLoading {
    return _isLoading;
  }
}
