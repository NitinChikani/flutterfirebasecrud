import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String fname;
  String femail;
  String fdob;
  String fpwd;

  // ignore: unused_field
  static final db = FirebaseDatabase.instance.reference().child("Registration");

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;
  //Raise Button
  void _validation() {
    final name = _nameController.text;
    final email = _emailController.text;
    final pass = _pwdController.text;
    final dob = _dobController.text;

    setState(() {
      _autoValidate = true;
      fname = name;
      femail = email;
      fdob = dob;
      fpwd = pass;

      db.push().set({
        "name": _nameController.text,
        "email": _emailController.text,
        "dob": _dobController.text,
        "pass": _pwdController.text,
      }).then((_) {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Registration Successfully ..!')));
        _nameController.clear();
        _emailController.clear();
        _pwdController.clear();
        _dobController.clear();
        _cpwdController.clear();
        _autoValidate = false;
      }).catchError((onError) {
        print(onError);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formkey,
            autovalidate: _autoValidate,
            child: FormUI(),
          ),
        ),
      ),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectDate = pickedDate;

        _dobController.text = pickedDate.toString();
      });
    });
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _cpwdController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime _selectDate;

  Widget FormUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(hintText: "Enter Your Name"),
          controller: _nameController,
          validator: (String value) {
            if (value.isEmpty) {
              return "Name Required";
            } else {
              return null;
            }
          },
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Enter Your Email"),
          controller: _emailController,
          validator: (value) => EmailValidator.validate(value)
              ? null
              : "Please enter a valid email",
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Date Of Birth"),
          controller: _dobController,
          onTap: _presentDatePicker,
        ),
        TextFormField(
            decoration: InputDecoration(hintText: "Enter Password"),
            obscureText: true,
            controller: _pwdController,
            validator: (val) {
              if (val.isEmpty) {
                return 'Password Required';
              }
              if (val.length < 6) {
                return 'Password must be atleast 8 characters long';
              }
              return null;
            }),
        TextFormField(
            decoration: InputDecoration(hintText: "Enter Confirm Password"),
            obscureText: true,
            controller: _cpwdController,
            validator: (val) {
              if (val.isEmpty) {
                return 'Empty';
              }
              if (val != _pwdController.text) {
                return 'Not Match';
              }
              return null;
            }),
        RaisedButton(
          onPressed: _validation,
          child: Text('Register'),
        ),
      ],
    );
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
