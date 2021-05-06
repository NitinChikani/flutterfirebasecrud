import 'dart:collection';

import 'package:firebase_crud/user.dart';
import 'package:firebase_crud/widget/EditRegister.dart';
import 'package:firebase_database/firebase_database.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class RegisterList extends StatefulWidget {
  @override
  _RegisterListState createState() => _RegisterListState();
}

class _RegisterListState extends State<RegisterList> {
  static final db = FirebaseDatabase.instance.reference().child("Registration");

  final dbRef = FirebaseDatabase.instance.reference().child("Registration");
  final firestoreInstance = FirebaseDatabase.instance;

  final List<User> _users = [];

  void updatedetails(String id, String key, String name, String email,
      String pass, String dob) {
    // Navigator.pop(context);

    Map<String, Object> createObj = new HashMap();
    createObj['name'] = name;
    createObj['email'] = email;
    createObj['pass'] = pass;
    createObj['dob'] = dob;
    db.child(key).update(createObj);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Update Successfully ..!')));

    setState(() {
      _users.removeWhere((tx) => tx.id == id);
    });
    final newTx = User(
      key: key,
      id: DateTime.now().toString(),
      name: name,
      email: email,
      pass: pass,
      dob: dob,
    );
    setState(() {
      _users.add(newTx);
    });
  }

  void updateRecord(String id, String key, String name, String email,
      String pass, String dob) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          child: EditRegister(id, name, email, key, pass, dob, updatedetails),
          onTap: () {
            Navigator.pop(context);
          },
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void deleteRecord(String id) {
    db.child(id).remove();
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Delete Successfully ..!')));
    setState(() {
      _users.removeWhere((tx) => tx.key == id);
    });
  }

  @override
  void initState() {
    debugPrint("InitState call");
    super.initState();

    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Registration");
    referenceData.once().then((DataSnapshot dataSnapShot) {
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;

      for (var key in keys) {
        debugPrint("key:");
        debugPrint(key);
        final newTx = User(
          key: key,
          id: DateTime.now().toString(),
          name: values[key]['name'],
          email: values[key]['email'],
          pass: values[key]['pass'],
          dob: values[key]['dob'],
        );
        setState(() {
          _users.add(newTx);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: _users.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No Transactions added! ',
                  style: Theme.of(context).textTheme.title,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    title: Text(
                      _users[index].name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(_users[index].name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.blue,
                            onPressed: () => updateRecord(
                                _users[index].id,
                                _users[index].key,
                                _users[index].name,
                                _users[index].email,
                                _users[index].pass,
                                _users[index].dob)),
                        IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => deleteRecord(_users[index].key)),
                      ],
                    ),
                  ),
                );
              },
              itemCount: _users.length,
            ),
    );
  }
}
